**************************************************************************************
**	P8483: Spring 2020														     	**
**	Homework 3																	**
**  Name: Tisha Haque                                                                          **
**  UNI: tnh2115																        **
**************************************************************************************;
*Question 1A;

libname HW3 "/home/u45142172/my_courses/mrl2013/RAW DATA/";
run;


*Question 1B;
data work.question1;
set HW3.Final4_b;
run;

proc contents data= question1;
run;
*They are numerical, categorical variables;


*Question 1C;

Proc means nmiss data = question1;
run;
*
THE FOLLOWING HAVE VARIABLES WITH MISSING INFORMATION 
BPQ020- 3
BPQ030- 556
BPQ070- 141
BPQ080- 141
BMXWT- 105
BMXHT- 105
BMXBMI- 133
BMXWAIST- 118
BMICAT-133 ;

*Question 1D;

proc freq data= question1;
run;

*THE FOLLOWING variables have responses that have a numeric response, but the 
value of this response is “don’t know”, ”refused”, or ”missing”
DMDEDUC2- NO OBSERVED
DMDEDUC- NO OBSERVED
DMDMARTL- NO OBSERVED
PAD480- NO OBSERVED
PAQ500- 1 "DON'T KNOW" OBSERVED
PAQ520- 24 "DON'T KNOW" OBSERVED
BPQ 10- NO OBSERVED
BPQ 20- 1 "DON'T KNOW" OBSERVED
BPQ 30- 5 "DON'T KNOW" OBSERVED
BPQ 60- 34 "DON'T KNOW" OBSERVED
BPQ 70- 11 "DON'T KNOW" OBSERVED
BPQ 80- 9 "DON'T KNOW" OBSERVED;


*Question 1E;

Proc means mean median data = question1;
var CFDRIGHT;
run;

*Mean		Median
45.5420240	45.5000000

THIS PROVIDES AN EVIDENCE FOR the assumption that CFDRIGHT is 
approximately normally distributed becuase the mean and median are very 
similar.;

*Question 1F;

proc univariate data= question1;
var CFDRIGHT;
histogram CFDRIGHT/normal;
run;

*CFDRIGHT can be treated as approximately normally distributed becuase
the curve overlaps the data well.;

*Question2A;

data work.question2;
set HW3.Final4_b;
run;

*Question2B;

PROC FORMAT;
VALUE PAD480F 0="LESS THAN 1 HR" 1="1 HOUR" 2="2 HOURS" 3="3 HOURS" 
4="4 HOURS" 5="5 HOURS" 6="6 HOURS" 77= "REFUSED" 99= "DON'T KNOW" .= "MISSING";
RUN; 

DATA QUESTION2; SET QUESTION2;
FORMAT PAD480 PAD480F.;

*Question2C;

PROC FREQ DATA= QUESTION2;
TABLE PAD480;
RUN;

*Question2D;

PROC MEANS MEAN DATA=QUESTION2 MAXDEC=1;
CLASS PAD480; 
VAR CFDRIGHT;
RUN;

*Question2E;
*
LESS THAN 1 HR: 46.5
1 HOUR: 43.9
2 HOURS: 45.4
3 HOURS: 47.1
4 HOURS: 48.5
5 HOURS: 43.2
6 HOURS: 40.4

There seems to be no pattern between category of PAD480 
and mean CFD score because the mean values fluctuate as you 
increase the hours as seen from 43.9 to 48.5 to 40.4;


*Question3A;
data work.question3;
set HW3.Final4_b;
run;

*Question3B;

DATA question3;
SET question3;

IF PAD480 =0 or PAD480 =1 or PAD480 =6 THEN PAD480_N = 0;
else IF PAD480 =2 or PAD480 =3 THEN PAD480_N =1;
else IF PAD480 =4 or PAD480 =5 THEN PAD480_N =2;
RUN;


