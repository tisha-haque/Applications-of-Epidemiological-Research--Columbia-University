**************************************************************************************
**	P8483: Spring 2020														    
**	Homework 4																	
**  Name: Tisha Haque                                                                          **
**  UNI: tnh2115																 
**************************************************************************************;

*/Question 1A*/;

libname HW4_a xport "/home/u45142172/my_courses/mrl2013/RAW DATA/NHANES/DEMO_I.XPT";
data HW4_a; set Hw4_a.demo_I;
run;

libname HW4_b xport "/home/u45142172/my_courses/mrl2013/RAW DATA/NHANES/IMQ_I.XPT";
data HW4_b; set HW4_b.imq_I;
run;

libname HW4_c xport "/home/u45142172/my_courses/mrl2013/RAW DATA/NHANES/INQ_I.XPT";
data HW4_c; set HW4_c.inq_I;


data Homework4;
merge HW4_a HW4_b HW4_c;
by SEQN;
run;

data Homework4; 
set Homework4;
where 22<=RIDAGEYR<60;
run;

data Homework4;
set Homework4;
where (riagendr=1 AND IMQ070 in (1,2))
or (riagendr=2 AND IMQ060 in (1,2));
run;

data Homework4;
set Homework4;
where IND235 not in (77,99,.);
run;
 
*/NOTE: There were 2933 observations read from the data set 
WORK.HOMEWORK4. WHERE IND235 not in (., 77, 99);
 
*/Question 1B*/;
data Homework4; set Homework4;
if IMQ060=1 OR IMQ070=1 THEN HPV_Receipt=1;
else if IMQ060=2 or IMQ070=2 then HPV_Receipt=0;
run;

*/Question 1C*/;
data Homework4; set Homework4;
if IND235 in (1,2,3) then monthly_inccat=1;
else if IND235 in (4,5,6) then monthly_inccat=2;
else if IND235 in (7,8,9) then monthly_inccat=3;
else if IND235 in (10,11,12) then monthly_inccat=4;
run;

*Question 1D*/;
proc format;
value HPV_Receiptf 1="HPV" 0="no HPV";
value riagendrf 1= "Male" 2= "Female";
value monthly_inccatf 1= "$0-$1249" 2= "$1250-2899"
3= "$2500-$5399" 4= ">=$5400";
run;

data Homework4; set Homework4;
format HPV_Receipt HPV_Receiptf. riagendr riagendrf. monthly_inccat monthly_inccatf.;
run;

/*Question 1E*/
proc freq data=Homework4;
table HPV_Receipt;
run;

proc freq data=Homework4;
table riagendr;
run;

proc freq data=Homework4;
table monthly_inccat;
run;

/*HPV_Receipt       Number per group      % in univariate analysis
no HPV_Receipt      2670                    91.03%
HPV_Receipt         263                     8.97%

RIAGENDR           Number per group       % in univariate analysis
Male                1352                    46.10%
Female              1581                    53.90%

Monthly_inccat     Number per group       % in univariate analysis
$0-$1249            479                     16.33%
$1250-$2899         711                     24.24%
$2900-$5399         868                     29.59%
>=$5400             875                     29.83%  */

/*Question 2*/
libname Demo xport "/home/u45142172/my_courses/mrl2013/RAW DATA/NHANES/DEMO_I.XPT";
data Demo; set Demo.Demo_I;
where RIAGENDR=1 AND RIAGENDR=2;
where 22<=RIDAGEYR<60;
run;

/*Question 2A*/
proc rank data = work.demo out = Zebra groups = 4;
ranks AgeCat;
var ridageyr;
run;
proc means min max data = Zebra;
class AgeCat;
var ridageyr;
run;
proc format;
value Age 0 = '22-30y' 1 = '31-39y' 2 = '40-49y' 3 = '50-59y';
run;
data Zebra; set Zebra;
format Age_Cat Age.;
run;	
proc freq data = Zebra;
table AgeCat*riagendr;
run;

/*The code is incorrect because the formats didn't get applied properly to 
the table*/

proc rank data = work.demo out = Zebra groups = 4;
ranks AgeCat;
var ridageyr;
run;

proc means min max data = Zebra;
class AgeCat;
var ridageyr;
run;

proc format;
value AgeCatf 0 = "22-30y" 1 = "31-39y" 2 = "40-49y" 3 = "50-59y";
run;

data Zebra; set Zebra;
format AgeCat AgeCatf.;
run;
	
proc freq data = Zebra;
table AgeCat*riagendr;
run;


