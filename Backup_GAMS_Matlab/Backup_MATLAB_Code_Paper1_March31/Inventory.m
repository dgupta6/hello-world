function Inventory(filename)
global padding height slider_val window scaling Gantt_Flag


guel = @(s,v) strcat(s,strsplit(num2str(v)));
%% Import sets and parameters
set_S_structure.name='s';
set_S_structure.form='full';
set_S_structure.compress='true';
set_S=rgdx(filename,set_S_structure);

product_states_structure.name='product_states';
product_states_structure.form='full';
product_states_structure.compress='false';
product_states_structure.uels=set_S.uels{1};
product_states=rgdx(filename,product_states_structure);
% set_S.uels{1};

set_T_structure.name='h';
set_T_structure.form='full';
set_T_structure.compress='true';
set_T=rgdx(filename,set_T_structure);
% set_T.uels{1};

set_n_structure.name='n';
set_n_structure.form='full';
set_n_structure.compress='true';
set_n=rgdx(filename,set_n_structure);
set_n.uels{1};
card_n=length(set_n.uels{1});

set_RUN_structure.name='run';
set_RUN_structure.form='full';
set_RUN_structure.compress='true';
set_RUN=rgdx(filename,set_RUN_structure);

set_CALC_structure.name='calc';
set_CALC_structure.form='full';
set_CALC_structure.compress='true';
set_CALC=rgdx(filename,set_CALC_structure);
set_CALC.uels{1};
card_CALC=length(set_CALC.uels{1});
n_calc=card_CALC;

ClosedLoopINV_structure.name='ClosedLoopINV';
ClosedLoopINV_structure.form='full';
ClosedLoopINV_structure.uels={set_RUN.uels{1},set_S.uels{1},set_T.uels{1}};
ClosedLoopINV=rgdx(filename,ClosedLoopINV_structure);

ClosedLoopBO_structure.name='ClosedLoopBO';
ClosedLoopBO_structure.form='full';
ClosedLoopBO_structure.uels={set_RUN.uels{1},set_S.uels{1},set_T.uels{1}};
ClosedLoopBO=rgdx(filename,ClosedLoopBO_structure);

ClosedLoopShip_structure.name='ClosedLoopShip';
ClosedLoopShip_structure.form='full';
ClosedLoopShip_structure.uels={set_RUN.uels{1},set_S.uels{1},set_T.uels{1}};
ClosedLoopShip=rgdx(filename,ClosedLoopShip_structure);

record_inventory_structure.name='record_inventory';
record_inventory_structure.form='full';
record_inventory_structure.uels={set_RUN.uels{1},set_CALC.uels{1},set_S.uels{1},set_n.uels{1}};
record_inventory=rgdx(filename,record_inventory_structure);

record_backlog_structure.name='record_backlog';
record_backlog_structure.form='full';
record_backlog_structure.uels={set_RUN.uels{1},set_CALC.uels{1},set_S.uels{1},set_n.uels{1}};
record_backlog=rgdx(filename,record_backlog_structure);

record_inventoryT_structure.name='record_inventoryTerminal';
record_inventoryT_structure.form='full';
record_inventoryT_structure.uels={set_RUN.uels{1},set_CALC.uels{1},set_S.uels{1}};
record_inventoryT=rgdx(filename,record_inventoryT_structure);

record_backlogT_structure.name='record_backlogTerminal';
record_backlogT_structure.form='full';
record_backlogT_structure.uels={set_RUN.uels{1},set_CALC.uels{1},set_S.uels{1}};
record_backlogT=rgdx(filename,record_backlogT_structure);

record_objective_structure.name='record_objective';
record_objective_structure.form='full';
record_objective_structure.uels={set_RUN.uels{1},set_CALC.uels{1}};
record_objective=rgdx(filename,record_objective_structure);

n_materials=length(set_S.uels{1});
n_time=length(set_T.uels{1});
Nu_run=1;
fine=1000;

%% Now start plotting inventory/backlogs
ax = gca;
% ax.Box='on';
% ax.OuterPosition=[0.1 0.1 0.9 0.5];
ax.Position=[(1+padding+1)/scaling 0.2 (padding+window-0.5)/scaling 0.4];


