*Change this to name of the instance
$TITLE MasterFile
$ONEOLCOM
$ONINLINE
$OFFSYMXREF
$OFFSYMLIST
*$OFFLISTING

execseed=SEED_VALUE;
*parameter cc /0/;

$SETGLOBAL KillSwitch 0
SCALAR KillLength /2/;

SET run /run1*run%N_runs%/;

$include Network%NetworkNumber%.gms
$include Model%ModelNumber%.gms



PARAMETER runcost(run) cost of implemented closed loop
         runcost_Inv(run) Inventory cost,runcost_BO(run) Backlog cost, runcost_W(run) start_cost_of_tasks
         runprofit(run) closed loop profit in MAX_profit
         sales_profit(run);

         runcost_Inv(run)=0;runcost_BO(run)=0; runcost_W(run)=0;runcost(run)=0; runprofit(run)=0;sales_profit(run)=0;

PARAMETER modelStat(calc,run)     Should be 1 for successful optimization
          BOStat_OL(calc,run)     If 1 means open loop had non zero back order
          BOStat_CL(calc,run)     If 1 means closed loop had non zero back order
          IntegralityGap(calc,run)
          Est_modelGap1(calc,run)  Estimated optimality gap by CPLEX (obj.val in denominator)
          Est_modelGap2(calc,run)  Estimated optimality gap by CPLEX (obj.Est in denominator)
          True_modelGap(calc,run) True optimality gap obtained by solving to optcr=0
          ETSolve(calc,run)
          ETSolver(calc,run)
          iterUsd(calc,run)
          nodUsd(calc,run)
          resUsd(calc,run)
          numDVar(calc,run)
          numEqu(calc,run)
          numInfes(calc,run)
          numNZ(calc,run)
          numVar(calc,run)
          solveStat(calc,run)
          Suboptimal_objective /0/
          Optimal_Objective /0/
          TimeToSolveOptimal(calc,run);

$ontext
********************DEMAND SAMPLING TO KEEP IT STANDARDIZED FOR ALL APPROACHES(NOMINAL, ROBUST, STOCHASTIC)************************
******DEMAND INFORMATION*****************************
*Each order for all products
SET         o orders /o1*o%H%/;
PARAMETER deliveries_time(o,run);
deliveries_time(o,run)=demand_cycletime*ord(o);
PARAMETER deliveries(o,s);
deliveries(o,s)$(product_states(s))=demand_magnitude;
******DEMAND INFORMATION*****************************

PARAMETER Dst_full(s,h);
Dst_full(s,h)=sum(o,deliveries(o,s)$(ord(h)-1 eq floor(deliveries_time(o)/%delta%)));

PARAMETER Dst_full_realization(s,h,run);
Dst_full_realization(s,h,run)=Dst_full(s,h);

*IF(%Demand_Disturbance_flag% eq 1,
         LOOP(run,
            deliveries_time(o,run)=deliveries_time(o,run)+UniformInt(-demand_variation,demand_variation);
            Dst_full_realization(s,h,run)=(Dst_full(s,h)+Dst_full(s,h)*uniformInt(-lambda_Demand,lambda_Demand)  )$(Dst_full(s,h) gt 0);
         );
*);
********************DEMAND SAMPLING TO KEEP IT STANDARDIZED FOR ALL APPROACHES(NOMINAL, ROBUST, STOCHASTIC)************************
$offtext
********************DEMAND SAMPLING TO KEEP IT STANDARDIZED FOR ALL APPROACHES(NOMINAL, ROBUST, STOCHASTIC)************************
******DEMAND INFORMATION*****************************
*Each order for all products
SET         o orders /o1*o%H%/;
PARAMETER deliveries_time(o,run);
deliveries_time(o,run)=demand_cycletime*ord(o);
PARAMETER deliveries(o,s);
deliveries(o,s)$(product_states(s))=demand_magnitude;
******DEMAND INFORMATION*****************************

PARAMETER Dst_full_realization(s,h,run),Dst_full(s,h);

