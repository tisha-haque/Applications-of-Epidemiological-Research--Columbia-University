**************************************************************************************
**	P8483: Spring 2020														     	**
**	Homework 2																	**
**  Name: Tisha Haque                                                                          **
**  UNI: tnh2115																        **
**************************************************************************************;
*Question 1;
LIBNAME HW2 xport "/home/u45142172/sasuser.v94/BMX_B.XPT";

Data BMX_B;set HW2.BMX_B;
run;

LIBNAME HW2 xport "/home/u45142172/sasuser.v94/BPQ_B.XPT";

Data BPQ_B;set HW2.BPQ_B;
run;

LIBNAME HW2 xport "/home/u45142172/sasuser.v94/CFQ_B.XPT";

Data CFQ_B;set HW2.CFQ_B;
run;

LIBNAME HW2 xport "/home/u45142172/sasuser.v94/DEMO_B.XPT";

Data DEMO_B;set HW2.DEMO_B;
run;

LIBNAME HW2 xport "/home/u45142172/sasuser.v94/PAQ_B.XPT";

Data PAQ_B;set HW2.PAQ_B;
run;

*Question 2;
PROC SORT DATA= BMX_B OUT= BMXSORT;
BY SEQN;
RUN;

PROC SORT DATA= BPQ_B OUT= BPQSORT;
BY SEQN;
RUN;

PROC SORT DATA= CFQ_B OUT= CFQSORT;
BY SEQN;
RUN;

PROC SORT DATA= DEMO_B OUT= DEMOSORT;
BY SEQN;
RUN;

PROC SORT DATA= PAQ_B OUT= PAQSORT;
BY SEQN;
RUN;

/*. Yes, you need to SORT each table downloaded from NHANES prior to merging because to help SAS 
find the common rows, we need to sort both databases to be merged by the unique ID, in this case 
SEQN. If you don’t sort first, you will get an error. */



DATA COMPLETE;
MERGE BMX_B BPQ_B CFQ_B DEMO_B PAQ_B; BY SEQN;
RUN;

*QUESTION 3
 NOTE: There were 10477 observations read from the data set WORK.BMX_B.
 NOTE: There were 6634 observations read from the data set WORK.BPQ_B.
 NOTE: There were 1872 observations read from the data set WORK.CFQ_B.
 NOTE: There were 11039 observations read from the data set WORK.DEMO_B.
 NOTE: There were 10094 observations read from the data set WORK.PAQ_B.
 NOTE: The data set WORK.COMPLETE has 11039 observations and 124 variables.;
 
*QUESTION 4;

DATA FINAL;
SET COMPLETE (KEEP = SEQN RIAGENDR RIDAGEYR RIDRETH1 DMDEDUC2 DMDEDUC DMDMARTL BMXWT BMXHT 
BMXBMI BMXWAIST CFDRIGHT PAD480 PAQ500 PAQ520 BPQ010 BPQ020 BPQ030 BPQ060 BPQ070 BPQ080);
RUN; 
 
*This code can be used to check the variables in the dataset;

PROC PRINT DATA = FINAL;
VAR SEQN RIAGENDR RIDAGEYR RIDRETH1 DMDEDUC2 DMDEDUC DMDMARTL BMXWT BMXHT
BMXBMI BMXWAIST CFDRIGHT PAD480 PAQ500 PAQ520 BPQ010 BPQ020 BPQ030 BPQ060
BPQ070 BPQ080;
RUN;
 
*QUESTION 5;
DATA FINAL2;
SET FINAL;
IF RIDAGEYR <60 OR RIDAGEYR >=80 OR RIDAGEYR =. THEN DELETE;
IF PAD480 IN (77,99,.) THEN DELETE;
IF CFDRIGHT = . THEN DELETE;
RUN;
*NOTE: The data set WORK.FINAL2 has 1166 observations and 21 variables.;


 *QUESTION 6;
PROC PRINT DATA = FINAL2;
RUN;
*NOTE: There were 1166 observations read from the data set WORK.FINAL2.
 NOTE: PROCEDURE PRINT used (Total process time);
 
 
 *QUESTION 7;

PROC RANK DATA= FINAL2 GROUPS =4 OUT= FINAL3;
VAR CFDRIGHT;
RANKS DSST_RANK;
RUN;

PROC FREQ DATA = FINAL3;
TABLE DSST_RANK;
RUN;

DATA FINAL4;
SET FINAL3;

IF RIDRETH1 = . THEN RACE = .;
ELSE IF RIDRETH1 = 1 THEN RACE = 0;
ELSE IF RIDRETH1 = 3 THEN RACE = 1;
ELSE IF RIDRETH1 = 4 THEN RACE = 2;
ELSE IF RIDRETH1 = 2 OR 5 THEN RACE = 3;

IF RIAGENDR = . THEN GENDER = .;
ELSE IF RIAGENDR = 1 THEN GENDER = 0;
ELSE IF RIAGENDR = 2 THEN GENDER = 1;


IF BMXBMI = . THEN BMICAT = .;
ELSE IF BMXBMI < 25 THEN BMICAT = 0;
ELSE IF BMXBMI =>25 AND BMXBMI <30 THEN BMICAT = 1;
ELSE IF BMXBMI => 30 THEN BMICAT = 2;
RUN;


*QUESTION 8;

