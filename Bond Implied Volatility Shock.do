

clear
capture log close
set logtype text
log using tyvixshock.txt, replace


import fred VXTYN EFFR DJIA, daterange(2012-05-07 2020-05-15) aggregate(daily)



tsset daten

tsline VXTYN

rename VXTYN TYVIX
rename EFFR FED
rename T10Y2Y Tentwospread
rename VIXCLS VIX

/*Regression*/
reg FED TYVIX DJIA


*Select the lag length p 
varsoc FED TYVIX DJIA, maxlag(10) 
*AIC suggests that I should choose lag length 5


*Check the statonarity of VAR(p) 
quietly var FED TYVIX DJIA, lags(1/5) 
 
varlmar, mlag(12)
*LM test shows that we cannot reject the null hypothesis that there is no autocorrelation at lag 5.


/*Entire system Stability Check*/
var FED TYVIX DJIA 
varstable, graph

/*they are stable*/

/*VAR model begins*/
capture irf drop order1
var FED TYVIX Tentwospread VIX, lags(1/4) dfk
irf create order1, step(10) set(myFedirf,replace)
irf graph oirf, impulse(FED) response(TYVIX DJIA) 
irf table oirf, impulse(FED) response(TYVIX DJIA) 


log cl