/*Question 2B*/
proc format;
value ageyr_group 1 = '22-29y' 2 = '30-39y' 3 = '40-49y' 4 = '50+y';
data demo2; set demo;
if 22 le ridageyr < 30 then Ageyr_Group = 0;
else if 30 le ridageyr < 40 then Ageyr_Group = 1;
else if 40 le ridageyr < 50 then AgeYr_Group = 2; 	
else if ridageyr ge 50 then AgeYr_Group = 3;
format Ageyr_Group ageyr_group.;
run;
proc freq data = demo2; 
table ageyr_group*riagendr; 
run;

/*This code is incorrect because the original format had values of
0, 1, 2 and 3, while this data has formats of 1, 2, 3, 4 for the Ageyr_Group*/

proc format;
value ageyr_group 0 = '22-29y' 1 = '30-39y' 2 = '40-49y' 3 = '50+y';

data demo2; set demo;
if 22 le ridageyr < 30 then Ageyr_Group = 0;
else if 30 le ridageyr < 40 then Ageyr_Group = 1;
else if 40 le ridageyr < 50 then AgeYr_Group = 2; 	
else if ridageyr ge 50 then AgeYr_Group = 3;
format Ageyr_Group ageyr_group.;
run;

proc freq data = demo2; 
table ageyr_group*riagendr; 
run;

/*Question 2C*/
proc format;
value agegp 1 = '22-29y' 2 = '30-39y' 3 = '40-49y' 4 = '50+y';
run;
data SpringBreak;
set demo;
if 22 le ridageyr < 30 then Ageyr_Group = 1;
if ridageyr < 40 then Ageyr_Group = 2;
else if 40 le ridageyr < 50 then AgeYr_Group = 3; 	
else if ridageyr ge 50 then AgeYr_Group = 4;
format ageyr_group agegp.;
run;
proc freq data = SpringBreak; 
table ageyr_group*riagendr; run;

/*This code is incorrect because "if ridageyr<40 then Ageyr_Group=2"
includes the data from the first set of values coded as 1= 22-29y,
therefore it overwrites the data"*/

proc format;
value agegp 1 = '22-29y' 2 = '30-39y' 3 = '40-49y' 4 = '50+y';
run;

data SpringBreak;
set demo;
if 22 le ridageyr < 30 then Ageyr_Group = 1;
if 30 le ridageyr < 40 then Ageyr_Group = 2;
else if 40 le ridageyr < 50 then AgeYr_Group = 3; 	
else if ridageyr ge 50 then AgeYr_Group = 4;
format ageyr_group agegp.;
run;

proc freq data = SpringBreak; 
table ageyr_group*riagendr; run;

 
/*Question 3a*/
proc format;
value riagendr 1="female" 2="male";
run;

proc format;
value HPV_Receipt 1="HPV" 2="no HPV";
run;

proc freq data=Homework4 order=formatted;
table riagendr*HPV_Receipt/riskdiff relrisk;
run;


/*table row*column*/
/*The odds ratio is approximately 3.25 with a 95%CI of (2.41, 4.38).
The odds of being vaccinated with HPV is 3.25 times higher in females than 
males, and we are 95% confident that the true value of the odds ratio
lies between 2.41 and 4.38. 

The risk ratio is 2.96, with a 95% CI of (2.23, 3.91). There is a 196% 
higher risk of receiving the HPV vaccine in females than in males, and 
we are 95% confident that the true value of the risk ratio lies between 
2.23 and 3.91*/

/*Question 3B*/
/*If the null hypothesis is true, the 95% CI of odds ratio and the risk 
ratio would contain the value of zero. Since our confidence intervals of 
odds ratio and risk ratio doesn't contain zero, it is unlikely that
the data was randomly sampled from a population with no difference in 
coverage by biological sex. 

/*Question 3C
It is ok to refer to the ratio as a risk ratio because there is 
no element of temporality regarding exposure and outcome*/   

                  
/*Question 4A*/
proc power;
twosamplefreq test= pchi
groupproportions= (0.08 0.04)
groupns= (1581 1352)
alpha=0.05
power= .;
run;
/*prevalence among men=0.04, prevalence among women=0.08, power=0.995*/

proc power;
twosamplefreq test= pchi
groupproportions= (0.12 0.06)
groupns= (1581 1352)
alpha=0.05
power= .;
run;
/*prevalence among men=0.06, prevalence among women=0.12, power>0.999*/

proc power;
twosamplefreq test= pchi
groupproportions= (0.16 0.08)
groupns= (1581 1352)
alpha=0.05
power= .;
run;
/*prevalence among men=0.08, prevalence among women=0.16, power>0.999*/

proc power;
twosamplefreq test= pchi
groupproportions= (0.20 0.10)
groupns= (1581 1352)
alpha=0.05
power= .;
run;
/*prevalence among men=0.10, prevalence among women=0.20, power>0.999*/

proc power;
twosamplefreq test= pchi
groupproportions= (0.24 0.12)
groupns= (1581 1352)
alpha=0.05
power= .;
run;
/*prevalence among men=0.12, prevalence among women=0.24, power>0.999*/

