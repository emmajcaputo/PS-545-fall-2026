/* Replication do file 2 for "Hostile sexism and overconfidence shape the public's views of climate change"
Analysis and output for 2020 ANES data 

*/

use "anes_timeseries_2020_stata_20220210.dta", clear
set more off

// Party ID
gen partyid3=.
replace partyid3=1 if V201228==1
replace partyid3=2 if V201228==2
replace partyid3=1 if V201230==3
replace partyid3=2 if V201230==1
replace partyid3=3 if V201230==2
label define partyid3 1 "Democratic" 2 "Republican" 3 "Independent/No pref"
label values partyid3 partyid3

// Race
tab V201549x
gen race=V201549x
recode race(-9=.r) (-8=.d)
label define race 1 "White" 2 "Black" 3 "Hispanic" 4 "Asian/AAPI" 5 "Native American" 6 "Multiple/non-Hispanic"
label values race race

// Gender
gen male=.
replace male=1 if V201600==1
replace male=0 if V201600==2
label define male 0 "Female" 1 "Male" 
label values male male

// Education
gen educlevel=.
label define educ 1 "HS or less" 2 "Some college" 3 "Assoc. degree" 4 "Bachelors degree" 5 "Grad or higher"
replace educ=1 if V201510==1
replace educ=1 if V201510==2
replace educ=2 if V201510==3
replace educ=3 if V201510==4
replace educ=3 if V201510==5
replace educ=4 if V201510==6
replace educ=5 if V201510==7
replace educ=5 if V201510==8
label values educ educ
tab educlevel V201510, m
tab educlevel, gen(educ)

tab V201510, m 
gen educscale=V201510 if !missing(V201510) & V201510>0 & V201510<9
tab educscale V201510 , m

label define educscale 1 "Less than HS" 2 "High school graduate" 3 "Some college" 4 "Occupational degree" 5 "Associate's degree" 6 "Bachelor's degree" 7 "Masters degree" 8 "Doctoral degree"
label values educscale educscale

gen collegedeg=.
replace collegedeg=0 if educlevel<=3 & !missing(educlevel)
replace collegedeg=1 if educlevel>=4 & !missing(educlevel)

gen age=V201507x 
destring age, replace
recode age(-9=.)

label define agecat 1 "18-24" 2 "25 to 44" 3 "45 to 64" 4 "65 and older"

gen agecat=.
replace agecat=1 if age>17 & age<25 & !missing(age)
replace agecat=2 if age>24 & age<45 & !missing(age)
replace agecat=3 if age>44 & age<65 & !missing(age)
replace agecat=4 if age>64 & age<100 & !missing(age)
label values agecat agecat

tab V201200, m
gen ideology=.
label define ideology 1 "Extremely liberal" 2 "Liberal" 3 "Slightly liberal" 4 "Moderate" 5 "Slightly conservative" /// 
6 "Conservative" 7 "Extremely conservative"
replace ideology=1 if V201200==1
replace ideology=2 if V201200==2
replace ideology=3 if V201200==3
replace ideology=4 if V201200==4
replace ideology=5 if V201200==5
replace ideology=6 if V201200==6
replace ideology=7 if V201200==7
label values ideology ideology

gen ideo3=.
label define ideo3 1 "Liberal" 2 "Moderate" 3 "Conserative"
replace ideo3=1 if V201200==1
replace ideo3=1 if V201200==2
replace ideo3=1 if V201200==3
replace ideo3=2 if V201200==4
replace ideo3=3 if V201200==5
replace ideo3=3 if V201200==6
replace ideo3=3 if V201200==7
label values ideo3 ideo3

// 2 item hostile sexism
gen innocent=.
replace innocent=1 if V201639==5
replace innocent=2 if V201639==4
replace innocent=3 if V201639==3
replace innocent=4 if V201639==2
replace innocent=5 if V201639==1

gen control=.
replace control=1 if V201640==5
replace control=2 if V201640==4
replace control=3 if V201640==3
replace control=4 if V201640==2
replace control=5 if V201640==1

factor innocent control

gen hostilesexism=(innocent+control)/2
gen hostilefactor=(hostilesexism-1)/4

