FILE FileName99998 /Z_N3_MH12_RF0_DF6_DV1_DL6_DU1_S0_OPT0_MC1.gms/
PUT FileName99998;
PUT '$SETGLOBAL NetworkNumber          3'/;
PUT '$SETGLOBAL MH                     12'/;
PUT 'SCALAR re_freq                    /1/;'/;
PUT 'PARAMETER demand_cycletime        /6/;'/;
PUT 'PARAMETER demand_variation        /1/;'/;
PUT 'PARAMETER demand_magnitude        /6/;'/;
PUT 'PARAMETER lambda_Demand           /0/;'/;
PUT 'SCALAR surprise                   /0/; '/;
PUT 'SCALAR optcr_value                /0.1/;'/;
PUT 'PARAMETER SEED_VALUE              /1716/;'/;
PUT '$SETGLOBAL N_runs                 1'/;
PUT '$EvalGlobal H                     48+192'/;
PUT '$setglobal Results_FileName       Z_N3_MH12_RF0_DF6_DV1_DL6_DU1_S0_OPT0_MC1'/;
PUT '$include ConfigurationFile.gms'/;