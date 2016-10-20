$Title State_Space_Model
*OPTIONS limrow = 0, limcol = 0, solprint = off;
OPTIONS limrow = 1000, limcol = 1000, solprint = on;
*No upper limit on inventory (equation not enforced)

*used for rounding W,B in recordstates in modelsolution file
PARAMETER Small_number /1E-2/;

*Now generating time grid using delta
$EvalGlobal horizon floor(%H%/%delta%)
$EvalGlobal window floor(%MH%/%delta%)
*$EvalGlobal calculations (%horizon%-%window%)
$EvalGlobal Transient_H_delta floor(%Transient_H%/%delta%)
$EVALGLOBAL Closed_Loop_Upper_delta floor(%Closed_Loop_Upper%/%delta%)
$EvalGlobal calculations %Closed_Loop_Upper_delta%

set h time(multiples of delta) /h0*h%horizon%/
    n time window   /n0*n%window%/
    calc #of windows /calc0*calc%calculations%/

    closed_loop(h) horizon points for which we calculate closed loop cost

    Sbari(s,i)  materials produced by task i
    Si(s,i)     materials consumed by task i
    Tbars(i,s)    Tasks producing material s
    Ts(i,s) Tasks consuming material s;

Sbari(s,i)=1$(rhobar(i,s) gt 0);
Si(s,i)=1$(rho(i,s) gt 0);
*Ij(i,j)=Ki(j,i);
Tbars(i,s)=Sbari(s,i);
Ts(i,s)=Si(s,i);

closed_loop(h)=0;
closed_loop(h)$(ord(h)-1 ge %Transient_H_delta% and ord(h)-1 le %Closed_Loop_Upper_delta%)=1;


alias(i,ip)
alias(j,jp)
alias(s,sp)
alias(n,np)
alias(h,hbar);

set     UnitUnavailable_full(j,h)
UnitUnavailable(j,n);

parameter Uutmax_full(u,h),Cut_full(u,h) utility price;

parameters Dst(s,n),Uutmax(u,n),Cut(u,n);


parameter pis_new(i,s),pi_new(i);
*tau_new(j,k,kp);
pis_new(i,s)=ceil(pis(i,s)/%delta%);
pi_new(i)=ceil(pi(i)/%delta%);

parameter alpha_new(u,i),beta_new(u,i),Cst_new(s);

alpha_new(u,i)=alpha(u,i);

beta_new(u,i)=beta(u,i);

Cst_new(s)=Cst(s);