n_start=slider_val;
n_end=n_start+window;
% Legend=cell(n_materials-1+length(find(product_states.val)'),1);
Legend=cell(n_materials-1,1);
%   markers = {'+','o','*','.','x','s','d','^','v','>','<','p','h'};
%   lineStyles = {'-', '--', ':', '-.'};
%   colors = {'y', 'm', 'c', 'r', 'g', 'b', 'k'};
LineSpec = {'r-d','b-o','g-*','c-s','m-x','k-v','y-^'};
LineSpecBO = {':g+','k:o','r:*','c:s','m:x','k:v','y:^'};
hold on;
% n_start
% card_n

for s=2:n_materials
    if Gantt_Flag == 1 %Closed Loop Inventory
        stairs(n_start-1:n_end+1,squeeze(ClosedLoopINV.val(Nu_run,s,n_start+1:n_end+3)),LineSpec{s-1},'LineWidth',1.5)
    elseif Gantt_Flag ==2 %Open Loop Inventory
        stairs(n_start-1:n_start-1+card_n,[squeeze(record_inventory.val(Nu_run,n_start+1,s,1:card_n));squeeze(record_inventoryT.val(Nu_run,n_start+1,s))],LineSpec{s-1},'LineWidth',1.5)
    end
    Legend{s-1}=strcat('INV-M', num2str(s));
end

for s=find(product_states.val)'
    if Gantt_Flag == 1 %Closed Loop Inventory
        stairs(n_start-1:n_end+1,squeeze(ClosedLoopBO.val(Nu_run,s,n_start+1:n_end+3)),LineSpecBO{s-1},'LineWidth',2)
    elseif Gantt_Flag ==2 %Open Loop Inventory
        stairs(n_start-1:n_start-1+card_n,[squeeze(record_backlog.val(Nu_run,n_start+1,s,1:card_n));squeeze(record_backlogT.val(Nu_run,n_start+1,s))],LineSpecBO{s-1},'LineWidth',2)
    end
    Legend=[Legend;strcat('BO-M', num2str(s))];
end
xlabel('Time (Hours)');
ylabel('Inventory/Backlog (kg)');
set(gca,'XLim',[n_start n_end+1],'XTick',n_start:n_end+1);
grid on
legend(Legend,'Location','northwest')

%% Code for plotting Open Loop cost along with inventory
% if Gantt_Flag==2
%     %Now plot open loop objective
%     ax1 = gca; % current axes
%     ax1_pos = ax1.Position; % position of first axes
%     ax2 = axes('Position',ax1_pos,...
%         'XAxisLocation','bottom',...
%         'YAxisLocation','right',...
%         'Color','none');
%     hold on
%     plot(ax2,n_start:n_end+2,record_objective.val(n_start+1:n_end+3),':sk','LineWidth',1.5)
%     ylabel('Open loop cost ($)');
%     set(gca,'XLim',[n_start n_end+1],'XTick',[]);
%     legend('Open Loop Cost ($)')
% end

%%


% legend('Inv or BO','Demands','Shipments')
%     subplot(2,n_materials-1,s-1);
%     ClosedLoopINV.val(Nu_run,s,:);
%     title(['Inventory of Material ' num2str(s)]);
%     handle=gca;
%plot two vertical lines to demark closed loop solution area
%     plot(48*ones(fine,1)',linspace(0,handle.YLim(2),fine),'r-.','LineWidth',1)
%     plot(192*ones(fine,1)',linspace(0,handle.YLim(2),fine),'r-.','LineWidth',1)
%     set(gca,'XTick',0:n_time);
%
%     subplot(2,n_materials-1,s-1+n_materials-1);
%     stairs(0:n_time-1,squeeze(ClosedLoopBO.val(Nu_run,s,:)))
%     title(['Backlog of Material ' num2str(s)]);
%     xlabel('Time (Hours)');
%     ylabel(['BO M', num2str(s),' (kg)']);
%     hold on
%     plot(demand_times-1,squeeze(Demands.val(Nu_run,s,demand_times)),'s')
%     plot(ship_times-1,squeeze(ClosedLoopShip.val(Nu_run,s,ship_times)),'o')
%     plot(48*ones(fine,1)',linspace(0,handle.YLim(2),fine),'r-.','LineWidth',1);
%     plot(192*ones(fine,1)',linspace(0,handle.YLim(2),fine),'r-.','LineWidth',1);
