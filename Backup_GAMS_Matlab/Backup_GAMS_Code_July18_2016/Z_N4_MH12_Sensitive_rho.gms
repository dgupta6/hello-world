$SETGLOBAL NetworkNumber          N4
$SETGLOBAL MH                     16
SCALAR re_freq                    /1/;
PARAMETER demand_cycletime        /7/;
PARAMETER demand_variation        /0/;
PARAMETER demand_magnitude        /8/;
PARAMETER lambda_Demand           /0.00/;
SCALAR surprise                   /0.00/;
SCALAR optcr_value                /0/;
PARAMETER SEED_VALUE              /1716/;
$SETGLOBAL N_runs                 1
$EVALGLOBAL H                     24+192
$SETGLOBAL Results_FileName       Z_N4_MH12_Sensitive_rho
$SETGLOBAL OPTIMIZATION_DIRECTION  MINIMIZING
$SETGLOBAL MODEL_NAME              MIN_COST
$SETGLOBAL InitialInventoryBufferHours    0
$SETGLOBAL Transient_H            0
$SETGLOBAL Closed_Loop_Upper      6
$SETGLOBAL Backlog_flag 1
$SETGLOBAL Gantt_OL_Number 4
$INCLUDE ConfigurationFile.gms