*IF(%Demand_Disturbance_flag% eq 1,
LOOP(run,
  deliveries_time(o,run)=deliveries_time(o,run)+UniformInt(-demand_variation,demand_variation);
  Dst_full_realization(s,h,run)=sum(o,deliveries(o,s)$(ord(h)-1 eq floor(deliveries_time(o,run)/%delta%)));
  Dst_full_realization(s,h,run)=(Dst_full_realization(s,h,run)+Dst_full_realization(s,h,run)/100*uniformInt(-lambda_Demand*100,lambda_Demand*100)  )$(Dst_full_realization(s,h,run) gt 0);
);
*Dst_full_realization(s,h,run)$(ord(h)-1 gt 10)=0;
*);
********************DEMAND SAMPLING TO KEEP IT STANDARDIZED FOR ALL APPROACHES(NOMINAL, ROBUST, STOCHASTIC)************************


PARAMETER ClosedLoopINV(run,s,h),ClosedLoopBO(run,s,h),ClosedLoopShip(run,s,h),ClosedLoopShip_sales(run,s,h),
          ClosedLoopStart(run,h),Cost_EndInventory(run),ClosedLoopExecutions(run,i);
ClosedLoopINV(run,s,h)=0;
ClosedLoopBO(run,s,h)=0;
ClosedLoopShip(run,s,h)=0;
ClosedLoopShip_sales(run,s,h)=0;
ClosedLoopStart(run,h)=0;
Cost_EndInventory(run)=0;
ClosedLoopExecutions(run,i)=0;
*This parameter switches to 1 at end of this file
*indicating a succesful run(sweep of code) throughout
PARAMETER SUCCESS /0/;


PARAMETER timeLeft /0/;
PARAMETER endingSeed /0/;
*PARAMETER sample /0/;

********************STOPPING CRITERION*************
$ontext
PARAMETER mean_runcost(run), std_dev_runcost(run), delta_std_dev_runcost(run), max_delta_std_dev_runcost(run), N_run count of runs;
mean_runcost(run)=0;
std_dev_runcost(run)=0;
delta_std_dev_runcost(run)=0;
max_delta_std_dev_runcost(run)=0;
N_run=0;
ALIAS(run,run_p);
********************STOPPING CRITERION*************
$offtext