// DVs
gen dkclimate=.
replace dkclimate=0 if V202555==1
replace dkclimate=0 if V202555==2 & V202556==1
replace dkclimate=0 if V202555==2 & V202556==2

replace dkclimate=1 if V202555==2 & V202556==3
replace dkclimate=1 if V202555==2 & V202556==4
replace dkclimate=1 if V202555==2 & V202556==5

tab dkclimate
label define dkclimate 0 "Knowledge or misinfo w/ low confidence" 1 "Meta-ignorance", replace
label values dkclimate dkclimate

// Ordinal measure for robustness check in appendix
gen dkordinal=.
replace dkordinal=0 if V202555==1 
replace dkordinal=1 if V202555==2 & V202556==1
replace dkordinal=1 if V202555==2 & V202556==2
replace dkordinal=2 if V202555==2 & V202556==3
replace dkordinal=2 if V202555==2 & V202556==4
replace dkordinal=2 if V202555==2 & V202556==5

label define dkordinal 0 "Agreement w/ climate science" 1 "Misinfo with low confidence" 2 "DK: Misinfo w/ high confidence"
label values dkordinal dkordinal

** Climate impact on weather
gen climweather=.
replace climweather=V202332 if V202332>0
label define climweather 1 "Not at all" 2 "A little" 3 "A moderate amount" 4 "A lot" 5 "A great deal"
label values climweather climweather

** Personal importance of climate change
gen climimportance=.
replace climimportance=V202333 if V202333>0
label define climimportance 1 "Not important" 2 "A little" 3 "Moderately important" 4 "Very important" 5 "Extremely important"
label values climimportance climimportance

** Govt regulation on businesses for GHGs
gen regulateghgs=.
tab V202334
label define regulateghgs 1 "Oppose" 2 "Neither favor nor oppose" 3 "Favor"
replace regulateghgs=1 if V202334==2
replace regulateghgs=2 if V202334==3
replace regulateghgs=3 if V202334==1
label values regulateghgs regulateghgs

** Have temps risen
gen tempsrisen=.
replace tempsrisen=0 if V202555==2
replace tempsrisen=1 if V202555==1

label define tempsrisen 0 "Temps have not risen" 1 "Temps have risen"
label values temps temps

** trust in experts
gen trustexperts=.
replace trustexperts=V202308x if V202308x>0
label define trustexperts 1 "Trust ordinary people much more" 2 "Trust ordinary somewhat more" 3 "Trust both the same" 4 "Trust experts somewhat more" 5 "Trust experts much more"
label values trustexperts trustexperts

tab trustexperts V202308x, m

gen trustgovt=.
label define trustgovt 1 "Never" 2 "Some of the time" 3 "About half the time" 4 "Most of the time" 5 "Always"
replace trustgovt=1 if V201233==5
replace trustgovt=2 if V201233==4
replace trustgovt=3 if V201233==3
replace trustgovt=4 if V201233==2
replace trustgovt=5 if V201233==1
label values trustgovt trustgovt

label variable climweather "Climate change impact on severe weather"
label variable climimportance "Climate change personal importance"
label variable regulateghgs "GHG regulations on polluters"
label variable tempsrisen "Evidence that global temps have increased"

label var hostilefactor "Hostile sexism"
label var hostilesexism "Hostile sexism"

label var male "Male"
label var educscale "Education"
label var ideo3 "Ideology"


************* TABLE 1
eststo clear
logit dkclimate hostilesexism [pweight=V200010b]
estimates store dk1
logit dkclimate hostilesexism b3.partyid3 [pweight=V200010b]
estimates store dk2
logit dkclimate hostilesexism b3.partyid3 educscale male [pweight=V200010b]
estimates store dk3

logit dkclimate hostilesexism b3.partyid3 educscale male [pweight=V200010b]
eststo sexism:  margins, at(hostilesexism=(1(1)5))  atmeans post

coefplot (sexism, label (ANES Sample)), ///
	xtitle ("Sexism") ///
	ytitle ("Meta Ignorance") ///
	title ("ANES") ///
	at recast(line) lwidth(*2) ciopts(recast(rline) lc(gray) lp(-) lw(vthin)) ///
	ylab(0 "0%" .25 "25%" .5 "50%", labsize(small)) ///
	xlab(1 "Low" 3 "Medium" 5 "High", labsize(small)) name(ANES, replace)
	graph save "anes.gph", replace
	