PROC FORMAT;
VALUE PAD480_NF 0 = "less than or equal to 1 daily hour of TV, video, or computer use" 
1 = "2 to 3 daily hours of TV, video, or computer use" 
2 = "4 or more daily hours of TV, video, or computer use"; 
RUN; 


*Question 3C;

DATA QUESTION3; SET QUESTION3;
FORMAT PAD480_N PAD480_NF.;
run;

*Question 3D;

PROC FREQ DATA= QUESTION3;
TABLE PAD480_N;
RUN;


*PAD480_N	
less than or equal to 1 daily hour of TV, video, or computer use: 19.47	
2 to 3 daily hours of TV, video, or computer use: 47.34	
4 or more daily hours of TV, video, or computer use: 33.19;	

*Question 3E;


PROC MEANS MEAN DATA=QUESTION3 MAXDEC=1;
CLASS PAD480_N; 
VAR CFDRIGHT;
RUN;

*Analysis Variable : CFDRIGHT
PAD480_N
less than or equal to 1 daily hour of TV, video, or computer use: 44.56
2 to 3 daily hours of TV, video, or computer use: 46.14
4 or more daily hours of TV, video, or computer use: 45.27;

*question 3F;
proc ttest data = QUESTION3;
where PAD480_N in (0,2);
CLASS PAD480_N; 
var CFDRIGHT;
run; 

* mean difference in CFD score: -0.7118
95% around this mean difference: -3.7935	2.3698


Those with 4 or more daily hours of TV, video, or computer use had
an average score of 0.7118 higher. 
We are 95% confident that the true mean difference is between -3.7935 and 2.3698.;

*Question3G;

proc ttest data = QUESTION3;
where PAD480_N in (0,1);
CLASS PAD480_N; 
var CFDRIGHT;
run; 

* mean difference in CFD score: -1.5764
95% around this mean difference: -4.4050	1.2522
Those with 2 to 3 daily hours of TV, video, or computer use had
an average score of 1.5764 higher.
We are 95% confident that the true mean difference is between -4.4050 and 1.2522;


*Question3H;
*Random sampling variability (a.k.a. “chance”) is a reasonable explanation 
for the observed mean difference because in the null, the difference is 0, and 0
is within the confidence interval, so we fail to reject the null. This means
that any difference is not significant and probably due to chance.;

*Question 4;
PROC SGPLOT data = question3;
dot PAD480_N / response=CFDRIGHT stat=mean limitstat=clm;
run;

*Question 5A;
data work.question5;
set HW3.Final4_b;
run;

*Question 5B;
PROC RANK DATA= question5 GROUPS= 4 OUT= QUESTION5;
VAR ridageyr;
ranks Age_Cat;
run;

*Question 5C;

PROC MEANS MIN MAX DATA= question5;
CLASS AGE_CAT; 
VAR ridageyr;
RUN;

*
0: quartile 1: 	(60.0000000-63.0000000)
1: quartile 2:	(64.0000000-68.0000000)
2: quartile 3:	(69.0000000-72.0000000)
3: quartile 4:	(73.0000000-79.0000000);


*Question 5D;

DATA question5;
SET question5;

IF ridageyr =>60 AND ridageyr =<63  THEN AGE_CAT = 0;
else IF ridageyr =>64 AND ridageyr =<68 THEN AGE_CAT = 1;
else IF ridageyr =>69 AND ridageyr =<72 THEN AGE_CAT = 2;
else IF ridageyr =>73 AND ridageyr =<79 THEN AGE_CAT = 3;
RUN;


*Question 5E;
PROC MEANS MEAN DATA= QUESTION5;
CLASS AGE_CAT;
VAR CFDRIGHT;
RUN;

*
0 (49.2307692)
1 (45.7115385)
2 (44.9409283)
3 (42.3553459);

*Question 5F;

PROC ANOVA DATA = QUESTION5;
CLASS AGE_CAT;
MODEL CFDRIGHT= AGE_CAT;
RUN;