PROC FORMAT;
VALUE DSSTF 0="DSST Quartile 1" 1= "DSST Quartile 2" 2="DSST Quartile 3" 3="DSST Quartile 4";
VALUE RACEF 0= "MEXICAN AMERICAN" 1= "WHITE" 2= "BLACK" 3="OTHER RACE";
VALUE GENDERF 0="MALE" 1= "FEMALE";
VALUE BMICATF 0="NORMAL BMI" 1= "OVERWEIGHT BMI" 2="OBESE BMI";
RUN; 

DATA FINAL4F; SET FINAL4;
FORMAT DSST DSSTF. RACE RACEF. GENDER GENDERF. BMICAT BMICATF.;
RUN;

PROC FREQ DATA=FINAL4F;
TABLE DSST_RANK RACE GENDER BMICAT;
RUN;

*QUESTION 9;

PROC MEANS MEAN MIN MAX STD DATA=FINAL4F MAXDEC=1;
VAR PAD480 CFDRIGHT;
RUN;

/* RESULTS FOR EACH VARIABLE:
A) PAD480 (SENDENTARY BEHAVIOR)
	1. MEAN =2.9 DAILY HOURS OF TV, VIDEO OR COMP USE
	2. MINIMUM= 0.0
	3. MAXIMUM= 6.0
	4. SD: 1.5
B) CFDRIGHT(COGNITIVE FUNCTION)
	1. MEAN: 45.5 SCORE FOR # OF CORRECT ANSWERS
	2. MINIMUM= 0.0
	3. MAXIMUM= 100.00
	4. SD= 18.2
*/

PROC MEANS MEAN DATA= FINAL4F MAXDEC=1;
VAR PAD480 CFDRIGHT;
CLASS BMICAT;
RUN;

/* 
A) NORMAL BMI (BMI=0)	
- MEAN FOR PAD480 = 2.6 Daily hours of TV, video or computer use
- MEAN FOR CFDRIGHT= 46.4 Score: number correct
B) OVERWEIGHT BMI (BMI=1)	
- MEAN FOR PAD480 = 2.8 Daily hours of TV, video or computer use
- MEAN FOR CFDRIGHT= 46.3 Score: number correct
C) OBESE BMI (BMI=2)	
- MEAN FOR PAD480 = 3.1 Daily hours of TV, video or computer use
- MEAN FOR CFDRIGHT= 45.9 Score: number correct

YES, THERE SEEMS TO BE A PATTERN BTW BMI AND THESE 2 VARIABLES BC AS THE BMI INCREASES, THE MEAN 
NUMBER OF DAILY HOURS OF TV, video or computer use INCREASES AS A MEASURE OF SEDENTARY BEHAVIOR. 
FURTHURMORE, AS BMI INCREASES, THE SCORE ON THE COGNITIVE TEST SEEMS TO BE DECREASING. 
WE CAN DEFINITLY TEST AN ASSOCIATION BETWEEN THIS POTENTIAL CONFOUNDER AND THE 
EXPOSURE OF INTEREST (SEDENTARY BEHAVIOR) AS WELL AS THE OUTCOME OF INTEREST(COGNITIVE FUNCTION).
*/


*QUESTION 10;
PROC FREQ DATA= FINAL4F;
TABLE DMDMARTL DSST_RANK;
RUN;
* ASSUMING WE ARE STILL USING THE FINAL4F DATASET, ACCORDING TO THE CODEBOOK THE VARIABLE
DMDMARTL, THE VALUES FOR "MARRIED" AND "NOT NEVER MARRIED' ARE 1 AND 5 RESPECTIVELY. 
WE WILL CHANGE THE LABELS FOR THESE CATEGORIES FOR THE DMDMARTL VARIABLE.;  

PROC FORMAT;
VALUE DMDMARTLF 1="MARRIED" 5="NEVER MARRIED";
RUN;

* WE CAN DO THE SAME FOR THE LABELS OF THE DSST VARIABLE, WHERE WE WANT Q1 TO Q3
to be called lower 75th percentile and Q4 to be top 25th percentile;

PROC FORMAT;
VALUE DSSTPERCENTILE
0= "LOWER 75TH PERCENTILE DSST SCORE"
1= "LOWER 75TH PERCENTILE DSST SCORE"
2= "LOWER 75TH PERCENTILE DSST SCORE"
3= "TOP 25TH PERCENTILE DSST SCORE";
RUN;

DATA FINAL4FF; SET FINAL4F;
FORMAT DMDMARTL DMDMARTLF.;
FORMAT DSST_RANK DSSTPERCENTILE.;
RUN;

*NOW TO SEE THE DSST SCORES BY MARITAL STATUS, WE HAVE:;

PROC FREQ DATA = FINAL4FF;
TABLE DSST_RANK*DMDMARTL;
WHERE DMDMARTL =1 OR DMDMARTL =5;
RUN;

* OUTPUT 
LOWER 75TH PERCENTILE DSST SCORE
MARRIED FREQUENCY: 66.58%
NEVER MARRIED FREQUENCY: 3.80%

TOP 25TH PERCENTILE DSST SCORE
MARRIED FREQUENCY: 28.31%
NEVER MARRIED FREQUENCY: 1.31%

Individuals categorized as “MARRIED” are more likely than individuals 
categorized as “NEVER MARRIED” of being both the top 25th percentile of DSST 
(66.58 vs. 3.8%) and lower 75th percentile of DSST (28.31% vs. 1.31%).; 

*QUESTION 11;

LIBNAME PERM "/home/u45142172/sasuser.v94;  
DATA PERM.FINAL4;
SET FINAL4;
RUN;


 