esttab dk1 dk2 dk3 using "table1b.rtf", replace cells(b(star fmt(3)) se(par fmt(3))) stats(N pr2, labels("N. of cases") fmt(0)) label legend varlabels(_cons Constant)
	

eststo clear 
logit dkclimate hostilesexism b3.partyid3 educscale male [pweight=V200010b]
eststo men:  margins, at(hostilesexism=(1(1)5) male==1)  atmeans post
logit dkclimate hostilesexism b3.partyid3 educscale male [pweight=V200010b]
eststo women:  margins, at(hostilesexism=(1(1)5) male==0)  atmeans post
logit dkclimate hostilesexism b3.partyid3 educscale male [pweight=V200010b]
eststo Dems:  margins, at(hostilesexism=(1(1)5) partyid3==1)  atmeans post
logit dkclimate hostilesexism b3.partyid3 educscale male [pweight=V200010b]
eststo Reps:  margins, at(hostilesexism=(1(1)5) partyid3==2)  atmeans post

set scheme plotplain
coefplot (men, label (Men)) (women, label (Women)), ///
	ytitle ("Sexism")   title("") legend (row(1) pos(6)) ///
	xtitle ("Meta-ignorance") ///
	xlab(1 "Low" 3 "Medium" 5 "High", labsize(small)) ///
	ylab(0 "0%" .25 "25%" .5 "50%", labsize(small)) ///
	at recast(line) lwidth(*2) ciopts(recast(rline) lpattern(dash)) 

coefplot (Dems, label (Democrats)) (Reps, label (Republicans)), ///
	ytitle ("Sexism")   title("") legend (row(1) pos(6)) ///
	xtitle ("Meta-ignorance") ///
	xlab(1 "Low" 3 "Medium" 5 "High", labsize(small)) ///
	ylab(0 "0%" .25 "25%" .5 "50%", labsize(small)) ///
	at recast(line) lwidth(*2) ciopts(recast(rline) lpattern(dash)) 


************* TABLE 4

eststo clear
reg climimportance hostilesexism dkclimate b3.partyid3 educscale male [pweight=V200010b]
estimates store importance
reg climweather hostilesexism dkclimate b3.partyid3 educscale male [pweight=V200010b]
estimates store weather
reg regulate hostilesexism dkclimate b3.partyid3 educscale male [pweight=V200010b]
estimates store ghg

esttab importance weather ghg using "table4.rtf", replace cells(b(star fmt(3)) se(par fmt(3))) stats(N r2, labels("N. of cases")) label legend varlabels(_cons Constant)

// graph

eststo clear
reg climimportance hostilesexism dkclimate b3.partyid3 educscale male [pweight=V200010b]
eststo importance:  margins, at(hostilesexism=(1(1)5))  atmeans post
reg climweather hostilesexism dkclimate b3.partyid3 educscale male [pweight=V200010b]
eststo weather:  margins, at(hostilesexism=(1(1)5))  atmeans post
reg regulate hostilesexism dkclimate b3.partyid3 educscale male [pweight=V200010b]
eststo regulate:  margins, at(hostilesexism=(1(1)5))  atmeans post

coefplot (importance, label (Importance)), ///
	xtitle ("Sexism") ///
	title ("Importance") ///
	at recast(line) lwidth(*2) ciopts(recast(rline) lc(gray) lp(-) lw(vthin)) ///
	ylab(1 "0%" 3 "50%" 5 "100%", labsize(small)) ///
	xlab(1 "Low" 3 "Medium" 5 "High", labsize(small)) name(importance, replace)
	
coefplot (weather, label (Importance)), ///
	xtitle ("Sexism") ///
	title ("Impact weather") ///
	at recast(line) lwidth(*2) ciopts(recast(rline) lc(gray) lp(-) lw(vthin)) ///
	ylab(1 "0%" 3 "50%" 5 "100%", labsize(small)) ///
	xlab(1 "Low" 3 "Medium" 5 "High", labsize(small)) name(weather, replace)
	
