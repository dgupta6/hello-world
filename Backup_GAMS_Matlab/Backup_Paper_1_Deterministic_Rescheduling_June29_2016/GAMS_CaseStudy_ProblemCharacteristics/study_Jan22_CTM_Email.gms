*PARAMETER demand_magnitude NOMINAL LOAD /25/;
*MH      Moving Horizon Length           /MH0 6,MH1001 9, MH1 12, MH2 15, MH3 18, MH4 21, MH5 24, MH6 30, MH7 36, MH8 42, MH9 48/;
SETS
*DESIGN PARAMETERS
MH      Moving Horizon Length           /MH1*MH2/
RF      Rescheduling Frequency          /RF1/
OPT     Optimality gap                  /OPT1*OPT5/
*TESTING OVER SPACE OF
N       Network                         /N1*N3,N4/
DF      Demand Freq                     /DF1*DF4/
*Variation in temporal position of demand
DV      Demand Variation                /DV1/
DL      Demand Load                     /DL1*DL3/
*Uncertainty in magnitude of demand
DU      Demand Uncertainty              /DU1/
MC      Monte Carlo Run#                /MC1*MC10/
S       surprise                        /S1/
*S       surprise                        /S0 0,S1 0.25/
Obj     MinCost or MaxProfit            /Cost,Profit/;


*Testing space
TABLE par_DF(N,DF)
        DF1     DF2     DF3     DF4
N1      2       4       6       8
N2      3       6       9       12
N3      5       10      15      20
N4      3       6       9       12;
TABLE par_DV(DF,DV)
        DV1
DF1     1
DF2     1
DF3     2
DF4     3;

*DEMAND MAGNITUDE
*APPROX 50%, 80% and 100% load
PARAMETER
$ontext
par_DM(N,DF,DL)  /N1.DF1.(DL1 1,DL2 3,DL3 5),
                  N2.DF1.(DL1 3,DL2 4,DL3 5),
                  N3.DF1.(DL1 1,DL2 3,DL3 5),
                  N4.DF1.(DL1 1,DL2 2,DL3 3),
                  N4.DF2.(DL1 2,DL2 3,DL3 5),
                  N4.DF3.(DL1 4,DL2 6,DL3 8),
                  N4.DF4.(DL1 5,DL2 8,DL3 10)/;
$offtext
par_DM(N,DF,DL)  /N2.DF1.(DL1 3,DL2 4,DL3 5)/;
par_DM(N,DF,DL)$(ord(N) eq 2)= par_DM(N,'DF1',DL)*(par_DF(N,DF)/par_DF(N,'DF1'));



*Demand magnitude uncertainty
PARAMETER par_DU(DL,DU),par_S(S);
par_DU(DL,DU)=0.1;
par_S(S)=0;
*Now setting seed for each demand monte carlo sample
PARAMETER seed(MC);
loop MC do seed(MC)=UniformInt(1,card(MC)*999); endloop
display seed;

*Design decisions
PARAMETER
par_MH(N,DF,MH)
par_RF(N,DF,RF)
par_OPT(N,OPT);

par_MH(N,DF,MH)= 12+18*(ord(MH)-1);
par_RF(N,DF,RF)$(ord(RF) eq 1)= 3;
par_OPT(N,OPT)=0.025*(ord(OPT)-1);

MH_max=smax((N,DF,MH),par_MH(N,DF,MH));
*N       Network                         /N1 1,N2 2,N3 3/
*RF      Rescheduling Frequency          /RF0 0,RF1 1, RF2 3, RF3 6/
*OPT     Optimality gap                  /OPT0 0, OPT1 0.025, OPT2 0.05, OPT3 0.075, OPT4 0.1/;


*Due to difference in complexities we only want certain combinations of N,MH
SET N_DL_combination(N,DL);
N_DL_combination(N,DL)=no;
N_DL_combination(N,DL)$(ord(N) eq 2)=yes;

SET N_MH_combination(N,MH);
N_MH_combination(N,MH)=no;
*N_MH_combination(N,MH)=yes$( (ord(N) eq 1 and ord(MH) le 3) OR (ord(N) gt 1 and ord(MH) gt 1));
N_MH_combination(N,MH)$(ORD(N) eq 2)=yes;
display N_MH_combination;

SET Demand_combination(DF,DV,DL,DU,S);
Demand_combination(DF,DV,DL,DU,S)=no;
Demand_combination(DF,DV,DL,DU,S)$(ord(DU) eq 1 AND ord(S) eq 1)=yes;
display Demand_combination;

SET N_Obj_combination(N,OBJ);
N_Obj_combination(N,OBJ)=no;
N_Obj_combination(N,OBJ)=yes;

SET comb_OBJ_DL(OBJ,DL);
comb_OBJ_DL(OBJ,DL)=no;
*comb_OBJ_DL(OBJ,DL)$(ord(OBJ) eq 1)=yes;
comb_OBJ_DL(OBJ,DL)$(ord(OBJ) eq 2 AND ord(DL) eq 1)=yes;


SET comb(N,MH,RF,OPT);
comb(N,MH,RF,OPT)= no;
comb(N,MH,RF,OPT)= yes;

*comb(N,MH,RF,DL,OPT)$(ord(N) ge 1 and ord(MH) eq 1 and Ord(RF) eq 1 and ORd(DL) eq 2 and ord(OPT) eq 1)= yes;
*comb(N,MH,RF,L,OPT)$(ord(OPT) eq 1)= yes;
*comb(N,MH,RF)$(ord(N) eq 1 and ord(MH) eq 1)= yes;
*comb(N,MH,RF,OPT)$(ord(N) eq 1 AND ord(MH) eq 1 AND ord(RF) eq 1 AND ord(OPT) eq 1)= yes;
*Only allowing certain combinations of Networks and Moving horizons
*comb(N,MH,RF,DL,OPT)$(NOT N_MH_combination(N,MH))=no;
