function Compare_ClosedLoopObjective()

%Objectives now also have W (start) penalties, so account for that

% results_folder = 'C:\Users\dhruv\Desktop\GDX_Output\January_OPT_N2_V1';
% results_folder ='C:\Users\dhruv\Desktop\GDX_Output\Code_GAMS_January_OPT_N2_Ship_END_No_W_Cost\GDXFiles';
% results_folder = [results_folder,'\'];
% filename1_raw='Z_N2_MH12_RF6_OPT1_DF3_DV1_DL3_DU1_S1_MC3_Profit';
% filename2_raw='Z_N2_MH12_RF6_OPT3_DF3_DV1_DL3_DU1_S1_MC3_Profit';
% results_folder = 'C:\Users\dhruv\Desktop\GDX_Output\GAMS_Code_Paper1_CTM_NoShip_Material_M4_FirstHalf';
% results_folder = 'C:\Users\dhruv\Desktop\GDX_Output\OPT_Study\GAMS_Code_Paper1_OPTStudy_Jan25_Flat_Objective';
% results_folder = 'C:\Users\dhruv\Desktop\GDX_Output\OPT_Study\GAMS_Code_Paper1_OPTStudy_Jan26_GradientObjective_NoShipM4';
% results_folder ='Z:\Code_January\GAMS_Code_Paper1_StudyJan22_CTM_Email_SmallCases';
% results_folder ='C:\Users\dhruv\Desktop\GDX_Output\GAMS_Code_Paper1_StudyJan22_CTM_Email_Inventory_Constraint';
% results_folder = 'C:\Users\dhruv\Desktop\GDX_Output\contrast_factor1_optcr_study\Incorrect_Files';

% results_folder = 'C:\Users\dhruv\Box Sync\Work\Codes_OnlineMethods\GAMS_Code_Paper1';
% results_folder = [results_folder,'\'];
% filename1_raw='Z_N1_MH12_RF1_OPT1_DF3_DV1_DL3_DU1_S1_MC1_Profit';
% filename2_raw='Z_N1_MH12_RF1_OPT4_DF3_DV1_DL3_DU1_S1_MC1_Profit';

results_folder = 'C:\Users\dhruv\Box Sync\Work\Codes\GAMS_Greedy';
results_folder = [results_folder,'\'];
filename1_raw='Z_GreedyN2_MH12_RF1_OPT1_DF3_DV1_DL3_DU1_S1_MC1_Profit';
filename2_raw='Z_GreedyN2_MH12_RF1_OPT4_DF3_DV1_DL3_DU1_S1_MC1_Profit';

filename1=[results_folder,filename1_raw];
filename2=[results_folder,filename2_raw];
Obj='Profit';
%Obj='Cost';

guel = @(s,v) strcat(s,strsplit(num2str(v)));
%% Import sets and parameters
set_RUN_structure.name='run';
set_RUN_structure.form='full';
set_RUN_structure.compress='true';
set_RUN=rgdx(filename1,set_RUN_structure);

set_S_structure.name='s';
set_S_structure.form='full';
set_S_structure.compress='true';
set_S=rgdx(filename1,set_S_structure);
card_s=length(set_S.uels{1});

set_product_states_structure.name='product_states';
set_product_states_structure.form='full';
% set_product_states_structure.compress='true';
set_product_states_structure.uels=set_S.uels{1};
product_S=rgdx(filename1,set_product_states_structure);
% disp('product_S')
% disp(product_S)
% disp(product_S.uels)
% disp(product_S.val)
product_s_indices = find(product_S.val)';

set_T_structure.name='h';
set_T_structure.form='full';
set_T_structure.compress='true';
set_T=rgdx(filename1,set_T_structure);

set_CALC_structure.name='calc';
set_CALC_structure.form='full';
set_CALC_structure.compress='true';
set_CALC=rgdx(filename1,set_CALC_structure);
card_Calc=length(set_CALC.uels{1});

% record_objective_structure.name='record_objective';
% record_objective_structure.form='full';
% record_objective_structure.uels={set_RUN.uels{1},set_CALC.uels{1}};
% record_objective1=rgdx(filename1,record_objective_structure);
% record_objective2=rgdx(filename2,record_objective_structure);


ClosedLoopINV_structure.name='ClosedLoopINV';
ClosedLoopINV_structure.form='full';
ClosedLoopINV_structure.uels={set_RUN.uels{1},set_S.uels{1},set_T.uels{1}};

ClosedLoopBO_structure.name='ClosedLoopBO';
ClosedLoopBO_structure.form='full';
ClosedLoopBO_structure.uels={set_RUN.uels{1},set_S.uels{1},set_T.uels{1}};

ClosedLoopINV_structure.name='ClosedLoopINV';
ClosedLoopINV_structure.form='full';
ClosedLoopINV_structure.uels={set_RUN.uels{1},set_S.uels{1},set_T.uels{1}};

ClosedLoopShip_structure.name='ClosedLoopShip';
ClosedLoopShip_structure.form='full';
ClosedLoopShip_structure.uels={set_RUN.uels{1},set_S.uels{1},set_T.uels{1}};

ClosedLoopShip_sales_structure.name='ClosedLoopShip_sales';
ClosedLoopShip_sales_structure.form='full';
ClosedLoopShip_sales_structure.uels={set_RUN.uels{1},set_S.uels{1},set_T.uels{1}};

ClosedLoopStart_structure.name='ClosedLoopStart';
ClosedLoopStart_structure.form='full';
ClosedLoopStart_structure.uels={set_RUN.uels{1},set_T.uels{1}};

Cst_new_structure.name='Cst_new';
Cst_new_structure.form='full';
Cst_new_structure.uels={set_S.uels{1}};
Cst_new=rgdx(filename1,Cst_new_structure);

Demands_structure.name='record_Demands_realization';
Demands_structure.form='full';
Demands_structure.uels={set_RUN.uels{1},set_S.uels{1},set_T.uels{1}};
Demands_1=rgdx(filename1,Demands_structure);
Demands_2=rgdx(filename2,Demands_structure);
% Demands_1.uels
% Demands_1.val
card_Demand=length(Demands_1.uels{3});


ClosedLoopINV_1=rgdx(filename1,ClosedLoopINV_structure);
ClosedLoopBO_1=rgdx(filename1,ClosedLoopBO_structure);
ClosedLoopINV_2=rgdx(filename2,ClosedLoopINV_structure);
ClosedLoopBO_2=rgdx(filename2,ClosedLoopBO_structure);
ClosedLoopShip1=rgdx(filename1,ClosedLoopShip_structure);
ClosedLoopShip2=rgdx(filename2,ClosedLoopShip_structure);
ClosedLoopShip_sales1=rgdx(filename1,ClosedLoopShip_sales_structure);
ClosedLoopShip_sales2=rgdx(filename2,ClosedLoopShip_sales_structure);


ClosedLoopStart_1=rgdx(filename1,ClosedLoopStart_structure);
ClosedLoopStart_2=rgdx(filename2,ClosedLoopStart_structure);

ClosedLoopObjective_1=zeros(card_Calc,1);
ClosedLoopObjective_2=zeros(card_Calc,1);

for t=1:card_Calc
    if strcmp(Obj,'Cost')
        for s=1:card_s
            ClosedLoopObjective_1(t)=ClosedLoopObjective_1(t)+Cst_new.val(s)*...
                (1E1*ClosedLoopINV_1.val(1,s,t)+1E2*ClosedLoopBO_1.val(1,s,t));
            ClosedLoopObjective_2(t)=ClosedLoopObjective_2(t)+Cst_new.val(s)*...
                (1E1*ClosedLoopINV_2.val(1,s,t)+1E2*ClosedLoopBO_2.val(1,s,t));
        end
        ClosedLoopObjective_1(t)=ClosedLoopObjective_1(t)+ClosedLoopStart_1.val(1,t);
        ClosedLoopObjective_2(t)=ClosedLoopObjective_2(t)+ClosedLoopStart_2.val(1,t);
    elseif strcmp(Obj,'Profit')
        if (t~=card_Calc) %skip last point for profit to match with GAMS code
            for s = product_s_indices
                ClosedLoopObjective_1(t)=ClosedLoopObjective_1(t)+Cst_new.val(s)*...
                    (ClosedLoopShip1.val(1,s,t)+ClosedLoopShip_sales1.val(1,s,t)-1E2*ClosedLoopBO_1.val(1,s,t));
                ClosedLoopObjective_2(t)=ClosedLoopObjective_2(t)+Cst_new.val(s)*...
                    (ClosedLoopShip2.val(1,s,t)+ClosedLoopShip_sales2.val(1,s,t)-1E2*ClosedLoopBO_2.val(1,s,t));
            end
            ClosedLoopObjective_1(t)=ClosedLoopObjective_1(t)-ClosedLoopStart_1.val(1,t);
            ClosedLoopObjective_2(t)=ClosedLoopObjective_2(t)-ClosedLoopStart_2.val(1,t);
        end
    end
end
%End inventory correction for profit case
if strcmp(Obj,'Profit')
    for s = product_s_indices
        ClosedLoopObjective_1(card_Calc)=ClosedLoopObjective_1(card_Calc)+...
        Cst_new.val(s)*(ClosedLoopINV_1.val(1,s,card_Calc)-1E2*ClosedLoopBO_1.val(1,s,card_Calc));
        ClosedLoopObjective_2(card_Calc)=ClosedLoopObjective_2(card_Calc)...
            +Cst_new.val(s)*(ClosedLoopINV_2.val(1,s,card_Calc)-1E2*ClosedLoopBO_2.val(1,s,card_Calc));
    end
end
% disp(Cst_new.val)

% *Runprofit includes subtraction of BO even at last point because BO are written like inventory
% *BO at 168 means just before 168th point. Ship at 168 means at 168 not before or after.
% *Our runprofit is only for 167 points of closed loop and 168th point as correction. So we are essentially wasting the last decision
% *that is the open loop that was computed at 168.
% So cumship has one extra point at end. We do not account for shipment or cost of task started at
% 168 in calculating runprofit. We do account for inv and BO at 168 because
% they are just before 168.

Cummulative_ClosedLoopObjective_1=cumsum(ClosedLoopObjective_1);
Cummulative_ClosedLoopObjective_2=cumsum(ClosedLoopObjective_2);

CummShip_1 = cumsum(ClosedLoopShip1.val+ClosedLoopShip_sales1.val,3);
CummShip_2 = cumsum(ClosedLoopShip2.val+ClosedLoopShip_sales2.val,3);
CummDemands_1 = cumsum(Demands_1.val,3);
CummDemands_2 = cumsum(Demands_2.val,3);
% size(CummShip_1)
% CummShip_1(1,3,1:card_Calc)
% squeeze(CummShip_1(1,3,1:card_Calc))
Nu_run=1;
fine=1000;

%% Code to compare closed loop inventory
% close all
% if ishandle(10001)
%     clf(10001);
% end
% figure(10001);
% f.Units='normalized';
% f.OuterPosition=[0.2 0.2 0.75 0.75];
% plot(0:card_Calc-1,Cummulative_ClosedLoopObjective_1(1:card_Calc),'-.sr','LineWidth',1.5)
% hold on
% plot(0:card_Calc-1,Cummulative_ClosedLoopObjective_2(1:card_Calc),'-ok','LineWidth',1.5)
% title(['Comparison of closed loop ', Obj])
% ylabel(['Cummulative Sum of Closed loop ',Obj, ' ($)']);
% xlabel('Time');
% set(gca,'XLim',[0 card_Calc-1],'XTick',[0:6:card_Calc-1]);
% legend({filename1_raw,filename2_raw},'Interpreter','None')
% grid on
% box on

%% Code to plot closed loop cummulative shipments
material_of_interest=card_s;
if ishandle(10002)
    clf(10002);
end
f=figure(10002);
f.Units='normalized';
f.OuterPosition=[0.2 0.2 0.75 0.75];
% f.Units='inches';
% f.OuterPosition=[1 1 3.5 2];
hold on
box on
grid on
% plot(0:card_Calc-1,squeeze(CummShip_1(1,2,1:card_Calc)),'-.r','LineWidth',1.5)
stairs(0:card_Calc-1,squeeze(CummShip_1(1,material_of_interest,1:card_Calc)),'-m','LineWidth',1)
% plot(0:card_Calc-1,squeeze(CummShip_2(1,2,1:card_Calc)),'-.k','LineWidth',1.5)
stairs(0:card_Calc-1,squeeze(CummShip_2(1,material_of_interest,1:card_Calc)),'-k','LineWidth',1)
stairs(0:card_Calc-1,squeeze(CummDemands_1(1,material_of_interest,1:card_Calc)),'-r','LineWidth',1)

% %Add markers
% MarkInt=24;
% stairs(0:MarkInt:card_Calc-1,squeeze(CummShip_1(1,material_of_interest,1:MarkInt:card_Calc)),'sm','LineWidth',3)
% stairs(0:MarkInt:card_Calc-1,squeeze(CummShip_2(1,material_of_interest,1:MarkInt:card_Calc)),'dk','LineWidth',3)
% stairs(0:MarkInt:card_Calc-1,squeeze(CummDemands_1(1,material_of_interest,1:MarkInt:card_Calc)),'vr','LineWidth',1)
% plot(0:card_Calc-1,squeeze(CummDemands_2(1,3,1:card_Calc)),'-b','LineWidth',1.5)
% title(['Comparison of closed loop shipment of materials', Obj])
% ylabel(['Cummulative sum of material M2 (kg)'],'FontSize', 10);
fontsize=10;
% set(0,'defaultAxesFontName', 'Cambria')
xlabel('Time (hours)','FontSize', fontsize);
set(gca,'XLim',[0 card_Calc-1],'XTick',[0:24:card_Calc-1],'FontSize', fontsize,'XMinorTick','on','YMinorTick','on');
% legend({['M1 ',filename1_raw],['M2 ',filename1_raw],['M1 ',filename2_raw],['M2 ',filename2_raw]},'Interpreter','None')

% legend({['M',num2str(material_of_interest),' ', filename1_raw],...
%     ['M',num2str(material_of_interest),' ', filename2_raw],...
%     ['M',num2str(material_of_interest),' minimum demand']},...
%     'Interpreter','None','Location','NorthWest','FontSize', 12)
% legend({['M3 OPTCR 0% '],...
%     ['M3 OPTCR 5%'],...
%     ['M3 minimum demand']},...
%     'Interpreter','None','Location','NorthWest','FontSize', fontsize)
legend({['OPTCR 0% '],...
    ['OPTCR 5%'],...
    ['Minimum demand']},...
    'Interpreter','None','Position',[0.35 0.74 0.1 0.1],'FontSize', 7.5,'Box','on')
% ylabel(['Cummulative shipment of M3 (tons)'],'FontSize', fontsize);
ylabel({'Cummulative shipment of','M3 (tons)'},'FontSize', fontsize);
title([''])


% CummShip_1(1,3,card_Calc)
% CummShip_1(1,4,card_Calc)
% CummShip_2(1,3,card_Calc)
% CummShip_2(1,4,card_Calc)
% CummShip_1(1,3,card_Calc)+CummShip_1(1,4,card_Calc)
% CummShip_2(1,3,card_Calc)+CummShip_2(1,4,card_Calc)
%
% CummDemands_1(1,3,card_Calc)
% CummDemands_1(1,4,card_Calc)
% CummDemands_2(1,3,card_Calc)
% CummDemands_2(1,4,card_Calc)

% w=8.5;h=6;p=0.01;
w=3.5;h=2;p=0.01;
set(gcf,...
    'Units','inches',...
    'Position',[1 1 w h],...
    'PaperUnits','inches',...
    'PaperPosition',[p*w p*h w h],...
    'PaperSize',[w*(1+2*p) h*(1+2*p)]);
print([pwd,'\PLOTS\','paradox_ComparsionOPTCR'],'-dpdf')
print([pwd,'\PLOTS\','paradox_ComparsionOPTCR'],'-dpng')

% %% Code to plot closed loop cummulative shipments
% material_of_interest=card_s-1;
% if ishandle(10003)
%     clf(10003);
% end
% figure(10003)
% f.Units='normalized';
% f.OuterPosition=[0.2 0.2 0.75 0.75];
% hold on
% box on
% grid on
% stairs(0:card_Calc-1,squeeze(CummShip_1(1,material_of_interest,1:card_Calc)),'-m','LineWidth',3)
% stairs(0:card_Calc-1,squeeze(CummShip_2(1,material_of_interest,1:card_Calc)),'-k','LineWidth',3)
% stairs(0:card_Calc-1,squeeze(CummDemands_1(1,material_of_interest,1:card_Calc)),'-r','LineWidth',1)
% title(['Comparison of closed loop shipment of materials', Obj])
% ylabel(['Cummulative sum of material M1 (kg)'],'FontSize', 18);
% xlabel('Time (hours)','FontSize', 18);
% set(gca,'XLim',[0 card_Calc-1],'XTick',[0:24:card_Calc-1],'FontSize', 18,'XMinorTick','on','YMinorTick','on');
% % legend({['M1 ',filename1_raw],['M2 ',filename1_raw],['M1 ',filename2_raw],['M2 ',filename2_raw]},'Interpreter','None')
% legend({['M',num2str(material_of_interest),' ', filename1_raw],...
%     ['M',num2str(material_of_interest),' ', filename2_raw],...
%     ['M',num2str(material_of_interest),' minimum demand']},...
%     'Interpreter','None','Location','NorthWest','FontSize', 12)
% 
% w=8.5;h=6;p=0.01;
% set(gcf,...
%     'Units','inches',...
%     'Position',[1 1 w h],...
%     'PaperUnits','inches',...
%     'PaperPosition',[p*w p*h w h],...
%     'PaperSize',[w*(1+2*p) h*(1+2*p)]);
% print([pwd,'\PLOTS\','paradox_ComparsionOPTCR_M1'],'-dpdf')