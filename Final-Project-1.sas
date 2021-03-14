*****************************************************************************
Adeel Azim aa4480 
Fuad Faruque fbf2112
Tisha Haque tnh2115
Cameron Tait-Ozer ct2959
*****************************************************************************;
libname DEMO xport "/home/u45113362/sasuser.v94/DEMO_I.XPT";
data WORK.DEMO_I; set DEMO.DEMO_I;
libname BPQ xport "/home/u45113362/sasuser.v94/BPQ_I.XPT";
data WORK.BPQ_I; set BPQ.BPQ_I;
libname PAQ xport "/home/u45113362/sasuser.v94/PAQ_I.XPT";
data WORK.PAQ_I; set PAQ.PAQ_I;
libname BPX xport "/home/u45113362/sasuser.v94/BPX_I.XPT";
data WORK.BPX_I; set BPX.BPX_I;
run;

data DEMO; set DEMO_I;
where RIDAGEYR ge 18;
/*Children (those younger than 18 years) were removed from the dataset due to the 
rarity of systolic blood pressure problems in children.  Missing observations were deleted.*/
if RIAGENDR = . then delete;
if RIDAGEYR = . then delete;
if RIDRETH3 = . then delete;
run;
proc format;
value RIDRETH3f
1, 2 = "Hispanic"
3 = "White"
4 = "Black"
6 = "Asian"
7 = "Other";
run;
data DEMO; set DEMO;
format RIDRETH3 RIDRETH3f.;
run;
/*Since we are using race as a predictor variable, we applied formats to make 
our output easier to read.  1 and 2 were coded as Mexican Hispanic and non-Mexican 
Hispanic respectively.  We did not feel this distinction was necessary and combined 
them into "Hispanic."*/
proc format;
value RIAGENDR
1 = "Male"
2 = "Female";
run;
data DEMO; set DEMO;
format RIAGENDR RIAGENDR.;
run;
/*Sex is another one of our predictor variables, so we applied formats for 
easier comprehension.*/

data BPQ; set BPQ_I;
where BPD035 ge 18;
/*Since we were only concerned with adults, we removed those younger than 18 from the variable 
"Age when you were first told you had high blood pressure."*/
if BPQ030 = 7 or BPQ030 = 9 or BPQ030 = . then delete;
if BPD035 = 777 or BPD035 = 999 or BPD035 = . then delete;
run;
proc format;
value BPQ030f
1 = "Yes"
2 = "No";
run;
data BPQ; set BPQ;
format BPQ030 BPQ030f.;
run;
/*To make our output easier to understand for others we applied formats to the 
output for "have you been told you have high blood pressure 2+ times."*/
data BPQ; set BPQ;
keep BPQ030 BPD035 SEQN;
run;

data PAQ; set PAQ_I;
if PAQ670 = 77 or PAQ670 = 99 or PAQ670 = . then delete;
run;
data PAQ; set PAQ;
if PAQ670 in (1, 2) then Weekly_Exercise = 1;
if PAQ670 in (3, 4) then Weekly_Exercise = 2;
if PAQ670 in (5, 6, 7) then Weekly_Exercise = 3;
run;
proc format;
value Weekly_Exercise
1 = "Low"
2 = "Medium"
3 = "High";
run;
/*To make testing easier, the variable "how many days of the week do you engage in moderate physical activity" 
was categorized into three levels.  1 to 2 days were considered low, 3 to 4 days 
were considered medium, and 5 to 7 days were considered high.*/
data PAQ; set PAQ;
format Weekly_Exercise Weekly_Exercise.;
run;
data PAQ; set PAQ;
keep Weekly_Exercise SEQN;
run;

data BPX; set BPX_I;
if BPXSY1 = . then delete;
run;
data BPX; set BPX;
if BPXSY1 ge 130 then Systolic_BP = 1;
if BPXSY1 < 130 then Systolic_BP = 0;
run;
proc format;
value Systolic_BP
1 = "High"
0 = "Normal/low";
run;
/*In order to perform tests of association between blood pressure and race/sex, 
we created an additional dichotomous variable from NHANES' systolic blood pressure 
readings.  130 and above was considered high (as existing literature purports) 
and anything less than that was classified as normal/low.*/
data BPX; set BPX;
format Systolic_BP Systolic_BP.;
run;
data BPX; set BPX;
keep BPXSY1 Systolic_BP SEQN;
run;

proc sort data = DEMO; by SEQN;
proc sort data = BPQ; by SEQN;
proc sort data = PAQ; by SEQN;
proc sort data = BPX; by SEQN;
run;
data Final_Set;
merge DEMO (in = a) BPQ (in = b) PAQ (in = c) BPX (in = d);
by SEQN;
if a and b and c and d;
run;