*UTILITY CALCULATIONS NEED TO BE CORRECTED
*RIGHT NOW THERE IS BUG THAT IF THERE IS MORE THAN ONE CHANGE
*WITHIN AN INTERVAL THEN THE CODE TAKES FIRST CHANGE ONLY
*AND IGNORES THE SECOND CHANGE
loop(UtilInt,
*Maximum available utility
Uutmax_full(u,h)$(ord(UtilInt) eq 1 and
                 ord(h) ge 1 and
                 ord(h)-1 lt (floor(UtilData(UtilInt+1,u,"starttime")/%delta%)$(UtilData(UtilInt,u,"magnitude") gt UtilData(UtilInt+1,u,"magnitude"))+
                              ceil(UtilData(UtilInt+1,u,"starttime")/%delta%)$(UtilData(UtilInt,u,"magnitude") le UtilData(UtilInt+1,u,"magnitude")) ))
                =  UtilData(UtilInt,u,"magnitude");




Uutmax_full(u,h)$((ord(UtilInt) gt 1 and ord(UtilInt) lt card(UtilInt)) and
                 ord(h)-1 ge (floor(UtilData(UtilInt,u,"starttime")/%delta%)$(UtilData(UtilInt-1,u,"magnitude") gt UtilData(UtilInt,u,"magnitude"))+
                              ceil(UtilData(UtilInt,u,"starttime")/%delta%)$(UtilData(UtilInt-1,u,"magnitude") le UtilData(UtilInt,u,"magnitude")) ) and
                 ord(h)-1 lt (floor(UtilData(UtilInt+1,u,"starttime")/%delta%)$(UtilData(UtilInt,u,"magnitude") gt UtilData(UtilInt+1,u,"magnitude"))+
                              ceil(UtilData(UtilInt+1,u,"starttime")/%delta%)$(UtilData(UtilInt,u,"magnitude") le UtilData(UtilInt+1,u,"magnitude")) ))
                =  UtilData(UtilInt,u,"magnitude");



Uutmax_full(u,h)$(ord(UtilInt) eq card(UtilInt) and
                 ord(h)-1 ge (floor(UtilData(UtilInt,u,"starttime")/%delta%)$(UtilData(UtilInt-1,u,"magnitude") gt UtilData(UtilInt,u,"magnitude"))+
                              ceil(UtilData(UtilInt,u,"starttime")/%delta%)$(UtilData(UtilInt-1,u,"magnitude") le UtilData(UtilInt,u,"magnitude")) ) and
                 ord(h) le card(h))
                =  UtilData(UtilInt,u,"magnitude");


*Utility Price
Cut_full(u,h)$(ord(UtilInt) eq 1 and
          ord(h)-1 lt (floor(UtilData(UtilInt+1,u,"starttime")/%delta%))   )
          =  UtilData(UtilInt,u,"price");

Cut_full(u,h)$(ord(UtilInt) gt 1 and ord(UtilInt) lt card(UtilInt) and
          ord(h)-1 gt (floor(UtilData(UtilInt,u,"starttime")/%delta%)) and
          ord(h)-1 lt (floor(UtilData(UtilInt+1,u,"starttime")/%delta%))   )
          =  UtilData(UtilInt,u,"price");

Cut_full(u,h)$(ord(UtilInt) eq card(UtilInt) and
          ord(h)-1 gt floor(UtilData(UtilInt,u,"starttime")/%delta%) and
          ord(h) le card(h)   )
          =  UtilData(UtilInt,u,"price");

Cut_full(u,h)$(ord(UtilInt) gt 1 and
         ord(h)-1 eq floor(UtilData(UtilInt,u,"starttime")/%delta%))
         =(   UtilData(UtilInt-1,u,"price")*(UtilData(UtilInt,u,"starttime")-(ord(h)-1)* %delta% )
              +UtilData(UtilInt,u,"price")*(ord(h)*%delta%-UtilData(UtilInt,u,"starttime"))   )/%delta%;
*Bug in cost calculation: what if there are 3 cost levels within one time grid?
)


*UnitUnavailabality(note the difference in inequalities as opposed to Utility....1=>unit not available so more magnitude is bad)
loop(UnitInt,
Unitunavailable_full(j,h)$(ord(UnitInt) eq 1 and
                 ord(h)-1 ge 0 and
                 ord(h)-1 lt (floor(UnitData(UnitInt+1,j,"starttime")/%delta%)$(UnitData(UnitInt,j,"magnitude") lt UnitData(UnitInt+1,j,"magnitude"))+
                              ceil(UnitData(UnitInt+1,j,"starttime")/%delta%)$(UnitData(UnitInt,j,"magnitude") ge UnitData(UnitInt+1,j,"magnitude")) ))
                =  UnitData(UnitInt,j,"magnitude");




Unitunavailable_full(j,h)$((ord(UnitInt) gt 1 and ord(UnitInt) lt card(UnitInt)) and
                 ord(h)-1 ge (floor(UnitData(UnitInt,j,"starttime")/%delta%)$(UnitData(UnitInt-1,j,"magnitude") lt UnitData(UnitInt,j,"magnitude"))+
                              ceil(UnitData(UnitInt,j,"starttime")/%delta%)$(UnitData(UnitInt-1,j,"magnitude") ge UnitData(UnitInt,j,"magnitude")) ) and
                 ord(h)-1 lt (floor(UnitData(UnitInt+1,j,"starttime")/%delta%)$(UnitData(UnitInt,j,"magnitude") lt UnitData(UnitInt+1,j,"magnitude"))+
                              ceil(UnitData(UnitInt+1,j,"starttime")/%delta%)$(UnitData(UnitInt,j,"magnitude") ge UnitData(UnitInt+1,j,"magnitude")) ))
                =  UnitData(UnitInt,j,"magnitude");



Unitunavailable_full(j,h)$(ord(UnitInt) eq card(UnitInt) and
                 ord(h)-1 ge (floor(UnitData(UnitInt,j,"starttime")/%delta%)$(UnitData(UnitInt-1,j,"magnitude") lt UnitData(UnitInt,j,"magnitude"))+
                              ceil(UnitData(UnitInt,j,"starttime")/%delta%)$(UnitData(UnitInt-1,j,"magnitude") ge UnitData(UnitInt,j,"magnitude")) ) and
                 ord(h) le card(h))
                =  UnitData(UnitInt,j,"magnitude");
)



