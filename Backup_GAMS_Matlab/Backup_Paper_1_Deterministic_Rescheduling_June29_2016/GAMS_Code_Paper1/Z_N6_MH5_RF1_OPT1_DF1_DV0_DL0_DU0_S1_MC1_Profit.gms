$SETGLOBAL NetworkNumber          N6
$SETGLOBAL MH                     5
SCALAR re_freq                    /1/;
PARAMETER demand_cycletime        /1/;
PARAMETER demand_variation        /0/;
PARAMETER demand_magnitude        /0/;
PARAMETER lambda_Demand           /0.00/;
SCALAR surprise                   /0.00/;
SCALAR optcr_value                /0/;
PARAMETER SEED_VALUE              /1716/;
$SETGLOBAL N_runs                 1
$EVALGLOBAL H                     66
$SETGLOBAL Results_FileName       Z_N6_MH5_RF1_OPT1_DF1_DV0_DL0_DU0_S1_MC1_Profit
$SETGLOBAL OPTIMIZATION_DIRECTION  MAXIMIZING
$SETGLOBAL MODEL_NAME              MAX_PROFIT_SellAnytime_Greedy
$SETGLOBAL InitialInventoryBufferHours    0
$SETGLOBAL Transient_H            0
$SETGLOBAL Closed_Loop_Upper      24
$SETGLOBAL Backlog_flag 0
$SETGLOBAL Gantt_OL_Number       1
$INCLUDE ConfigurationFile.gms