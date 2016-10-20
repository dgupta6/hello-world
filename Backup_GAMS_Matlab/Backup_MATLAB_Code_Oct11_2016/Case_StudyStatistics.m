results_folder = 'C:\Users\dhruv\Box Sync\Work\Codes_OnlineMethods\GAMS_Code_Paper1\Case_StudyGanttChart\Network3b';
results_folder = [results_folder,'\'];
filename1 = 'Z_N3b_MH24_RF3_OPT1_DF6_DV1_DL6_DU1_S1_MC1_Cost';
filename2 = 'Z_N3b_MH36_RF6_OPT5_DF6_DV1_DL6_DU1_S1_MC1_Cost';

RF1=3;
RF2=6;

n_runs=1;
n_calc=168;
run rgdx_structure_definitions.m

filename=filename1;
IntGapRaw = rgdx([results_folder,filename],IntegralityGap_structure);
TrueGapRaw = rgdx([results_folder,filename],True_modelGap_structure);
EstGapRaw = rgdx([results_folder,filename],Est_modelGap_structure);
resUsdRaw = rgdx([results_folder,filename],resUsd_structure);

% TrueGapRaw.val
Times1=resUsdRaw.val(1:RF1:end);

filename=filename2;
IntGapRaw = rgdx([results_folder,filename],IntegralityGap_structure);
TrueGapRaw = rgdx([results_folder,filename],True_modelGap_structure);
EstGapRaw = rgdx([results_folder,filename],Est_modelGap_structure);
resUsdRaw = rgdx([results_folder,filename],resUsd_structure);

Times2=resUsdRaw.val(1:RF2:end);

disp('Mean Comp Times')
[mean(Times1) mean(Times2)]
disp('Mean True Gap %age')
mean(TrueGapRaw.val(1:RF2:end)')*100