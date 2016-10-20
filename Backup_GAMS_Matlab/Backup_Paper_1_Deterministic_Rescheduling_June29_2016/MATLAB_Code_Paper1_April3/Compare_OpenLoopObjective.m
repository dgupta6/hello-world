function Compare_OpenLoopObjective()


%This code is likely not working, verify everything
%ALso does not include W cost (cost of startup)


results_folder='C:\Users\Dhruv\Desktop\Work\Codes_OnlineMethods\November2015\GAMS_Code_Paper1\';
filename1='Z_N3_MH12_RF0_DF6_DV1_DL6_DU1_S0_OPT0_MC1';
filename2='Z_N3_MH12_RF0_DF6_DV1_DL6_DU1_S0_OPT4_MC1';
filename1=[results_folder,filename1];
filename2=[results_folder,filename2];

guel = @(s,v) strcat(s,strsplit(num2str(v)));
%% Import sets and parameters
set_RUN_structure.name='run';
set_RUN_structure.form='full';
set_RUN_structure.compress='true';
set_RUN=rgdx(filename1,set_RUN_structure);

set_CALC_structure.name='calc';
set_CALC_structure.form='full';
set_CALC_structure.compress='true';
set_CALC=rgdx(filename1,set_CALC_structure);
set_CALC.uels{1};
card_CALC=length(set_CALC.uels{1});


record_objective_structure.name='record_objective';
record_objective_structure.form='full';
record_objective_structure.uels={set_RUN.uels{1},set_CALC.uels{1}};

record_objective1=rgdx(filename1,record_objective_structure);
record_objective2=rgdx(filename2,record_objective_structure);

% scale
% record_objective2.val=record_objective2.val/record_objective1.val(1);
% record_objective1.val=record_objective1.val/record_objective1.val(1);
% disp(record_objective2.val(1))
% record_objective2.val=record_objective2.val./record_objective1.val;

Nu_run=1;
fine=1000;

%% Code for plotting Open Loop cost along with inventory
% close all
if ishandle(2001)
    clf(2001);
end
figure(2001);
f.Units='normalized';
f.OuterPosition=[0.2 0.2 0.75 0.75];
plot(0:card_CALC-1,record_objective1.val(1:card_CALC),'-.sr','LineWidth',1.5)
hold on
plot(0:card_CALC-1,record_objective2.val(1:card_CALC),'-ok','LineWidth',1.5)
ylabel('Open loop cost ($)');
set(gca,'XLim',[0 card_CALC-1],'XTick',[0:24:card_CALC-1]);
legend('OPTCR 0','OPTCR 1')
