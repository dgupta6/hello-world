$SETGLOBAL NetworkNumber          N3
$SETGLOBAL MH                     8
SCALAR re_freq                    /1/;
PARAMETER demand_cycletime        /3/;
PARAMETER demand_variation        /0/;
PARAMETER demand_magnitude        /2.5/;
PARAMETER lambda_Demand           /0.00/;
SCALAR surprise                   /0.00/;
SCALAR optcr_value                /0/;
PARAMETER SEED_VALUE              /1716/;
$SETGLOBAL N_runs                 1
$EVALGLOBAL H                     24+192
$SETGLOBAL Results_FileName       Z_N3_MH12_RF1_OPT1_DF4_DV1_DL5_DU1_S1_MC1_Profit
$SETGLOBAL OPTIMIZATION_DIRECTION  MAXIMIZING
$SETGLOBAL MODEL_NAME              MAX_PROFIT_2
$SETGLOBAL InitialInventoryBufferHours    6
$SETGLOBAL Transient_H            0
$SETGLOBAL Closed_Loop_Upper      8
$SETGLOBAL Backlog_flag 0
$SETGLOBAL Gantt_OL_Number       1
$INCLUDE ConfigurationFile.gms
