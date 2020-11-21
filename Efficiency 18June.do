use "N:\GrpNCS_Tequila\Summer_yb\IRIS AUTM JC.dta", clear
cd "N:\GrpNCS_Tequila\Summer 2020"

*Turning into Panel
xtset dmu year
sort dmu year

*Cleaning
destring *, replace force

gen lnnih = ln(exp_nih)
gen lnusda = ln(exp_usda)
gen lnnsf = ln(exp_nsf)
gen lnindustry = ln(indresexp)
gen lnactive = ln(actlic)
gen lnpatents = ln(totpatappfld)
gen lnstartups = ln(stupsformed)
gen lndisclose = ln(totdiscllic)
gen lnincome = ln(grosslicinc)
gen lnstaff = ln(licftes)

*SFA

*SFA Fixed Effects Tests
xtreg lnactive lnstaff lnnsf lnindustry, fe
predict feactive, u /*fixed effect*/
quietly summarize feactive
generate double u_staractive = r(max)- feactive /* equation (10.4) */
generate double eff_feactive = exp(-u_staractive) /* equation (10.5) */
summarize eff_feactive
outreg2 using FixedEffectsSFA.doc, replace ctitle(Licenses) stats(coef se) 

xtreg lnpatents lnstaff lnnsf lnindustry, fe
predict fepatents, u /*fixed effect*/
quietly summarize fepatents
generate double u_starpatents = r(max)- fepatents /* equation (10.4) */
generate double eff_fepatents = exp(-u_starpatents) /* equation (10.5) */
summarize eff_fepatents
outreg2 using FixedEffectsSFA.doc, append ctitle(Patents) stats(coef se) 

xtreg lnstartups lnstaff lnnsf lnindustry, fe
predict festartup, u /*fixed effect*/
quietly summarize festartup
generate double u_starstartup = r(max)- festartup /* equation (10.4) */
generate double eff_festartup = exp(-u_starstartup) /* equation (10.5) */
summarize eff_festartup
outreg2 using FixedEffectsSFA.doc, append ctitle(Startups) stats(coef se) 

xtreg lndisclose lnstaff lnnsf lnindustry, fe
predict fedisclose, u /*fixed effect*/
quietly summarize fedisclose
generate double u_stardisclose = r(max)- fedisclose /* equation (10.4) */
generate double eff_fedisclose = exp(-u_stardisclose) /* equation (10.5) */
summarize eff_fedisclose
outreg2 using FixedEffectsSFA.doc, append ctitle(Disclosure) stats(coef se) 

xtreg lnincome lnstaff lnnsf lnindustry, fe
predict feincome, u /*fixed effect*/
quietly summarize feincome
generate double u_starincome = r(max)- feincome /* equation (10.4) */
generate double eff_feincome = exp(-u_starincome) /* equation (10.5) */
summarize eff_feincome
outreg2 using FixedEffectsSFA.doc, append ctitle(Income) stats(coef se) 

*Basic SFA
xtfrontier lnactive lnnih lnnsf lnindustry, ti
predict activeTE, te
outreg2 using SFABasic.doc, replace ctitle(Licenses) stats(coef se) 
xtfrontier lnpatents lnnih lnnsf lnindustry, ti
predict patentTE, te
outreg2 using SFABasic.doc, append ctitle(Patents) stats(coef se) 
xtfrontier lnstartups lnnih lnnsf lnindustry, ti
predict startupTE, te
outreg2 using SFABasic.doc, append ctitle(Startups) stats(coef se) 
xtfrontier lndisclose lnnih lnnsf lnindustry, ti
predict discloseTE, te
outreg2 using SFABasic.doc, append ctitle(Disclosures) stats(coef se) 
xtfrontier lnincome lnnih lnnsf lnindustry, ti
outreg2 using SFABasic.doc, append ctitle(Income) stats(coef se) 

*Staff FTEs
xtfrontier lnactive lnstaff lnnsf lnindustry, ti
predict STAFFactiveTE, te
outreg2 using staffSFABasic.doc, replace ctitle(Licenses) stats(coef se) 

xtfrontier lnpatents lnstaff lnnsf lnindustry, ti
predict STAFFpatentsTE, te
outreg2 using staffSFABasic.doc, append ctitle(Patents) stats(coef se) 

xtfrontier lnincome lnstaff lnnsf lnindustry, ti
predict STAFFincomeTE, te
outreg2 using staffSFABasic.doc, append ctitle(Income) stats(coef se) 

xtfrontier lndisclose lnstaff lnnsf lnindustry, ti
predict STAFFdisclosuresTE, te
outreg2 using staffSFABasic.doc, append ctitle(Disclosures) stats(coef se) 

xtfrontier lnstartups lnstaff lnnsf lnindustry, ti
predict STAFFstartupsTE, te
outreg2 using staffSFABasic.doc, append ctitle(Startups) stats(coef se) 

*Cost Functions
xtfrontier lnindustry lnactive lnincome lnstartups lndisclose, ti cost
predict industryTE, te
xtfrontier lnnsf lnactive lnincome lnstartups, ti cost
predict nsfTE, te
xtfrontier lnnih lnactive lnincome lnstartups, ti cost
predict nihTE, te
xtfrontier lnusda lnactive lnincome lnstartups, ti cost
predict usdaTE, te

*Correlations
spearman activeTE patentTE startupTE discloseTE
spearman activeTE patentTE startupTE discloseTE, stats(p)
spearman industryTE nsfTE nihTE usdaTE
spearman industryTE nsfTE nihTE usdaTE, stats(p)

*USE THESE CORELATIONS
spearman STAFFactiveTE STAFFpatentsTE STAFFstartupsTE STAFFdisclosuresTE STAFFincomeTE
spearman STAFFactiveTE STAFFpatentsTE STAFFstartupsTE STAFFdisclosuresTE STAFFincomeTE, stats(p)