/*Question 4B*/
proc power;
twosamplefreq test= pchi
groupproportions= (0.08 0.04)
groupns= (1581 1352)
alpha=0.01
power= .;
run; 
/*prevalence among men=0.04, prevalence among women=0.08, power=0.976*/

proc power;
twosamplefreq test= pchi
groupproportions= (0.12 0.06)
groupns= (1581 1352)
alpha=0.01
power= .;
run;
/*prevalence among men=0.06, prevalence among women=0.12, power>0.999*/

proc power;
twosamplefreq test= pchi
groupproportions= (0.16 0.08)
groupns= (1581 1352)
alpha=0.01
power= .;
run;
/*prevalence among men=0.08, prevalence among women=0.16, power>0.999*/

proc power;
twosamplefreq test= pchi
groupproportions= (0.20 0.10)
groupns= (1581 1352)
alpha=0.01
power= .;
run;
/*prevalence among men=0.10, prevalence among women=0.20, power>0.999*/

proc power;
twosamplefreq test= pchi
groupproportions= (0.24 0.12)
groupns= (1581 1352)
alpha=0.01
power= .;
run;
/*prevalence among men=0.12, prevalence among women=0.24, power>0.999*/

/*Question 4C*/
proc power;
twosamplefreq test=pchi
refproportion=0.06
relativerisk= 1.1 to 2 by 0.025
groupns= (1352 1581)
alpha=0.05
power=.;
run;
/*minimum relative risk is 1.45-1.47 for 80% power*/


/*Question 4D*/
proc power;
twosamplefreq test=pchi
refproportion=0.06
relativerisk=1.1 to 2 by 0.025
groupns= (293 2640)
alpha=0.05
power= .;
run;
/*minimum relative risk is between 1.82-1.85 for 80% power*/

/*Question 5*/
proc anova data=Homework4;
class monthly_inccat;
model HPV_Receipt= monthly_inccat;
run;

/*The p-value reported from the anova test was 0.02. 
0.02 is less than alpha value of 0.05, thus we can conclude that 
there is a statistically significant difference between individuals 
receiving HPV vaccinations based on monthly family income.*/

/*Question 6*/
data Question6;
set Homework4;
where (riagendr=1 AND IMQ070 in (1))
or (riagendr=2 AND IMQ060 in (1));
where IMQ090 in (1:51);
run;

proc ttest data=Question6;
where IMQ090 in (1:51);
class RIAGENDR;
var IMQ090;
run;

/*The mean difference between ages of male and female at HPV 
vaccination is 1.2719 with a 95%CI of (-1.2114, 3.7551). This means that
the point estimate shows that on average, men are 1.2719 years older than
women at HPV Vaccination, and we are 95% confident that the true mean difference
between male and female age at HPV vaccination lies between -1.2114 and
3.7551. Since the null value of 0 is contained within our 95% confidence
interval, we fail to reject the null hypothesis. Random sampling variability 
(a.k.a. “chance”) is a reasonable explanation for the observed mean difference 
because in the null, 0, is within the confidence interval, so we fail to reject 
the null. This means that any difference is not significant and probably 
due to chance. */ 

/*Question 7a*/
proc power;
twosamplemeans test=diff
power=0.9
alpha=0.05
meandiff=.
stddev=7.25
groupns= (27 176);
run;
/*Mean difference recorded is 4.88, so the mean age that men
will get HPV vaccination is 21.4+4.88= 26.28. The power reported
is 0.90, which means that there is a 90% chance we will reject the null
hypothesis when the alternative hypothesis is true.*/

/*Question 7b*/
proc power;
twosamplemeans test=diff
power=0.8
alpha=0.05
meandiff=.
stddev=7.25
groupns= (27 176);
run;
/*Mean difference recorded is 4.22, so the mean age that men
will get HPV vaccination is 21.4+4.22=25.62. The power reported is 
0.80, which means that there is an 80% chance we will reject the null 
hypothesis when the alternative hypothesis is true.*/

/*Question 8a*/
proc univariate data=Question6;
class riagendr;
var IMQ090;
histogram IMQ090/normal midpoints=0 to 60 by 2;
run;
/*Neither data is normally distributed. The data for females is 
right-skewed since most of the data is concentrated
on the left, and the data for males is normally distributed because
the mean (22.70370) and median (22.00000) for males are close. */

/*Question 8b*/
ods graphics on;
proc npar1way wilcoxon correct=no data=Question6;
class riagendr;
var IMQ090;
run;
/*The p-value calculated is 0.0614. At an alpha level of 0.05, we would
fail to reject the null hypothesis and conclude that the difference in age 
between males and females for HPV Vaccination is not statistically significant 
and and any difference is probably due to chance. Thus, we would come to the 
same conclusion at question 6.*/










