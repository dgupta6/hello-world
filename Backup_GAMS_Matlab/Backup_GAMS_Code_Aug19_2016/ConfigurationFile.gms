$TITLE CONFIGURATION_FILE

*$SETGLOBAL OPTIMIZATION_DIRECTION  maximizing
*$SETGLOBAL MODEL_NAME MAX_PROFIT
*$SETGLOBAL InitialInventoryFlag 1

*$SETGLOBAL OPTIMIZATION_DIRECTION  minimizing
*$SETGLOBAL MODEL_NAME MIN_COST
*$SETGLOBAL InitialInventoryFlag 0
*******HORIZON********
*$SETGLOBAL H 192
$SETGLOBAL delta 1
*$SETGLOBAL MH 20
*SCALAR re_freq /1/;
*Used in chopping off initial transient in closed loop cost evaluation
*$SETGLOBAL Transient_H 48
*$SETGLOBAL Transient_H 0
*We do Closed_Loop_Upper # of calc and record closed loop solution only till there
*$SETGLOBAL Closed_Loop_Upper 168
*$SETGLOBAL Closed_Loop_Upper 192
*******HORIZON********

*******NETWORK AND MODEL********
*$SETGLOBAL NetworkNumber 1
$SETGLOBAL ModelNumber 9
$SETGLOBAL Robust 0
*******NETWORK AND MODEL********

*******DEMAND LOAD********
*PARAMETER demand_cycletime /12/;
*PARAMETER demand_variation /3/;
*PARAMETER demand_magnitude NOMINAL LOAD /25/;
*******DEMAND LOAD********

******DISTURBANCES********************
*$SETGLOBAL Demand_Disturbance_flag 0
$SETGLOBAL TaskDelay_Disturbance_flag 0
$SETGLOBAL UnitBreakdown_Disturbance_flag 0
$SETGLOBAL YieldLoss_Disturbance_flag 0
*Parameters for demand uncertainty
*What fraction ahead of rolling Horizon does demand forecast changes'
*SCALAR surprise /0.34/;
*Magnitude of Uncertainties
*PARAMETER lambda_Demand /0.2/;
*Yet to replace these names in ModelSolution9 file
*and these values are hardcoded right now (look into code again)
PARAMETER lambda_TaskDelay /0.2/;
PARAMETER default_delay_length /1/;
PARAMETER lambda_UnitBreakdown /0.2/;
PARAMETER time_to_bring_unit_back_online /2/;
PARAMETER lambda_Handling /0.2/;
******DISTURBANCES********************

*******OPTIMIZATION OPTIONS****
*SCALAR   optcr_value /0/;
SCALAR   timelimit /600/;
*******OPTIMIZATION OPTIONS****

*******EVALUATION********
*$SETGLOBAL N_runs 1
*******EVALUATION********

*******REPORTING********
$SETGLOBAL GanttChart 0
$SETGLOBAL GanttChart_OPENLOOP 0
*$SETGLOBAL Results_FileName Config_Results
*******REPORTING********

*Run the closed loop and generate results
$Include MasterFile.gms