*display UnitUnavailable_full,Uutmax_full,Cut_full,Sbari,Si,rhobar,rho,Tbars,Ts,calc;

*Ijk,tauChangeMax



*Disturbance parameter for loading/unloading of materials
parameters betaHatProd(i,j,s,n),betaHatCons(i,j,s,n);
betaHatProd(i,j,s,n)=0;
betaHatCons(i,j,s,n)=0;


*Disturbance parameter for task delays
parameters
Yhat(i,j,n,hbar)
Delay(calc,i,j,hbar)
Zhat(i,j,n,hbar)
Breakdown(calc,i,j,hbar)
Duration_breakdown(calc,j)
UnitBroken(j,n)
WbarInfo(i,j,n,hbar)
BbarInfo(i,j,n,hbar)
KillDuration(i,j)
KillDurationCountdown(i,j)
KillOccupy(j,n)
KillCountdown(j);

*Initializing parameters
Yhat(i,j,n,hbar)=0;
Delay(calc,i,j,hbar)=0;
Zhat(i,j,n,hbar)=0;
Breakdown(calc,i,j,hbar)=0;
Duration_breakdown(calc,j)=0;
UnitBroken(j,n)=0;
WbarInfo(i,j,n,hbar)=0;
BbarInfo(i,j,n,hbar)=0;
KillDuration(i,j)=0;
KillDurationCountdown(i,j)=0;
KillOccupy(j,n)=0;
KillCountdown(j)=0;

*hbar are the time points for lifting of variables
*binary variables W(i,j,n),Wbar(i,j,n,hbar),T(i,j,hbar) Kill_Variable;
binary variables Wbar(i,j,n,hbar),T(i,j,hbar) Kill_Variable;
positive variable Bbar(i,j,n,hbar),Sst(s,n),Backlog(s,n),Ship(s,n),Ship_sales(s,n),Uut(u,n),Rst(s,n),SstTerminal(s),BacklogTerminal(s);
variables obj_variable;
integer variable NB(i,j) number of batches;
*Assigning values to variables that might not participate in optimization
Uut.l(u,n)=0;Ship_sales.l(s,n)=0;

Equations
numberOfBatches,
Allocation,
UnitCapacityMax,UnitCapacityMin,
InventoryLimit,
InventoryBalance,
EndingInventory,
BacklogBalance,
EndingBacklog,
UtilityLimit,
UtilityBalance,
objective_MIN_COST,
objective_MAX_PROFIT,
objective_MAX_PROFIT_Greedy
UnitUnavailabality,
*CorrectHolding(i,j,n),
LiftingW,
*LiftingW0,
LiftingB,
*LiftingB0,
Carryover_W,Carryover_B,
InventoryBalance_MAX_PROFIT,
EndingInventory_MAX_PROFIT
Ship_constraint(s,n)
NoShip(s,n)
ShipEqualDemand;
*SHIPMENT;
*NoTaskRunningAtEndOfHorizon;

numberOfBatches(i,j)$Ij(i,j).. NB(i,j)=E=sum((n,hbar)$(ord(hbar)-1 eq 0),Wbar(i,j,n,hbar));

