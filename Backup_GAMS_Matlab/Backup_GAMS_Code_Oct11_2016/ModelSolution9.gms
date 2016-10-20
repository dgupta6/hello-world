OPTIONS limrow = 0, limcol = 0, solprint = off;
*OPTIONS limrow = 1000, limcol = 1000, solprint = on;
*No upper limit on inventory (equation not enforced)

loop(calc,
*Caution: Watch out W equations in case changeovers are involved with regards to lifting(pi(i)+tauC)
*fixed_decisions=re_freq-1-mod(ord(calc)-1+re_freq-1,re_freq);
*abort$1 "stopped for debugging";
*abort$(ord(calc)-1 eq 1) "stopped for debugging";

$ONTEXT
IF(ord(calc)-1 eq 4,
rhobar('T2','M3')=0.79;
rhobar('T2','M2')=0.21;
*T2.(M3 0.8,M2 0.2)
);
$OFFTEXT

*********VARIABLE RESCHEDULING FREQUENCY********
*resetting old parameter values
WbarInfo(i,j,n,hbar)=0;
BbarInfo(i,j,n,hbar)=0;

*DEMAND SAMPLING
*Picking realized demand upto surprise factor within MH from demand_sample generated for this run
        Dst_full(s,h)$(ord(h)-1 le (ord(calc)-1 + ceil(card(n)*(1-surprise))) ) = Dst_full_realization(s,h,run);
*Now allocating demands to the rolling horizon calculation
        Dst(s,n)=sum(h$((ord(h)-1) eq (ord(n)-1+ord(calc)-1)),Dst_full(s,h));
$ONTEXT
IF(ord(calc)-1 eq 5,
Dst(s,n)$(product_states(s) and ord(n)-1 eq 7 and sameas(s,'M3'))=15;
);
$OFFTEXT
$ontext
* EVENT BASED RESCHEDULING (HAS BUG: when moving horizon is shorter than rescheduling freq, more decisions
*are wrongly fixed)
if (re_freq=0,
*Reschedule flag is 1 for first optimization
        reschedule_flag=0;
*Now see if we should reschedule or not depending on whether new demand came or not
        reschedule_flag=1$(sum((s,n)$(ord(n) eq card(n)),Dst(s,n)) > 0);
*Also do find schedule for the very first optimization
        reschedule_flag$(ord(calc)-1 eq 0)=1;
*Now decide the fixed decisions (W,B) depending on rescheduling_flag
        if (reschedule_flag=1,
*Complete freedom to start new tasks (subject to old tasks not already running)
                fixed_decisions=0;
        else
*Forced to follow previous fixed (planned) decisions
                fixed_decisions=card(n)-1;
        );
else
$offtext
        fixed_decisions=re_freq-1 - mod(ord(calc)-1+(re_freq-1),re_freq);
        reschedule_flag=0;
        reschedule_flag$(fixed_decisions=0)=1;
*);
record_fixed_decision(calc)=fixed_decisions;
record_reschedule_flag(calc,run)=reschedule_flag;

*Unfix fixed variables
Ship.lo(s,n)=0;Ship.up(s,n)=Inf;
Rst.lo(s,n)=0;Rst.up(s,n)=Inf;
Ship_sales.lo(s,n)=0;Ship_sales.up(s,n)=Inf;
*Uut.lo(u,n)=0; Uut.up(u,n)=Inf;
*Fix Input states
WbarInfo(i,j,n,hbar)$(ord(n)-1 le fixed_decisions and ord(hbar)-1 le pi(i) and Ij(i,j))=record_states(run,calc-1,'W',i,j,n,hbar-1)+InitialWbar(i,j,n,hbar)$(ord(calc)-1 eq 0)+Yhat(i,j,n,hbar)-Yhat(i,j,n,hbar-1);
BbarInfo(i,j,n,hbar)$(ord(n)-1 le fixed_decisions and ord(hbar)-1 le pi(i) and Ij(i,j))=record_states(run,calc-1,'B',i,j,n,hbar-1)+InitialBbar(i,j,n,hbar)$(ord(calc)-1 eq 0)+record_states(run,calc-1,'B',i,j,n,hbar)*Yhat(i,j,n,hbar)-record_states(run,calc-1,'B',i,j,n,hbar-1)*Yhat(i,j,n,hbar-1);
Ship.fx(s,n)$(ord(n)-1 le fixed_decisions-1)=record_shipment(run,calc-1,s,n+1);
Rst.fx(s,n)$(ord(n)-1 le fixed_decisions-1)=record_Rst(run,calc-1,s,n+1);
Ship_sales.fx(s,n)$(ord(n)-1 le fixed_decisions-1)=record_shipment_sales(run,calc-1,s,n+1);
T.fx(i,j,hbar)=0;
*********VARIABLE RESCHEDULING FREQUENCY********
*(Variable rescheduling frequency does not extend to disturbances other than demand)

*Since inventory and backlog depend on the inputs, as long as we have correctly carried over the inventory we are good
Sst.fx(s,n)$(ord(n)-1 le 0)=record_inventory(run,calc-1,s,n+1)+InitialInventory(s)$(ord(calc)-1 eq 0);
Backlog.fx(s,n)$(ord(n)-1 le 0)=record_backlog(run,calc-1,s,n+1)+InitialBacklog(s)$(ord(calc)-1 eq 0);
*Uut.fx(u,n)$(ord(n)-1 le 0)=record_utility(run,calc-1,u,n+1);


*Fix backlogs to zero if corresponding flag is 0
if(%Backlog_Flag% eq 0,
Backlog.fx(s,n)=0;
BacklogTerminal.fx(s)=0;
);
*Dst(s,n)$(product_states(s) AND ord(n) eq 1) = 1;
*Ship_sales.fx(s,n)$(ord(n)-1 eq 0 AND sameas(s,'M4')) = 8.05;
*Ship_sales.fx(s,n)$(ord(n) lt card(n)) = 0;

*cc=execseed;
***************SAMPLING DISTURBANCES/UNCERTAINTIES******************************
*Introducing disturbance in demand by modifying Dst_full(s,h) only if Disturbance flag is 1(on)
*if(%Demand_Disturbance_Flag% eq 1,
*);

**UNCOMMENT HERE TO HERE  (commented for event based rescheduling)
**        Dst_full(s,h)$(ord(h)-1 le (ord(calc)-1 + ceil(card(n)*(1-surprise))) )=Dst_full_realization(s,h,run);
*Now allocating demands to the rolling horizon calculation
*        Dst(s,n)=sum(h$((ord(h)-1) eq (ord(n)-1+ord(calc)-1)),Dst_full(s,h));
**UNCOMMENT HERE TO HERE
*Display Dst_full;


*UnitBreakdown disturbance
*First breakdown unit for whole horizon and then sample after 1 time step
*when it is coming back
UnitBroken(j,n)=0;
Zhat(i,j,n,hbar)=0;
if(%UnitBreakdown_Disturbance_flag% eq 1 and ord(calc)-1 ge 2,
         Breakdown(calc,i,j,hbar)$(Ij(i,j) and ord(hbar)-1 le pi(i) and Delay(calc-1,i,j,hbar-1) eq 0)=1$(uniform(0,1) le lambda_UnitBreakdown and Duration_breakdown(calc-1,j) eq 0 and (sum(n$(ord(n)-1 eq 0),record_states(run,calc-1,'W',i,j,n,hbar-1)) gt 0));

*If there is a delay ongoing then sample this breakdown
         Breakdown(calc,i,j,hbar)$(Ij(i,j) and ord(hbar)-1 le pi(i) and Delay(calc-1,i,j,hbar) gt 0)=1$(uniform(0,1) le lambda_UnitBreakdown and Duration_breakdown(calc-1,j) eq 0 and (sum(n$(ord(n)-1 eq 0),record_states(run,calc-1,'W',i,j,n,hbar)) gt 0));

*Assume on breakdown that the unit by default is not available the whole remaining horizon and then
*resample after one time step when it is due to come back[here half of rolling horizon length]

*         Duration_breakdown(calc,j)=floor(uniform(0,card(n)/2))$(sum((hbar,i)$(Ij(i,j) and ord(hbar)-1 le pi(i)),Breakdown(calc-1,i,j,hbar)) eq 1 and Duration_breakdown(calc-1,j) eq (card(h)))
*                                         +(Duration_breakdown(calc-1,j)-1)$(Duration_breakdown(calc-1,j) gt 0 and Duration_breakdown(calc-1,j) lt card(h))
*                                         +card(h)$(sum((hbar,i)$(Ij(i,j) and ord(hbar)-1 le pi(i)),Breakdown(calc,i,j,hbar)) eq 1);
         Duration_breakdown(calc,j)=time_to_bring_unit_back_online$(sum((hbar,i)$(Ij(i,j) and ord(hbar)-1 le pi(i)),Breakdown(calc-1,i,j,hbar)) eq 1 and Duration_breakdown(calc-1,j) eq (card(h)))
                                         +(Duration_breakdown(calc-1,j)-1)$(Duration_breakdown(calc-1,j) gt 0 and Duration_breakdown(calc-1,j) lt card(h))
                                         +(card(h))$(sum((hbar,i)$(Ij(i,j) and ord(hbar)-1 le pi(i)),Breakdown(calc,i,j,hbar)) eq 1);
*display Breakdown,duration_breakdown;

         UnitBroken(j,n)=0;
         UnitBroken(j,n)$(ord(n)-1 lt Duration_breakdown(calc,j))=1;

         Zhat(i,j,n,hbar)=0;
         Zhat(i,j,n,hbar)$(ord(n)-1 eq 0 and Breakdown(calc,i,j,hbar) eq 1)=1;

);



*Disturbance associated with delay in tasks, hbar indicates the running status of the task
*Due to nature of lifting, there is already a 1 time unit lag, hence we limit hbar from 0 to pi(i)
*so that recordstates is accessed only upto pi(i)-1. Record state being pi(i) means that the task
*was already over in the last horizon
if(%TaskDelay_Disturbance_flag% eq 1,
*          Delay(calc,i,j,hbar)$(Ij(i,j) and ord(hbar)-1 le pi(i))=(Delay(calc-1,i,j,hbar)-1)$(Delay(calc-1,i,j,hbar) ge 1)
*                                                            +2$(uniform(0,1) ge 0 and (sum(n$(ord(n)-1 eq 0),record_states(calc-1,'W',i,j,n,hbar-1)) gt 0) and Delay(calc-1,i,j,hbar-1) eq 0);
          Delay(calc,i,j,hbar)$(Ij(i,j) and ord(hbar)-1 le pi(i))=(Delay(calc-1,i,j,hbar)-1)$(Delay(calc-1,i,j,hbar) ge 1);
          Delay(calc,i,j,hbar)$(Ij(i,j) and ord(hbar)-1 le pi(i) and Delay(calc-1,i,j,hbar) eq 0)=default_delay_length$(uniform(0,1) ge 0.6 and (sum(n$(ord(n)-1 eq 0),record_states(run,calc-1,'W',i,j,n,hbar-1)) gt 0 and Delay(calc-1,i,j,hbar-1) eq 0));
*          Delay(calc,i,j,hbar)$(Ij(i,j) and ord(n)-1 eq 0)=(Delay(calc-1,i,j,hbar)-1)$(Delay(calc-1,i,j,hbar) gt 0)
*          Yhat(i,j,n,hbar)$(Ij(i,j) and ord(n)-1 eq 0)=1$(uniform(0,1) gt 0 and record_states(calc-1,'W',i,j,n,hbar-1) gt 0);

*display Delay;
*Wipes out previous Yhats
          Yhat(i,j,n,hbar)=0;
*Over-rides Delays with Unit breakdown. ie if unit breakdown occurs then there cannot be a delay
          Delay(calc,i,j,hbar)=Delay(calc,i,j,hbar)$(sum(n$(ord(n)-1 eq 0),Zhat(i,j,n,hbar)+Zhat(i,j,n,hbar+1)) eq 0);
*          Yhat(i,j,n,hbar)$(Ij(i,j) and ord(n)-1 eq 0)=1$(Delay(calc,i,j,hbar) gt 0);
          Yhat(i,j,n,hbar)$(Ij(i,j) and ord(n)-1 lt Delay(calc,i,j,hbar))=1$(Delay(calc,i,j,hbar) gt 0);

*          Yhat(i,j,n,hbar)$(Ij(i,j) and ord(n)-1 eq 0 and ord(hbar)-1 le pi(i))=1$(uniform(0,1) ge 0 and record_states(calc-1,'W',i,j,n,hbar) gt 0);
*          WbarInfo(i,j,n,hbar)$Yhat(i,j,n,hbar)=1;
*          BbarInfo(i,j,n,hbar)$Yhat(i,j,n,hbar)=record_states(calc-1,'W',i,j,n,hbar);
);

*display Yhat;
*display WbarInfo;
*display BbarInfo;


*Introducing disturbance in material handling(loading/unloading)
*Here we implement only production disturbance because its more likely than consumption disturbance
*Consumption disturbance has the tricky part that if loading was 5 units, and we had just 5 units, the task is already started and we cant
*then add a disturbance on top of it saying 5.5 units was actually consumed because the task has already started.
if(%YieldLoss_Disturbance_flag% eq 1,
*the last two multiplication of (1-z(h+1))(1-z(h)) are when there are only unit breakdown, and when there is unit breakdown in middle of delay respectively
*betaHatProd(i,j,s,n)$(Tbars(i,s) and Ij(i,j) and ord(n)-1 eq 0 and product_states(s))=uniform(-0.1,0)*sum(hbar$(ord(hbar) -1 eq pis_new(i,s)-1),record_states(calc-1,'B',i,j,n,hbar)*(1-Yhat(i,j,n,hbar+1))*(1-Zhat(i,j,n,hbar+1))*(1-Zhat(i,j,n,hbar)));
*wipes out previous parameter values
betaHatProd(i,j,s,n)=0;

*betaHatProd(i,j,s,n)$(Tbars(i,s) and Ij(i,j) and ord(n)-1 eq 0)=uniform(-0.1,0)*sum(hbar$(ord(hbar) -1 eq pis_new(i,s)),BbarInfo(i,j,n,hbar)*(1-Yhat(i,j,n,hbar))*(1-Zhat(i,j,n,hbar))*(1-Zhat(i,j,n,hbar-1)));

betaHatProd(i,j,s,n)$(sameas(i,'T2') and Tbars(i,s) and Ij(i,j) and ord(n)-1 eq 0)=-0.01*sum(hbar$(ord(hbar) -1 eq pis_new(i,s)),BbarInfo(i,j,n,hbar)*(1-Yhat(i,j,n,hbar))*(1-Zhat(i,j,n,hbar))*(1-Zhat(i,j,n,hbar-1)));
*betaHatProd(i,j,s,n)$(Tbars(i,s) and Ij(i,j) and ord(n)-1 eq 0)=uniform(-0.1,0)*sum(hbar$(ord(hbar) -1 eq pis_new(i,s)-1),record_states(calc-1,'B',i,j,n,hbar)*(1-Yhat(i,j,n,hbar+1))*(1-Zhat(i,j,n,hbar)));
*betaHatProd(i,j,s,n)$(Tbars(i,s) and Ij(i,j) and ord(n)-1 eq 0)=uniform(-0.1,0)*sum(hbar$(ord(hbar) -1 eq pis_new(i,s)-1),record_states(calc-1,'B',i,j,n,hbar));
);
*Display betaHatProd;


*Correct allocation constraint
*KillDurationCountdown(i,j)$Ij(i,j)=%KillSwitch%$(sum(hbar,T.l(i,j,hbar)) gt 0);
KillOccupy(j,n)=0;
KillDuration(i,j)$Ij(i,j)=KillLength$(%KillSwitch%);
*KillDuration(i,j)$Ij(i,j)=(%KillSwitch%+1)$(sum(hbar,T.l(i,j,hbar)) gt 0 and KillDuration(i,j) eq 0);
*KillDuration(i,j)$(Ij(i,j) and KillDuration(i,j) <> 0)=KillDuration(i,j)-1;
KillCountdown(j)=sum((i,hbar)$Ij(i,j),T.l(i,j,hbar)*KillDuration(i,j))  +(KillCountdown(j)-1)$(KillCountdown(j) gt 0);
KillOccupy(j,n)$(ord(n)-1 lt KillCountdown(j)-1)=1;
if(%KillSwitch% eq 0,
   T.fx(i,j,hbar)=0;
);
*Display Breakdown,Duration_breakdown,UnitBroken,Zhat,KillOccupy;
***************SAMPLING DISTURBANCES/UNCERTAINTIES******************************

***************UTILITIES********************************************************
Uutmax(u,n)=sum(h$((ord(h)-1) eq (ord(n)-1+ord(calc)-1)),Uutmax_full(u,h));
Unitunavailable(j,n)=sum(h$((ord(h)-1) eq (ord(n)-1+ord(calc)-1)),Unitunavailable_full(j,h));
Cut(u,n)=sum(h$((ord(h)-1) eq (ord(n)-1+ord(calc)-1)),Cut_full(u,h));
*Correct Cutfull calculation, all the relation of taking hours to time points
*This correction is needed in model file
***************UTILITIES********************************************************
*Display Dst;

*abort$(sameas(calc,"calc25")) "stopped for debugging";
*Solve optimization horizon

Option IntVarUp=0;
*******************FIND OPEN LOOP SCHEDULE**************************************
%MODEL_NAME%.optcr = optcr_value$(reschedule_flag)+1$(NOT reschedule_flag);
%MODEL_NAME%.reslim = timelimit;
%MODEL_NAME%.holdFixed=1;
solve %MODEL_NAME% using MIP %OPTIMIZATION_DIRECTION% obj_variable;

modelStat(calc,run)=%MODEL_NAME%.ModelStat;
*Watch out what should be denominator, Relaxed or Best found solution
*Cplex uses division by best found integer solution
Est_modelGap1(calc,run)=abs((%MODEL_NAME%.objEst-%MODEL_NAME%.objVal)/(%MODEL_NAME%.objVal+1E-10));
Est_modelGap2(calc,run)=abs((%MODEL_NAME%.objEst-%MODEL_NAME%.objVal)/(%MODEL_NAME%.objEst+1E-10));
Suboptimal_objective=%MODEL_NAME%.objVal;

ETSolve(calc,run)=%MODEL_NAME%.etSolve;
ETSolver(calc,run)=%MODEL_NAME%.etSolver;
iterUsd(calc,run)=%MODEL_NAME%.iterUsd;
nodUsd(calc,run)=%MODEL_NAME%.nodUsd;
resUsd(calc,run)=%MODEL_NAME%.resUsd;
numDVar(calc,run)=%MODEL_NAME%.numDVar;
numEqu(calc,run)=%MODEL_NAME%.numEqu;
numInfes(calc,run)=%MODEL_NAME%.numInfes;
numNZ(calc,run)=%MODEL_NAME%.numNZ;
numVar(calc,run)=%MODEL_NAME%.numVar;
solveStat(calc,run)=%MODEL_NAME%.solveStat;

*Recording optimized variables for each optimization horizon
record_states_raw(run,calc,'B',i,j,n,hbar)$(ord(hbar)-1 le pi(i) and Ij(i,j))= Bbar.l(i,j,n,hbar);
record_states_raw(run,calc,'W',i,j,n,hbar)$(ord(hbar)-1 le pi(i) and Ij(i,j))= Wbar.l(i,j,n,hbar);
record_states(run,calc,'B',i,j,n,hbar)$(ord(hbar)-1 le pi(i) and Ij(i,j))= round(Bbar.l(i,j,n,hbar),2)$(Bbar.l(i,j,n,hbar) ge vminij(i,j)+Small_number and Bbar.l(i,j,n,hbar) le vmaxij(i,j)-Small_number) + round(Bbar.l(i,j,n,hbar))$(NOT (Bbar.l(i,j,n,hbar) ge vminij(i,j)+Small_number and Bbar.l(i,j,n,hbar) le vmaxij(i,j)-Small_number));
record_states(run,calc,'W',i,j,n,hbar)$(ord(hbar)-1 le pi(i) and Ij(i,j))= round(Wbar.l(i,j,n,hbar));
record_T(run,calc,i,j,hbar)$(ord(hbar)-1 le pi(i) and Ij(i,j))= T.l(i,j,hbar);
record_inventory(run,calc,s,n)=round(Sst.l(s,n),3);
record_backlog(run,calc,s,n)=round(Backlog.l(s,n),3);
record_inventory_raw(run,calc,s,n)=Sst.l(s,n);
record_backlog_raw(run,calc,s,n)=Backlog.l(s,n);
record_yieldloss(run,calc,i,j,s,n)=betaHatProd(i,j,s,n);
record_objective(run,calc)=obj_variable.l;
record_utility(run,calc,u,n)=Uut.l(u,n);
record_inventoryTerminal(run,calc,s)=SstTerminal.l(s);
record_backlogTerminal(run,calc,s)=BacklogTerminal.l(s);
record_shipment_raw(run,calc,s,n)=Ship.l(s,n);
record_shipment(run,calc,s,n)=round(Ship.l(s,n),2);
record_shipment_sales_raw(run,calc,s,n)=Ship_sales.l(s,n);
record_shipment_sales(run,calc,s,n)=round(Ship_sales.l(s,n),2);
record_Rst_raw(run,calc,s,n)=Rst.l(s,n);
record_Rst(run,calc,s,n)=round(Rst.l(s,n),2);
record_demands(run,calc,s,n)=Dst(s,n);
record_Demands_realization(run,s,h)=Dst_Full_Realization(s,h,run);

record_WbarInfo(run,calc,i,j,n,hbar)=WbarInfo(i,j,n,hbar);
record_BbarInfo(run,calc,i,j,n,hbar)=BbarInfo(i,j,n,hbar);

BOStat_OL(calc,run) =  1$(sum((s,n),record_backlog(run,calc,s,n)+record_backlogTerminal(run,calc,s)) > 0);
BOStat_CL(calc,run) =  1$(sum((s,n)$(ord(n)-1 eq 0),record_backlog(run,calc,s,n)) > 0);

*display ship.l;
Optimal_Objective=Suboptimal_Objective;
***********************FIND OPTIMAL OBJECTIVE IF OPTCR <>0*****************
IF(%MODEL_NAME%.optcr <> 0 AND reschedule_flag eq 1,
$ontext
put screen;
put 'Now solving optimal open loop';
putclose;
$offtext
%MODEL_NAME%.optcr=0;
solve %MODEL_NAME% using MIP %OPTIMIZATION_DIRECTION% obj_variable;
Optimal_Objective=%MODEL_NAME%.objVal;
True_modelGap(calc,run)=(Suboptimal_objective-Optimal_Objective)/(Optimal_objective+1E-10);
TimeToSolveOptimal(calc,run)=%MODEL_NAME%.resUsd;
);

***********************FIND OPTIMAL OBJECTIVE IF OPTCR <>0*****************

******WARNING: ALL VARIABLE LEVEL VALUES ARE THOSE OF OPTCR=0 NOW**********

IF (reschedule_flag eq 1,
***********************SOLVE RMIP TO GET INTEGRALITY GAP*****************
solve %MODEL_NAME% using RMIP %OPTIMIZATION_DIRECTION% obj_variable;
record_relaxed_objective(run,calc)=obj_variable.l;
IntegralityGap(calc,run)=record_relaxed_objective(run,calc)/(Optimal_Objective+1E-10);
record_relaxed_states(run,calc,'B',i,j,n,hbar)$(ord(hbar)-1 le pi(i) and Ij(i,j))= Bbar.l(i,j,n,hbar);
record_relaxed_states(run,calc,'W',i,j,n,hbar)$(ord(hbar)-1 le pi(i) and Ij(i,j))= Wbar.l(i,j,n,hbar);
record_relaxed_shipment(run,calc,s,n)=Ship.l(s,n);
record_relaxed_shipment_sales(run,calc,s,n)=Ship_sales.l(s,n);
record_relaxed_backlog(run,calc,s,n)=Backlog.l(s,n);
);
***********************SOLVE RMIP TO GET INTEGRALITY GAP*****************

******WARNING: ALL VARIABLE LEVEL VALUES ARE THOSE OF RMIP NOW**********

);
**END OF CALC LOOP HERE

*END OF SOLUTION FILE


