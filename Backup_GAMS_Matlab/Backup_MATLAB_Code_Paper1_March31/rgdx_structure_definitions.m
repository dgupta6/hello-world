guel = @(s,v) strcat(s,strsplit(num2str(v)));
%Closed loop runcost
runcost_structure.name='runcost';
runcost_structure.form='full';
runcost_structure.uels = {guel('run',1:n_runs)};

%Closed loop runprofit
runprofit_structure.name='runprofit';
runprofit_structure.form='full';
runprofit_structure.uels = {guel('run',1:n_runs)};

%Verifying ModelStat
modelStat_structure.name='modelStat';
modelStat_structure.form='full';
modelStat_structure.uels = {guel('calc',0:n_calc),guel('run',1:n_runs)};

%Est_modelGap1 from LP relaxation(denomination is obj.val rather than obj.est)
Est_modelGap_structure.name='Est_modelGap1';
Est_modelGap_structure.form='full';
Est_modelGap_structure.uels = {guel('calc',0:n_calc),guel('run',1:n_runs)};

%True model gap from optimal integer solution
True_modelGap_structure.name='True_modelGap';
True_modelGap_structure.form='full';
True_modelGap_structure.uels = {guel('calc',0:n_calc),guel('run',1:n_runs)};

%Integrality gap 
IntegralityGap_structure.name='IntegralityGap';
IntegralityGap_structure.form='full';
IntegralityGap_structure.uels = {guel('calc',0:n_calc),guel('run',1:n_runs)};

%Reschedule_flags
Reschedule_flag_structure.name='record_reschedule_flag';
Reschedule_flag_structure.form='full';
Reschedule_flag_structure.uels={guel('calc',0:n_calc),guel('run',1:n_runs)};

%Time resource used in solving MILP open loop
resUsd_structure.name='resUsd';
resUsd_structure.form='full';
resUsd_structure.uels = {guel('calc',0:n_calc),guel('run',1:n_runs)};

%Verifying BO_Stat_OL
BOStat_OL_structure.name='BOStat_OL';
BOStat_OL_structure.form='full';
BOStat_OL_structure.uels = {guel('calc',0:n_calc),guel('run',1:n_runs)};

%Verifying BO_Stat_CL
BOStat_CL_structure.name='BOStat_CL';
BOStat_CL_structure.form='full';
BOStat_CL_structure.uels = {guel('calc',0:n_calc),guel('run',1:n_runs)};