coefplot (regulate, label (Importance)), ///
	xtitle ("Sexism") ///
	title ("Regulate GHGs") ///
	at recast(line) lwidth(*2) ciopts(recast(rline) lc(gray) lp(-) lw(vthin)) ///
	ylab(1 "0%" 2 "50%" 3 "100%", labsize(small)) ///
	xlab(1 "Low" 3 "Medium" 5 "High", labsize(small)) name(regulate, replace)
	
graph combine importance weather regulate, title(Effects of hostile sexism on views about climate change) row(1) graphregion(margin(none)) ysize(4) 
graph save "ANESclimateviews1.gph", replace


reg climimportance hostilesexism dkclimate b3.partyid3 educscale male [pweight=V200010b]
eststo importance2:  margins, at(dkclimate=(0(1)1))  atmeans post
reg climweather hostilesexism dkclimate b3.partyid3 educscale male [pweight=V200010b]
eststo weather2: margins, at(dkclimate=(0(1)1))  atmeans post
reg regulate hostilesexism dkclimate b3.partyid3 educscale male [pweight=V200010b]
eststo regulate2: margins, at(dkclimate=(0(1)1))  atmeans post

coefplot (importance2, label (Importance)), ///
	xtitle ("Meta-ignorance") ///
	title ("Importance") ///
	at recast(line) lwidth(*2) ciopts(recast(rline) lc(gray) lp(-) lw(vthin)) ///
	ylab(1 "0%" 3 "50%" 5 "100%", labsize(small)) ///
	xlab(0 "Low" 1 "High", labsize(small)) name(importance2, replace)
	
coefplot (weather2, label (Weather)), ///
	xtitle ("Meta-ignorance") ///
	title ("Impact weather") ///
	at recast(line) lwidth(*2) ciopts(recast(rline) lc(gray) lp(-) lw(vthin)) ///
	ylab(1 "0%" 3 "50%" 5 "100%", labsize(small)) ///
	xlab(0 "Low" 1 "High", labsize(small)) name(weather2, replace)
	
coefplot (regulate2, label (Regulation)), ///
	xtitle ("Meta-ignorance") ///
	title ("Regulate GHGs") ///
	at recast(line) lwidth(*2) ciopts(recast(rline) lc(gray) lp(-) lw(vthin)) ///
	ylab(1 "0%" 2 "50%" 3 "100%", labsize(small)) ///
	xlab(0 "Low" 1 "High", labsize(small)) name(regulate2, replace)
	
graph combine importance2 weather2 regulate2, title(Effects of meta-ignorance on views about climate change) row(1) graphregion(margin(none)) ysize(4) 
graph save "ANESclimateviews2.gph", replace

graph combine ANESclimateviews1.gph ANESclimateviews2.gph, row(2) graphregion(margin(none)) ysize(4) 
	
	
set scheme plotplain
coefplot (men, label (Men)) (women, label (Women)), ///
	ytitle ("Meta-ignorance")   title("") legend (row(1) pos(6)) ///
	xtitle ("Sexism") ///
	xlab(1 "Low" 3 "Medium" 5 "High", labsize(small)) ///
	ylab(0 "0%" .25 "25%" .5 "50%", labsize(small)) ///
	at recast(line) lwidth(*2) ciopts(recast(rline) lpattern(dash)) name(Lgender, replace)

coefplot (Dems, label (Democrats)) (Reps, label (Republicans)), ///
	ytitle ("Meta-ignorance")   title("") legend (row(1) pos(6)) ///
	xtitle ("Sexism") ///
	xlab(1 "Low" 3 "Medium" 5 "High", labsize(small)) ///
	ylab(0 "0%" .25 "25%" .5 "50%", labsize(small)) ///
	at recast(line) lwidth(*2) ciopts(recast(rline) lpattern(dash)) name(Lpid, replace)

graph combine Lgender Lpid, title(Meta-ignorance in Lucid sample) ycommon row(1) graphregion(margin(none)) ysize(4) 

************* Appendix: Correlation matrix

tab partyid3, gen(pid)
rename pid3 Independent
rename pid2 Republican
rename pid1 Democratic

asdoc pwcorr dkclimate hostilesexism climimportance climweather regulateghgs Democratic Republican educscale male, replace
asdoc pwcorr dkclimate hostilesexism climimportance climweather regulateghgs Democratic Republican educscale male, sig star(0.05) replace


