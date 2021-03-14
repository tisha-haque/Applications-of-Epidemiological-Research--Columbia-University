**************************************************************************************
**	P8483: Spring 2020														     	**
**	Homework 1																	**
**  Name: Tisha Haque                                                                          **
**  UNI: tnh2115																        **
**************************************************************************************;
*Question 1a;
LIBNAME data1 "/home/u45142172/my_courses/mrl2013/RAW DATA";
run;

*Question 1b;
Data WORK.data1;
set data1.HW1_2020;
run;

*Question 2a;
PROC CONTENTS DATA = data1;
RUN;

Proc contents order = varnum data = data1;
run;

*There are 13 variables in the dataset;

*Question 2b;
*There are 9951 observations in the dataset;

*Question 2c;
*The first listed variable is SEQN and the last listed 
variable is age in this dataset;

*Question 3a;
PROC PRINT DATA = data1;
RUN;

*"OBS" is the observations, which can refer to the individuals in the sample;

*Question 3b;
proc print noobs data= data1 (obs = 25);
var age other_language_at_home BMXBMI;
title 'First 10 observations';
RUN;


*Question 3c;
proc means data = data1;
where age >= 50;
run;

*There were 2819 observations read from the data set WORK.DATA1. 
WHERE age>=50;

*Question 3d;
proc means data = data1;
where age >= 50 and BMXBMI = .;
run;

*There were 167 observations read from the data set WORK.DATA1. 
WHERE (age>=50) and (BMXBMI=.);

*Question 4a;

proc freq data = data1;
table Other_language_at_home/missing;
run;


*There were 2593 observations read from the data set WORK.DATA1. 
26.06% of observations in the data set indicate  that a language 
other than English is spoken at home (Other_language_at_home = 1).;


*There were 6351 observations read from the data set WORK.DATA1.
63.82% of observations in the data set indicate 
that English is the only language spoken at home (Other_language_at_home = 0).;


*There were 1007 observations read from the data set WORK.DATA1.
10.12% of observations have missing data for this 
variable (Other_language_at_home = .).;

*Question 4b;

proc freq data = data1;
table Other_language_at_home/missing;
where age>= 18;
run;

*There were 1951 observations read from the data set WORK.DATA1.
WHERE (Other_language_at_home=1) and (age>=18). 32.52% in the data set 
indicate that a language other than English is spoken at home 
(Other_language_at_home = 1;


*There were 4032 observations read from the data set WORK.DATA1.
WHERE (Other_language_at_home=0) and (age>=18). 67.20% indicate that 
English is the only language spoken at home (Other_Language_at_home = 0),;
         

*There were 17 observations read from the data set WORK.DATA1.
WHERE (Other_language_at_home=.) and (age>=18). 0.28% of observations 
have missing data for this variable;
    
    
*Question 4c;
*The difference can be due to the fact that it is more difficult to acquire date from 
people less than 18 years of age. This would make sense becuase there was only 
17 observations with missing data for those >=18 versus 990 (1007-17) observations for missing 
data for those <18 years of age.;

*Question 4d;

proc freq data = data1;
where HIQ011 =1 or HIQ011 =2;
table HIQ011*Other_language_at_home;
run;   

*There are 1932 observations who are covered by health insurance among 
those responding that they speak a language other than English at home. 
74.77% of observations are covered by health insurance among 
those responding that they speak a language other than English at home.;


*There are 5746 observations who covered by health insurance among those 
responding that they speak only English at home. 90.62% of observations are 
covered by health insurance among those responding that they speak only 
English at home.;

*Question 5a;
proc means n nmiss median q1 q3 mean std data = data1;
var age;
run;

*The N is 9951, NMISS is 0, Median is 27.0, IQR is 44.0, mean is 32.2063109, 
and Std Dev is 25.1495975;

proc means n nmiss median q1 q3 mean std data = data1;
var BMXBMI;
run;
*The N is 8737, NMiss is 1214, Median is 25.2000000, IQR is 10.7, 
mean is 26.0184045, and the Std Dev is 7.9634574;

*Question 5b;

proc means n nmiss median q1 q3 mean std data = data1;
where Other_language_at_home = 0 or Other_language_at_home = 1 and BMXBMI>=0;
class Other_language_at_home;  
var BMXBMI;
run;

*In Other_language_at_home = 0, The N is 6031, NMiss is 320, Median is 25.3, IQR is 11.1, 
mean is 26.2200630, and the Std Dev is 8.2220709;

*In Other_language_at_home = 1, The N is 2435, NMiss is 0 , Median is 26.0000000, IQR is 9.1, 
mean is 26.4761807, and the Std Dev is 7.0936267. 

The highest mean value, 26.4761807, is for the category of 
those that speak another language at home (Other_language_at_home = 1).;

*Question 5c;

proc means n nmiss median q1 q3 mean std data = data1;
where age >= 18;
class Other_language_at_home;
var BMXBMI;
run;

*In Other_language_at_home = 0, the N is 3832, NMiss is 200, Median is 28.6000000, IQR is 9.2, 
mean is 29.7393267, and the Std Dev is 7.4104458.;

*In Other_language_at_home = 1, the N is 1834, NMiss is 0, Median is 27.8000000, IQR is 7.7, 
mean is 28.5735551, and the Std Dev is 6.2957102.

The highest mean value, 29.7393267, is for the category of those that don't 
speak another language (Other_language_at_home = 0), when restricting the 
population of individuals aged 18 years or older.;


/*Question 6a

libname Hammer "/courses/d16994e5ba27fe300/RAW DATA/";
proc contents data = Hammer.Hw1_2020; run;

You should not include the file name at the end 
of the libname statement but needs to be after 
the proc content data function*/


/*Question 6b

libname _6b "/courses/d16994e5ba27fe300/RAW DATA/";
 proc contents data = _6b.hw1_2020;
 run;

The first line need to end in double quotes not single quote.*/

/*Question 6c

libname _6c “/courses/d16994e5ba27fe300/RAW DATA/”;
proc freq data = _6c.hw1_2020;
table age;
run;

The libname needs to match _6c when using it in the 
proc freq data= _6c.hw1_2020. Additionally you have to use table
if you are using the proc freq function*/

/*Question 6d

libname Hw1 “/courses/d16994e5ba27fe300/RAW DATA/”;
PROC PRINT DATA=HW1.HW1_2020 (OBS = 100);
RUN;

*OBS = 100 is not in parenthesis.*/

/*Question 6e

libname Hw1 “/courses/d16994e5ba27fe300/RAW DATA/”;
PROC FREQ DATA=HW1.HW1_2020;
TABLE BMXBMI;
RUN;

Proc means function doesn't use table, you need to use proc freq, 
or use var for proc means data function*/ 

/*Question 6f

libname Hw1 “/courses/d16994e5ba27fe300/RAW DATA/”;
PROC MEANS DATA=HW1.HW1_2020;
var BMXBMI;
RUN;

It is missing a backlash in the beginning of the file location.*/












