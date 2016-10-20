$SETGLOBAL NetworkNumber          N2
$SETGLOBAL MH                     12
SCALAR re_freq                    /1/;
PARAMETER demand_cycletime        /3/;
PARAMETER demand_variation        /1/;
PARAMETER demand_magnitude        /3.00/;
PARAMETER lambda_Demand           /0.00/;
SCALAR surprise                   /0.00/;
SCALAR optcr_value                /0/;
PARAMETER SEED_VALUE              /1716/;
$SETGLOBAL N_runs                 1
$EVALGLOBAL H                     24+192
$SETGLOBAL Results_FileName       Z_GreedyNoShipN2_MH12_RF1_OPT1_DF3_DV1_DL3_DU1_S1_MC1_Profit
$SETGLOBAL OPTIMIZATION_DIRECTION  maximizing
$SETGLOBAL MODEL_NAME              MAX_PROFIT_GREEDY_NOSHIP
$SETGLOBAL InitialInventoryBufferHours    6
$SETGLOBAL Transient_H            0
$SETGLOBAL Closed_Loop_Upper       168
$SETGLOBAL Backlog_flag 0
$INCLUDE ConfigurationFile.gms