*scalar ord_calc /0/;
SCALAR fixed_decisions /0/;
SCALAR reschedule_flag /0/;
*re_freq-1-mod(ord_calc-1+re_freq-1,re_freq)  is zero for calc0
Carryover_W(i,j,n,hbar)$(ord(n)-1 le fixed_decisions and ord(hbar)-1 ge 1 and ord(hbar)-1 le pi(i) and Ij(i,j))..Wbar(i,j,n,hbar)=E=WbarInfo(i,j,n,hbar)*(1-T(i,j,hbar))*(1-Zhat(i,j,n,hbar));
Carryover_B(i,j,n,hbar)$(ord(n)-1 le fixed_decisions and ord(hbar)-1 ge 1 and ord(hbar)-1 le pi(i) and Ij(i,j))..Bbar(i,j,n,hbar)=E=BbarInfo(i,j,n,hbar)*(1-T(i,j,hbar))*(1-Zhat(i,j,n,hbar));

*LiftingW(i,j,n,hbar)$((ord(hbar)-1 ge 1) and (ord(hbar)-1 le pi(i)) and (ord(n) lt card(n)) and Ij(i,j))..
*         Wbar(i,j,n+1,hbar)=E=Wbar(i,j,n,hbar-1)+Yhat(i,j,n,hbar)-Yhat(i,j,n,hbar-1)-Zhat(i,j,n,hbar-1);
*LiftingB(i,j,n,hbar)$((ord(hbar)-1 ge 1) and (ord(hbar)-1 le pi(i)) and (ord(n) lt card(n)) and Ij(i,j))..
*         Bbar(i,j,n+1,hbar)=E=Bbar(i,j,n,hbar-1)+Bbar(i,j,n,hbar)*Yhat(i,j,n,hbar)-Bbar(i,j,n,hbar-1)*Yhat(i,j,n,hbar-1)

LiftingW(i,j,n,hbar)$((ord(hbar)-1 ge 1) and (ord(hbar)-1 le pi(i)) and (ord(n) lt card(n)) and Ij(i,j))..
         Wbar(i,j,n+1,hbar)=E=Wbar(i,j,n,hbar-1)+Yhat(i,j,n,hbar)-Yhat(i,j,n,hbar-1);

LiftingB(i,j,n,hbar)$((ord(hbar)-1 ge 1) and (ord(hbar)-1 le pi(i)) and (ord(n) lt card(n)) and Ij(i,j))..
         Bbar(i,j,n+1,hbar)=E=Bbar(i,j,n,hbar-1)+Bbar(i,j,n,hbar)*Yhat(i,j,n,hbar)-Bbar(i,j,n,hbar-1)*Yhat(i,j,n,hbar-1);
Allocation(j,n).. sum((i,hbar)$(Ij(i,j) and (ord(hbar) -1 le (pi_new(i)-1)) ), Wbar(i,j,n,hbar))=L=1-sum((i,hbar)$(Ij(i,j) and (ord(hbar) -1 eq pi_new(i)) ) , Yhat(i,j,n,hbar))-UnitBroken(j,n)
                      -sum((i,hbar)$(Ij(i,j) and ord(hbar)-1 ge 1 and ord(hbar)-1 le pi(i)),T(i,j,hbar)$(ord(n)-1 lt KillDuration(i,j)))-KillOccupy(j,n);
*ord(np)-1=0 => Wbar0 which is also included in the above sum, so we dont have to explicitly sum over W now since W0 is also there

UnitCapacityMax(i,j,n,hbar)$(Ij(i,j) and ord(hbar)-1 eq 0).. Bbar(i,j,n,hbar)=L=Wbar(i,j,n,hbar)*vmaxij(i,j);

UnitCapacityMin(i,j,n,hbar)$(Ij(i,j) and ord(hbar)-1 eq 0).. Bbar(i,j,n,hbar)=G=Wbar(i,j,n,hbar)*vminij(i,j);

InventoryLimit(s,n)$(FIS(s)).. Sst(s,n)=L=Cs(s);

