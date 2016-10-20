$SETGLOBAL NetworkNumber          N3b
$SETGLOBAL MH                     18
SCALAR re_freq                    /3/;
PARAMETER demand_cycletime        /6/;
PARAMETER demand_variation        /1/;
PARAMETER demand_magnitude        /6.00/;
PARAMETER lambda_Demand           /0.00/;
SCALAR surprise                   /0.0000/;
SCALAR optcr_value                /0.000/;
PARAMETER SEED_VALUE              /17158/;
$SETGLOBAL N_runs                 1
$EVALGLOBAL H                     48+192
$SETGLOBAL Results_FileName       Z_N3b_MH18_RF3_OPT1_DF6_DV1_DL6_DU1_S1_MC1_Cost
$SETGLOBAL OPTIMIZATION_DIRECTION  minimizing
$SETGLOBAL MODEL_NAME              MIN_Cost
$SETGLOBAL InitialInventoryBufferHours                 6
$SETGLOBAL Transient_H            0
$SETGLOBAL Closed_Loop_Upper       168
$SETGLOBAL Backlog_flag            1
$INCLUDE ConfigurationFile.gms