********************[Start] Evaluations Runs ***************************************
loop(run,
$ontext
put screen;
put 'I am on run ' run.tl;
putclose;
put log;
put 'I am on run ' run.tl;
putclose;
$offtext

*We need to reset Dst_full(s,h) with each run to nominal values
*and then as MH goes forward, Dst_full slowly takes the value of Dst_full_realization
*for that particular run, after which here we need to refresh it to nominal values
Dst_full(s,h)=sum(o,deliveries(o,s)$(ord(h)-1 eq floor(deliveries_time(o,run)/%delta%)));

if(%robust% eq 1,
abort$1 "Look into robust case demand generation in MasterFile and make sure its correct";
         Dst_full(s,h)=Dst_full(s,h)*(1+ lambda_Demand);
);
*this time sample is equal to 1, so we are in evaluation mode

********CLOSED-LOOP SOLUTION*********
$INCLUDE ModelSolution9.gms

********STORING CL-SOLUTION IN RECOGNIZABLE PARAMETERS FOR EASY ACCESS AND ANALAYSIS*******
loop((n,calc)$(ord(n)-1 eq 0),
         ClosedLoopINV(run,s,h)$(ord(h) eq ord(calc))=record_inventory(run,calc,s,n);
         ClosedLoopBO(run,s,h)$(ord(h) eq ord(calc))=record_backlog(run,calc,s,n);
         ClosedLoopShip(run,s,h)$(ord(h) eq ord(calc))=record_shipment(run,calc,s,n);
         ClosedLoopShip_sales(run,s,h)$(ord(h) eq ord(calc))=record_shipment_sales(run,calc,s,n);
         ClosedLoopStart(run,h)$(ord(calc) eq ord(h))=sum((i,j,hbar)$(Ij(i,j) AND ord(hbar)-1 eq 0),record_states(run,calc,'W',i,j,n,hbar));
*         ClosedLoopStart(run,h)$(ord(calc) eq ord(h))=0;
);
         ClosedLoopExecutions(run,i)=sum((calc,j,n,hbar)$(Ij(i,j) AND ord(hbar)-1 eq 0
                                         AND ord(n)-1 eq 0 AND ord(calc)-1 le %Closed_Loop_Upper_delta%-1),
                                         record_states(run,calc,'W',i,j,n,hbar));

*         runcost_Inv(run)=1E1*sum((s,h)$closed_loop(h),Cst_new(s)*Sinv(s,h));
*         runcost_BO(run)=1E2*sum((s,h)$closed_loop(h),Cst_new(s)*BO(s,h));
         runcost_Inv(run)=1E1*sum((s,h)$closed_loop(h),Cst_new(s)*ClosedLoopINV(run,s,h));
         runcost_BO(run)=1E2*sum((s,h)$closed_loop(h),Cst_new(s)*ClosedLoopBO(run,s,h));
         runcost_W(run)=sum((h)$closed_loop(h),ClosedLoopStart(run,h));
*total profit from all shipments (demand+sales)

         runcost(run)=runcost_Inv(run)+runcost_BO(run)+runcost_W(run);

*         sales_profit(run)=sum( (s,h)$(product_states(s) and closed_loop(h) and (ord(h)-1 ne %Closed_Loop_Upper_delta%) ),
*                                 Cst_new(s)*(ClosedLoopShip(run,s,h)+ClosedLoopShip_sales(run,s,h) ));
         sales_profit(run)=sum( (s,h)$(product_states(s) and closed_loop(h) and (ord(h)-1 ne %Closed_Loop_Upper_delta%) ),
                                 Cst_new(s)*(ClosedLoopShip_sales(run,s,h) ));
*         sales_profit(run)=sum( (s,h)$(product_states(s) and closed_loop(h) and (ord(h)-1 ne %Closed_Loop_Upper_delta%) ),Cst_new(s)*ClosedLoopShip_sales(run,s,h));
         Cost_EndInventory(run)=sum((s,h)$(product_states(s) and ord(h)-1 eq %Closed_Loop_Upper_delta%),Cst_new(s)*ClosedLoopINV(run,s,h));
*         runcost_W(run)=0;
*         runprofit(run)=sum((s,h)$(product_states(s) and closed_loop(h)),Cst_new(s)*ClosedLoopShip(run,s,h))+runcost_W(run);
*Runprofit includes subtraction of BO even at last point because BO are written like inventory
*BO at 168 means just before 168th point. Ship at 168 means at 168 not before or after.
*Our runprofit is only for 167 points of closed loop and 168th point as correction. So we are essentially wasting the last decision
*that is the open loop that was computed at 168.
         runprofit(run)=sales_profit(run)+Cost_EndInventory(run)
                         -(runcost_W(run)-sum((h)$(ord(h)-1 eq %Closed_Loop_Upper_delta%),ClosedLoopStart(run,h)))
                         -runcost_BO(run);

*         runprofit(run)=runcost_Inv(run)-runcost_BO(run)
*                        +1E1*sum((s,h)$(product_states(s) and closed_loop(h)),Cst_new(s)*ClosedLoopShip(run,s,h));

*Does not include cost of Terminal BO and inventory but thats okay because they are irrelevant when some extra horizon is allowed for getting complete closed loop rolling horizon solution
************[Start]Information to get very crude estimate for running time left**************
timeLeft=%MODEL_NAME%.etSolve*(card(run)-ord(run))*card(calc);
$ontext
put screen;
put 'Time for run ' P1.etSolve;
put ' Estimated Time Left ' timeLeft;
putclose;
$offtext
*************[End]Information to get very crude estimate for running time left***************

$ontext
*************Stopping Criterion**************
N_run=ord(run);
mean_runcost(run)=sum(run_p$(ord(run_p) le N_run),runcost(run_p))/N_run;
std_dev_runcost(run)$(ord(run) gt 1)= sqrt(       sum(run_p$(ord(run_p) le N_run),     ( abs(  runcost(run_p)-mean_runcost(run) )**2)) /(N_run-1)    );
delta_std_dev_runcost(run)$(ord(run) gt 2)=std_dev_runcost(run)/std_dev_runcost(run-1)  - 1;
max_delta_std_dev_runcost(run)= sqrt( 1 + (1.96**2-1)/N_run ) -1;
*icdfnorm(0.95,0,1);
*************Stopping Criterion**************
$offtext
);
********************[End] runs loop ***************************************