* R SQUARED: 0.019206
It explains 1.92% of the variability in CFDRIGHT. 
ALSO, TEST SHOWS THAT IT IS STATISTICALLY SIGNIFICANT PR >F = .0001.
WE USED THE ANOVA TEST, BECAUSE WE WERE COMPARING THE MEAN DIFFERENCE BETWEEN 
MORE THAN 2 GROUPS. THE PVALUE IS LESS THAN .0001, SO AT  ALPHA .05,
YOU CAN REJECT THE NULL AND CONCLUDE THAT ONE SCORE IS SIGNIFICANTLY DIFFERENT.;

*Question 5G;

proc ttest data = QUESTION5;
where AGE_CAT in (0,3);
CLASS AGE_CAT; 
var CFDRIGHT;
run; 


*THE MEAN DIFFERENCE IS: 6.8754
THE 95%CL IS 3.9706	9.7803

THOSE IN QUARTILE 4 HAD A SCORE 6.8754 LOWER.
We are 95% confident that the true mean difference is between 3.9706 AND 9.7803;

*Question 5H
JUST DOING ONE PAIRWISE DOES NOT EXPLAIN THE DIFFERENCES
THAT CAN OCCUR DUE TO THE OTHER COMBINATIONS, THUS YOU
CAN'T JUST DO ONE PAIRING AND CONCLUDE A DIFFERENCE;

*Question 6;

*RANK AND FORMAT ridageyr;

data work.question6;
set HW3.Final4_b;
run;

PROC RANK DATA= question6 GROUPS= 3 OUT= QUESTION6;
VAR ridageyr;
ranks Age_Cat;
run;

PROC MEANS MIN MAX DATA= question6;
CLASS AGE_CAT; 
VAR ridageyr;
RUN;

*
0	(60.0000000-64.0000000)
1	(65.0000000-71.0000000)
2	(72.0000000-79.0000000);

PROC FORMAT;
VALUE AGE_CAT 0 = "60-64Y"
1 = "65-71Y" 
2 = "72-79Y"; 
RUN; 

DATA QUESTION6; SET QUESTION6;
FORMAT AGE_CAT AGE_CAT.;
RUN;

*FORMAT RIAGENDR;

PROC FORMAT;
VALUE RIAGENDR 1 = "MALE"
2 = "FEMALE"; 
RUN; 

DATA QUESTION6; SET QUESTION6;
FORMAT RIAGENDR RIAGENDR.;
RUN;


*FORMAT CFD_DICH;

DATA question6;
SET question6;

IF CFDRIGHT =>0 AND CFDRIGHT =<49  THEN CFD_DICH = 0;
IF CFDRIGHT =>50 AND CFDRIGHT =<100  THEN CFD_DICH = 1;
RUN;

PROC FORMAT;
VALUE CFD_DICH 0 = "CFD SCORE 0-49"
1 = "CFD SCORE 50-100"; 
RUN; 

DATA QUESTION6; SET QUESTION6;
FORMAT CFD_DICH CFD_DICH.;
RUN;

*FORMAT SCREENTIME_CAT;

DATA question6;
SET question6;

IF PAD480 =0 or PAD480 =1 or PAD480 =6 OR PAD480 =2 THEN SCREENTIME_CAT = 0;
else IF PAD480 =3 OR PAD480 =4 OR PAD480 =5 THEN SCREENTIME_CAT =1;
RUN;

PROC FORMAT;
VALUE SCREENTIME_CAT 0 = "0-2 HOURS"
1 = "3+ HOURS"; 
RUN; 

DATA QUESTION6; SET QUESTION6;
FORMAT SCREENTIME_CAT SCREENTIME_CAT.;
RUN;

*COMPLIED IN TABLE;

proc tabulate data = QUESTION6;
class SCREENTIME_CAT RIAGENDR AGE_CAT CFD_DICH;
var ridageyr CFDRIGHT;
table SCREENTIME_CAT All,(all RIAGENDR AGE_CAT CFD_DICH)*(n colpctn)
CFDRIGHT *(mean std) ridageyr*(mean std); 
run;