InventoryBalance(s,n)$(ord(n) lt card(n)).. Sst(s,n+1)=E=Sst(s,n)+sum((i,j,hbar)$(Tbars(i,s) and Ij(i,j) and (ord(hbar) -1 eq pis_new(i,s))),rhobar(i,s)*(Bbar(i,j,n,hbar)*(1-Yhat(i,j,n,hbar)-Zhat(i,j,n,hbar))+betaHatProd(i,j,s,n)))
                         -sum((i,j,hbar)$(Ts(i,s) and Ij(i,j) and ord(hbar) eq 1),rho(i,s)*Bbar(i,j,n,hbar)+betaHatCons(i,j,s,n)) -Ship(s,n)$(product_states(s))+Rst(s,n)$(feed_states(s));
EndingInventory(s,n)$(ord(n) eq card(n)).. SstTerminal(s)=E=Sst(s,n)+sum((i,j,hbar)$(Tbars(i,s) and Ij(i,j) and (ord(hbar) -1 eq pis_new(i,s))),rhobar(i,s)*(Bbar(i,j,n,hbar)*(1-Yhat(i,j,n,hbar)-Zhat(i,j,n,hbar))+betaHatProd(i,j,s,n)))
                         -sum((i,j,hbar)$(Ts(i,s) and Ij(i,j)and ord(hbar) eq 1),rho(i,s)*Bbar(i,j,n,hbar)+betaHatCons(i,j,s,n)) -Ship(s,n)$(product_states(s))+Rst(s,n)$(feed_states(s));

********
*Inventory at point 2 means, inventory level infinitesimal time just before point 2, ie 2-, need to define extra ending inventory variable SstTerminal(s)
*Deliveries are point functions like B, W while inventory is interval function
*Kondili has convention that inventory at point 2 is 2+, so has to define extra initial inventory parameter Sst0(s)


***********Backlogs******
BacklogBalance(s,n)$(product_states(s) and ord(n) lt card(n)).. Backlog(s,n+1)=E=Backlog(s,n)-Ship(s,n)+Dst(s,n);
EndingBacklog(s,n)$(product_states(s) and ord(n) eq card(n)).. BacklogTerminal(s)=E=Backlog(s,n)-Ship(s,n)+Dst(s,n);

***********UtilityBalance******
UtilityLimit(u,n).. Uut(u,n)=L=Uutmax(u,n);
UtilityBalance(u,n).. Uut(u,n)=E=sum((i,j,hbar)$(Ij(i,j) and (ord(hbar)-1 le pi_new(i)-1)),alpha_new(u,i)*Wbar(i,j,n,hbar)+beta_new(u,i)*Bbar(i,j,n,hbar)  );

UnitUnavailabality(i,j,n)$(UnitUnavailable(j,n) and Ij(i,j)).. sum((hbar)$(ord(hbar)-1 le pi_new(i)-1),Wbar(i,j,n,hbar))=E=0;

*Utility cost: sum((u,n),Cut(u,n)*Uut(u,n))
*objective_MIN_COST.. obj_variable  =E= 1E1*sum(s,Cst_new(s)*SstTerminal(s)) +1E1*sum((s,n),Cst_new(s)*Sst(s,n))
*                                 +1E2*sum((s,n)$(product_states(s)),Cst_new(s)*Backlog(s,n))+1E2*sum(s$(product_states(s)),Cst_new(s)*BacklogTerminal(s))
*                                 +sum((i,j,hbar)$Ij(i,j),T(i,j,hbar));
objective_MIN_COST.. obj_variable  =E= 1E1*sum(s,Cst_new(s)*SstTerminal(s)) + 1E1*sum((s,n),Cst_new(s)*Sst(s,n))
                                 +1E2*sum((s,n)$(product_states(s)),Cst_new(s)*Backlog(s,n))
                                 +1E2*sum(s$(product_states(s)),Cst_new(s)*BacklogTerminal(s))
                                 +sum((i,j,n,hbar)$(Ij(i,j) AND ord(hbar)-1 eq 0),Wbar(i,j,n,hbar));


*objective_MAX_PROFIT.. obj_variable =E= 1E1*sum(s$(product_states(s)),Cst_new(s)*SstTerminal(s))+1E1*sum((s,n)$(product_states(s)),Cst_new(s)*Ship(s,n))
*                                       -1E2*sum((s,n)$(product_states(s)),Cst_new(s)*Backlog(s,n))-1E2*sum(s$(product_states(s)),Cst_new(s)*BacklogTerminal(s) );

