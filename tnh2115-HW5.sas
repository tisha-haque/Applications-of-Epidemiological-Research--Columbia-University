**************************************************************************************
**	P8483: Spring 2020														     	
**	Homework 5																
**  Name: Tisha Haque                                                                        
**  UNI: tnh2115																      
**************************************************************************************;
/*Question 1*/
libname HW_5 "/home/u45142172/my_courses/mrl2013/RAW DATA";
data work.Homework_5; 
set Hw_5.Homework_5;
run;

data HW5; 
set work.Homework_5;
where DMDEDUC= 1 OR DMDEDUC=2 OR DMDEDUC= 3;
run;

/*The data set WORK.QUESTION1 has 1551 observations and 25 variables.*/

/*Question 2*/
data HW5; 
set HW5;
if PAD480= 0 or PAD480= 1 or PAD480= 6  then SEDB=0;
else if PAD480=2 or PAD480=3 or PAD480=4 or PAD480=5 then SEDB=1;
run;

proc format;
value SEDB 0= "No Sedentary"
		   1= "Sedentary";
run;

data HW5; 
set HW5;
format SEDB SEDB.;
run;


/*Question 3*/
Proc ttest data= HW5;
CLASS SEDB; 
var CFDRIGHT;
run; 
/*
SEDB			 Mean	 			
No sedentary	40.3485	 							
Sedentary	 	42.6785	
 	
mean difference: -2.3299
95% CI of mean diff: (-4.7816, 0.1217)

95% CI SEDB 0: (38.1014, 42.5957)
95% CI SEDB 1: (41.6940, 43.6629)

The p-value is 0.0625. Since the p-value is greater than 0.05 (the 
standard alpha value), we fail to reject the null hypothesis. This means
that mean DSST scores (CFDRIGHT) does not differ between levels of the
binary variable SEDB. We can be 95% confident that the true value of 
the mean difference lies between -4.7816 and 0.1217. 			
*/

/*Question 4*/
PROC REG data= HW5;
model CFDRIGHT= SEDB/clb;
run;
/* total variability: 0.0026= 0.26%, total variability in CFDRIGHT 
explained by binary variable sedentary behavior (SEDB)is 0.26%

SEDB			 Mean	 			
No sedentary	40.34853	 							
Sedentary	 	40.34853 + 2.32992= 42.67845

mean difference: 2.32992
95% CI of mean diff: (0.05770,4.60214)

95% CI SEDB 0: (38.31358, 42.38349)  
95% CI SEDB 1:  (0.05770+ 38.31358,4.60214+ 42.38349)
				(38.37128, 46.98563)

The results in questions 3 and 4 differ in that question 3, we don't reject 
the null, however in question 4, the p-value is 0.0445<0.05, therefore
we reject the null and conclude that the mean DSST score of cognitive 
performance does differ between levels of binary variable SEDB. The 
difference is attributed to using the Satterthwaite method with T-test
and pooled method for proc reg.*/

/*Question 5*/
proc glm data= HW5;
class SEDB (reference= "No Sedentary");
model CFDRIGHT= SEDB/clparm solution;
run;

/* The output is the same*/

/*Question 6*/
proc freq data= HW5;
table ridageyr;
run;

/* shows that ridageyr is continuous*/

proc glm data= HW5;
class SEDB (reference= "No Sedentary");
model CFDRIGHT= SEDB ridageyr/clparm solution;
run;

/* Age would act as a confounder if the two slopes for Sedentary and 
No Sedentary varied, however, when comparing the slopes of 2.84 and 2.32 
and looking at the graph, it appears that there is not a major 
difference. Thus, there is not enough evidence concerning age 
acting as a confounder in the data set. */

/*Question 7*/
PROC REG data= HW5;
model CFDRIGHT= SEDB ridageyr/clb;
run;

/* R-Square value: 0.1170. This means that total variability in CFDRIGHT 
explained by a model with ridageyr and SEDB is 11.70%. We looked at 
the R-squared column to determine the value.*/

/*Question 8*/
proc freq data= HW5;
table DMDEDUC;
run;

/* confirm that it is categorical*/

proc glm data= HW5;
class SEDB (reference= "No Sedentary") DMDEDUC (reference= "1");
model CFDRIGHT= SEDB DMDEDUC ridageyr/clparm solution;
run;

/* R-squared value: 0.343919. This means that total variability in 
CFDRIGHT explained by a model with ridageyr, SEDB, and DMDEDUC is
34.39%. We got this value from the R-squared column. 


/*Question 9*/
proc glm data= HW5;
class SEDB (reference= "No Sedentary") DMDEDUC (reference= "1");
model CFDRIGHT= SEDB DMDEDUC ridageyr/clparm solution;
run;

/* Age and DMDEDUC together don't confound the relationship between 
SEDB and CFDRIGHT because there is not a major difference between 
the sedentary and no sedentary slope, 2.19 and 2.32. The slope value is found
under the parameter estimate for SEDB Sedentary.