proc means n mean data = Final_Set;
var RIDAGEYR;
var BPXSY1;
run;
proc means n mean data = Final_Set;
var RIDAGEYR;
var BPXSY1;
class RIAGENDR;
run;
proc means n mean data = Final_Set;
var RIDAGEYR;
var BPXSY1;
class RIDRETH3;
run;

proc sort data = Final_Set; by descending Systolic_BP;
proc freq data = Final_Set order = data;
table RIAGENDR*Systolic_BP / chisq;
run;

proc sort data = Final_Set; by descending Systolic_BP;
proc freq data = Final_Set order = data;
table RIDRETH3*Systolic_BP / chisq;
run;

proc glm data = Final_Set;
class Weekly_Exercise (ref = "Low");
model BPXSY1 = Weekly_Exercise / clparm solution;
run;
/*The crude slopes for the different exercise levels were found under the table 
marked "parameter."  The slope, 4.58, for the high exercise group was taken from the 
"Weekly_Exercise High" row and "Estimate" column.
The slope, 1.22, for the medium exercise group was taken from the "Weekly_Exercise Medium" 
row and "Estimate" column.*/

proc glm data = Final_Set;
class Weekly_Exercise (ref = "Low");
model BPXSY1 = RIDAGEYR Weekly_Exercise / clparm solution;
run;
/*Age(weekly high) % change=35.6566%
Age (weekly medium) % change=206.324%
The age adjusted slopes for the different exercise levels were found under the table 
marked "parameter."  The slope, 3.38, for the high exercise group was taken from the 
"Weekly_Exercise High" row and "Estimate column.
The slope, 0.399, for the medium exercise group was taken from the "Weekly_Exercise Medium" 
row and "Estimate column.
The percent changes to assess confounding were calcualted as follows:
We subtracted the age adjusted slope from the crude slope and divided this 
number by the age adjusted slope.  This process was repeated twice: once for 
the high exercise group and once for the medium exercise group.*/

proc glm data = Final_Set;
class RIAGENDR (ref = "Male");
class RIDRETH3 (ref = "Hispanic");
class Weekly_Exercise (ref = "Low");
model BPXSY1 = RIDAGEYR RIAGENDR RIDRETH3 Weekly_Exercise / clparm solution;
run;
/*Everything (weekly high) % change=38.8101% 
 Everything (weekly medium) % change= 267.364%
The sex adjusted slopes for the different exercise levels were found under the table 
marked "parameter."  The slope, 3.30, for the high exercise group was taken from the 
"Weekly_Exercise High" row and "Estimate" column.
The slope, 0.33, for the medium exercise group was taken from the "Weekly_Exercise Medium" 
row and "Estimate" column.
The percent changes to assess confounding were calcualted as follows:
We subtracted the fully adjusted slope from the crude slope and divided this 
number by the fully adjusted slope.  This process was repeated twice: once for 
the high exercise group and once for the medium exercise group.*/

proc glm data = Final_Set;
class RIAGENDR (ref = "Male");
class Weekly_Exercise (ref = "Low");
model BPXSY1 = RIAGENDR Weekly_Exercise / clparm solution;
run;
/*Sex (weekly high) % change=36.0188% 
Sex (weekly medium) % change= 13.414%
The sex adjusted slopes for the different exercise levels were found under the table 
marked "parameter."  The slope, 4.62, for the high exercise group was taken from the 
"Weekly_Exercise High" row and "Estimate" column.
The slope, 1.41, for the medium exercise group was taken from the "Weekly_Exercise Medium" 
row and "Estimate" column.
The percent changes to assess confounding were calcualted as follows:
We subtracted the sex adjusted slope from the crude slope and divided this 
number by the sex adjusted slope.  This process was repeated twice: once for 
the high exercise group and once for the medium exercise group. */

proc glm data = Final_Set;
class RIDRETH3 (ref = "Hispanic");
class Weekly_Exercise (ref = "Low");
model BPXSY1 = RIDRETH3 Weekly_Exercise / clparm solution;
run;
/*Race (weekly high) % change= 0.9987%
 Race (weekly medium) % change= 18.7809%
The race adjusted slopes for the different exercise levels were found under the table 
marked "parameter."  The slope, 4.54, for the high exercise group was taken from the 
"Weekly_Exercise High" row and "Estimate" column.
The slope, 1.03, for the medium exercise group was taken from the "Weekly_Exercise Medium" 
row and "Estimate" column.
The percent changes to assess confounding were calcualted as follows:
We subtracted the race adjusted slope from the crude slope and divided this 
number by the race adjusted slope.  This process was repeated twice: once for 
the high exercise group and once for the medium exercise group.*/