*objective_MAX_PROFIT.. obj_variable =E= 1E1*sum((s,n)$(product_states(s)),Cst_new(s)*Sst(s,n))+1E1*sum(s$(product_states(s)),Cst_new(s)*SstTerminal(s))
*                                       -1E2*sum((s,n)$(product_states(s)),Cst_new(s)*Backlog(s,n))-1E2*sum(s$(product_states(s)),Cst_new(s)*BacklogTerminal(s))
*                                       +1E1*sum((s,n)$(product_states(s)),Cst_new(s)*Ship(s,n));

*objective_MAX_PROFIT.. obj_variable =E= sum((s,n)$(product_states(s)),round(2-ord(n)/card(n),2)*Cst_new(s)*Ship(s,n))-sum((i,j,n,hbar)$(Ij(i,j) AND ord(hbar)-1 eq 0),Wbar(i,j,n,hbar));

*objective_MAX_PROFIT.. obj_variable =E= sum((s,n)$(product_states(s)),Cst_new(s)*(Ship_sales(s,n)))
$ontext
objective_MAX_PROFIT.. obj_variable =E= sum((s,n)$(product_states(s)),Cst_new(s)*(Ship(s,n)+Ship_sales(s,n)))
                                         -sum((i,j,n,hbar)$(Ij(i,j) AND ord(hbar)-1 eq 0),Wbar(i,j,n,hbar))
                                         -1E2*sum((s,n)$(product_states(s)),Cst_new(s)*Backlog(s,n))
                                         -1E2*sum(s$(product_states(s)),Cst_new(s)*BacklogTerminal(s));
$offtext
objective_MAX_PROFIT.. obj_variable =E= sum((s,n)$(product_states(s)),Cst_new(s)*(Dst(s,n)+Ship_sales(s,n)))
                                         -sum((i,j,n,hbar)$(Ij(i,j) AND ord(hbar)-1 eq 0),Wbar(i,j,n,hbar));
*                                         -1E2*sum((s,n)$(product_states(s)),Cst_new(s)*Backlog(s,n))
*                                         -1E2*sum(s$(product_states(s)),Cst_new(s)*BacklogTerminal(s));

objective_MAX_PROFIT_Greedy.. obj_variable =E= sum((s,n)$(product_states(s)),round(2-(ord(n)/card(n)),2)*Cst_new(s)*(Ship(s,n)+Ship_sales(s,n)))
                                         -sum((i,j,n,hbar)$(Ij(i,j) AND ord(hbar)-1 eq 0),Wbar(i,j,n,hbar))
                                         -1E2*sum((s,n)$(product_states(s)),Cst_new(s)*Backlog(s,n))
                                         -1E2*sum(s$(product_states(s)),Cst_new(s)*BacklogTerminal(s));

*objective_MAX_PROFIT.. obj_variable =E= sum((s,n)$(product_states(s)),round(2-ord(n)/card(n),2)*Cst_new(s)*Ship(s,n));

*SHIPMENT(s,n).. Ship(s,n)=L=Dst(s,n)  ;
InventoryBalance_MAX_PROFIT(s,n)$(ord(n) lt card(n)).. Sst(s,n+1)=E=Sst(s,n)
                         +sum((i,j,hbar)$(Tbars(i,s) and Ij(i,j) and (ord(hbar) -1 eq pis_new(i,s))),rhobar(i,s)*(Bbar(i,j,n,hbar)*(1-Yhat(i,j,n,hbar)-Zhat(i,j,n,hbar))+betaHatProd(i,j,s,n)))
                         -sum((i,j,hbar)$(Ts(i,s) and Ij(i,j) and ord(hbar) eq 1),rho(i,s)*Bbar(i,j,n,hbar)+betaHatCons(i,j,s,n))
                         -Dst(s,n)-Ship_sales(s,n)$(product_states(s))+Rst(s,n)$(feed_states(s));