*******************GANTT CHART PARAMETERS*************************************
PARAMETERS BS(i,j,h),start(i,j,h),Sinv(s,h),end(i,j,h),BO(s,h);
IF (%GanttChart_OPENLOOP% eq 0,
         loop((run,calc)$(ord(run) eq 1),
           BS(i,j,h)$(ord(h) eq ord(calc))=sum((hbar,n)$(ord(hbar)-1 eq 0 and ord(n)-1 eq 0),record_states(run,calc,'B',i,j,n,hbar));
*start(i,j,h)$(ord(h)eq ord(calc))=round(sum((hbar,n)$(ord(hbar)-1 eq 0 and ord(n)-1 eq 0),record_states(calc,'W',i,j,n,hbar)));
           start(i,j,h)$(ord(h)eq ord(calc))=sum((hbar,n)$(ord(hbar)-1 eq 0 and ord(n)-1 eq 0),record_states(run,calc,'W',i,j,n,hbar));
           Sinv(s,h)$(ord(h) eq ord(calc))=sum(n$(ord(n)-1 eq 0),record_inventory(run,calc,s,n));
           BO(s,h)$(ord(h) eq ord(calc))=sum(n$(ord(n)-1 eq 0),record_backlog(run,calc,s,n));
         );
ELSE
*Write OPEN loop static gantt chart %GanttChart_OPENLOOP% eq 1
         loop((run,calc)$(ord(run) eq 1 and ord(calc)-1 eq %Gantt_OL_Number%),
           BS(i,j,h)$(Ij(i,j))=sum((hbar,n)$(ord(hbar)-1 eq 0 and (ord(n) eq ord(h))),record_states(run,calc,'B',i,j,n,hbar));
           start(i,j,h)$(Ij(i,j))=sum((hbar,n)$(ord(hbar)-1 eq 0 and (ord(n) eq ord(h))),record_states(run,calc,'W',i,j,n,hbar));
           Sinv(s,h)=sum(n$(ord(n) eq ord(h)),record_inventory(run,calc,s,n));
           BO(s,h)=sum(n$(ord(n) eq ord(h)),record_backlog(run,calc,s,n));
         );
);
*Have ending account for task delays
end(i,j,h) = start(i,j,h-pi_new(i))$(BS(i,j,h-pi_new(i))>0);
*******************GANTT CHART PARAMETERS*************************************

*******************EXPORT ALL RESULTS IN GDX FILE*****************************
SUCCESS=1;
EXECUTE_UNLOAD '%Results_FileName%.gdx';
*******************EXPORT ALL RESULTS IN GDX FILE*****************************

*********Generate EXCEL SHEEL FOR GANTT CHARTING (Requires windows)***********
IF(%GanttChart% eq 1,
************************************************
********Closed-Loop GanttChartGeneration********
************************************************
*Name of the excel file where the data will be exported
*$setglobal file %Results_FileName%_Gantt
*i = set of tasks
*j = set of units
*h = set of time points
*BS = batch size of task i starting in unit j at time t (must be indexed ijt)
*start = binary variable that is 1 if task i starts in unit j at time t (must be indexed ijt)
*Sinv = inventory level of material s at time t (must be indexed st)
*BO= backorder of state s at time t
*end =  binary variable that is 1 if task i ends in unit j at time t (must be indexed ijt)

*EXECUTE_UNLOAD '%Results_FileName%_Gantt.gdx' BS i j h  Sinv start end;

*The first word of each line gives the type: set = set, var = variable, par = parameter. This may need to be changed depending on your model
*The location of the output or the sheet names must not be changed
$onecho > GANTT_write.txt
set = i    rng = sets!A1
set = j    rng = sets!A2
set = h    rng = sets!A3
par = BS    rng = BatchSize!A1
par = start   rng = StartTime!A1
par = Sinv rng = Inventory!A1
par = end  rng = EndTime!A1
$offecho

*display BS,start,end,Sinv,BO;
         IF (%GanttChart_OPENLOOP% eq 0,
                  EXECUTE 'gdxxrw Input=%Results_FileName%.gdx Output=%Results_FileName%_Gantt_CL @GANTT_write.txt'
         ELSE
                  EXECUTE 'gdxxrw Input=%Results_FileName%.gdx Output=%Results_FileName%_Gantt_OL_%Gantt_OL_Number% @GANTT_write.txt'
         );
);
*********Generate EXCEL SHEEL FOR GANTT CHARTING (Requires windows)***********

*END OF MASTER FILE






*Watch out for overflow of solution for rolling horizon...ie the spilling over of
*rolling horizon beyond real horizon to get last implemented closed loop solution


*$set console
*$if %system.filesys% == UNIX  $set console /dev/tty
*$if %system.filesys% == DOS $set console con
*$if %system.filesys% == MS95  $set console con
*$if %system.filesys% == MSNT  $set console con
*$if "%console%." == "." abort "filesys not recognized";
*file screen / '%console%' /;
*file log /''/

