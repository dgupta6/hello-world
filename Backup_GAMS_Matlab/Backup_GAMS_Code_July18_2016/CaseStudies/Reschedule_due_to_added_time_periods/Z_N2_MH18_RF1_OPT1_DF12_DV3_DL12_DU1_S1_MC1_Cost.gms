$SETGLOBAL NetworkNumber          N2
$SETGLOBAL MH                     16
SCALAR re_freq                    /1/;
PARAMETER demand_cycletime        /16/;
PARAMETER demand_variation        /0/;
PARAMETER demand_magnitude        /12/;
PARAMETER lambda_Demand           /0.00/;
SCALAR surprise                   /0.00/;
SCALAR optcr_value                /0/;
PARAMETER SEED_VALUE              /1716/;
$SETGLOBAL N_runs                 1
$EVALGLOBAL H                     30
$SETGLOBAL Results_FileName       Z_N2_MH18_RF1_OPT1_DF12_DV3_DL12_DU1_S1_MC1_Cost
$SETGLOBAL OPTIMIZATION_DIRECTION  MINIMIZING
$SETGLOBAL MODEL_NAME              MIN_COST
$SETGLOBAL InitialInventoryBufferHours    0
$SETGLOBAL Transient_H            0
$SETGLOBAL Closed_Loop_Upper      24
$SETGLOBAL Backlog_flag 1
$SETGLOBAL Gantt_OL_Number       3
$INCLUDE ConfigurationFile.gms