*                         -Ship(s,n)$(product_states(s))-Ship_sales(s,n)$(product_states(s))+Rst(s,n)$(feed_states(s));


EndingInventory_MAX_PROFIT(s,n)$(ord(n) eq card(n)).. SstTerminal(s)=E=Sst(s,n)
                         +sum((i,j,hbar)$(Tbars(i,s) and Ij(i,j) and (ord(hbar) -1 eq pis_new(i,s))),rhobar(i,s)*(Bbar(i,j,n,hbar)*(1-Yhat(i,j,n,hbar)-Zhat(i,j,n,hbar))+betaHatProd(i,j,s,n)))
                         -sum((i,j,hbar)$(Ts(i,s) and Ij(i,j)and ord(hbar) eq 1),rho(i,s)*Bbar(i,j,n,hbar)+betaHatCons(i,j,s,n))
                         -Dst(s,n)-Ship_sales(s,n)$(product_states(s))+Rst(s,n)$(feed_states(s));
*                         -Ship(s,n)$(product_states(s))-Ship_sales(s,n)$(product_states(s))+Rst(s,n)$(feed_states(s));
ShipEqualDemand(s,n).. Ship(s,n)=E=Dst(s,n);
*Ship_constraint(s,n)$(ord(n) gt 1 AND ord(n) lt card(n) ).. Ship(s,n)=E=0;
Ship_constraint(s,n)$(Dst(s,n) eq 0).. Ship_sales(s,n)=E=0;

*NoTaskRunningAtEndOfHorizon(i,j,n)$(ord(n) eq card(n) and Ij(i,j))..   sum(hbar$(ord(hbar)-1 le pi_new(i)-1),Wbar(i,j,n,hbar))=E=0;
NoShip(s,n)$(ord(n) lt card(n)/2 and sameas(s,'M4')).. Ship_sales(s,n)=E=0;

*****************
*DISTURBANCE VARIABLES
*Build feature rich instances and do rigorous testing
*****************



SET attributes_states /W,B/;
PARAMETERS
record_states_raw(run,calc,attributes_states,i,j,n,hbar),
record_states(run,calc,attributes_states,i,j,n,hbar),
record_objective(run,calc),
record_utility(run,calc,u,n),
record_inventory(run,calc,s,n),
record_inventory_raw(run,calc,s,n),
record_backlog(run,calc,s,n),
record_backlog_raw(run,calc,s,n),
record_inventoryTerminal(run,calc,s),
record_backlogTerminal(run,calc,s)
record_T(run,calc,i,j,hbar)
record_shipment(run,calc,s,n)
record_shipment_sales(run,calc,s,n)
record_shipment_sales_raw(run,calc,s,n)
record_Rst(run,calc,s,n)
record_shipment_raw(run,calc,s,n)
record_Rst_raw(run,calc,s,n)
record_yieldloss(run,calc,i,j,s,n)
record_demands(run,calc,s,n)
record_WbarInfo(run,calc,i,j,n,hbar)
record_BbarInfo(run,calc,i,j,n,hbar)
record_Demands_realization(run,s,h)
record_fixed_decision(calc)
record_reschedule_flag(calc,run)
record_relaxed_objective(run,calc) Objective from solving RMIP
record_relaxed_states(run,calc,attributes_states,i,j,n,hbar) states from solving RMIP
record_relaxed_shipment(run,calc,s,n)
record_relaxed_shipment_sales(run,calc,s,n)
record_relaxed_backlog(run,calc,s,n);

