$SETGLOBAL NetworkNumber          N3b
$SETGLOBAL MH                     36
SCALAR re_freq                    /6/;
PARAMETER demand_cycletime        /6/;
PARAMETER demand_variation        /1/;
PARAMETER demand_magnitude        /8.00/;
PARAMETER lambda_Demand           /0.00/;
SCALAR surprise                   /0.0000/;
SCALAR optcr_value                /0.0500/;
PARAMETER SEED_VALUE              /17158/;
$SETGLOBAL N_runs                 1
$EVALGLOBAL H                     48+192
$SETGLOBAL Results_FileName       Z_N3b_MH36_RF6_OPT5_DF6_DV1_DL8_DU1_S1_MC1_Cost
$SETGLOBAL OPTIMIZATION_DIRECTION  minimizing
$SETGLOBAL MODEL_NAME              MIN_Cost
$SETGLOBAL InitialInventoryBufferHours                 6
$SETGLOBAL Transient_H            0
$SETGLOBAL Closed_Loop_Upper       168
$SETGLOBAL Backlog_flag            1
$INCLUDE ConfigurationFile.gms