record_states_raw(run,calc,attributes_states,i,j,n,hbar)=0;
record_states(run,calc,'B',i,j,n,hbar)=0;
record_states(run,calc,'W',i,j,n,hbar)=0;
record_inventory(run,calc,s,n)=0;
record_inventory_raw(run,calc,s,n)=0;
record_backlog(run,calc,s,n)=0;
record_backlog_raw(run,calc,s,n)=0;
record_T(run,calc,i,j,hbar)=0;
record_shipment(run,calc,s,n)=0 ;
record_Rst(run,calc,s,n)=0;
record_shipment_raw(run,calc,s,n)=0;
record_shipment_sales_raw(run,calc,s,n)=0;
record_shipment_sales(run,calc,s,n)=0;
record_Rst_raw(run,calc,s,n)=0;
record_yieldloss(run,calc,i,j,s,n)=0;
record_demands(run,calc,s,n)=0;
record_WbarInfo(run,calc,i,j,n,hbar)=0;
record_BbarInfo(run,calc,i,j,n,hbar)=0;
record_Demands_realization(run,s,h)=0;
record_fixed_decision(calc)=0;
record_reschedule_flag(calc,run)=0;
record_relaxed_objective(run,calc)=0;
record_relaxed_states(run,calc,attributes_states,i,j,n,hbar)=0;
record_relaxed_shipment(run,calc,s,n)=0;
record_relaxed_shipment_sales(run,calc,s,n)=0;
record_relaxed_backlog(run,calc,s,n)=0;

*Initial conditions for first optimization horizon
PARAMETERS InitialBbar(i,j,n,hbar),InitialWbar(i,j,n,hbar),InitialInventory(s),InitialBacklog(s);
InitialBbar(i,j,n,hbar)=0;
InitialWbar(i,j,n,hbar)=0;
InitialInventory(s)=0;
InitialBacklog(s)=0;

*if (%InitialInventoryFlag% eq 1,
*Start with half day of inventory
*InitialInventory(s)$product_states(s)=12*demand_magnitude/demand_cycletime;
*);
InitialInventory(s)$product_states(s)=%InitialInventoryBufferHours%*demand_magnitude/demand_cycletime;


*MODEL P1 /all/;
MODEL MIN_COST /
numberOfBatches,
Allocation,
UnitCapacityMax,
UnitCapacityMin,
*InventoryLimit,
InventoryBalance,
EndingInventory,
BacklogBalance,
EndingBacklog,
*UtilityLimit,
*UtilityBalance,
*UnitUnavailabality,
LiftingW,
LiftingB,
Carryover_W,
Carryover_B,
objective_MIN_COST/;


MODEL MAX_PROFIT /
numberOfBatches,
Allocation,
InventoryBalance_MAX_PROFIT,
EndingInventory_MAX_PROFIT,
LiftingW,
LiftingB,
Carryover_W,
Carryover_B,
objective_MAX_PROFIT
UnitCapacityMax
UnitCapacityMin
*objective_MAX_PROFIT_Greedy
Ship_constraint
ShipEqualDemand/;
*BacklogBalance,
*EndingBacklog,/;
*NoShip/;

MODEL MAX_PROFIT_GREEDY /
numberOfBatches,
EndingInventory_MAX_PROFIT,
BacklogBalance,
EndingBacklog,
LiftingW,
LiftingB,
Carryover_W,
Carryover_B,
*objective_MAX_PROFIT
objective_MAX_PROFIT_Greedy
Ship_constraint
Allocation,
UnitCapacityMax,
UnitCapacityMin,
InventoryBalance_MAX_PROFIT/;
*NoShip/;

MODEL MAX_PROFIT_NOSHIP /
numberOfBatches,
Allocation,
UnitCapacityMax,
UnitCapacityMin,
InventoryBalance_MAX_PROFIT,
EndingInventory_MAX_PROFIT,
BacklogBalance,
EndingBacklog,
LiftingW,
LiftingB,
Carryover_W,
Carryover_B,
objective_MAX_PROFIT
*objective_MAX_PROFIT_Greedy
Ship_constraint
NoShip/;

MODEL MAX_PROFIT_GREEDY_NOSHIP /
numberOfBatches,
Allocation,
UnitCapacityMax,
UnitCapacityMin,
InventoryBalance_MAX_PROFIT,
EndingInventory_MAX_PROFIT,
BacklogBalance,
EndingBacklog,
LiftingW,
LiftingB,
Carryover_W,
Carryover_B,
*objective_MAX_PROFIT
objective_MAX_PROFIT_Greedy
Ship_constraint
NoShip/;

*SHIPMENT/;


T.l(i,j,hbar)=0;
*Parameters for Gantt Charting in Excel
*END OF MODEL FILE

