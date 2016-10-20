%Create Gantt Charts
function gantt_draw(filename)
global padding height slider_val window scaling  Gantt_Flag
run=1;
N_Calc_start=slider_val+1;
window=24;
N_Calc_end=N_Calc_start+window;
guel = @(s,v) strcat(s,strsplit(num2str(v)));

set_I_structure.name='i';
set_I_structure.compress='true';
set_I=rgdx(filename,set_I_structure);
set_I.uels{1};
card_I=length(set_I.uels{1});

set_J_structure.name='j';
set_J_structure.form='full';
set_J_structure.compress='true';
set_J=rgdx(filename,set_J_structure);
set_J.uels{1};
N_Units=length(set_J.uels{1});

set_T_structure.name='h';
set_T_structure.form='full';
set_T_structure.compress='true';
set_T=rgdx(filename,set_T_structure);
set_T.uels{1};
card_T=length(set_T.uels{1});

set_n_structure.name='n';
set_n_structure.form='full';
set_n_structure.compress='true';
set_n=rgdx(filename,set_n_structure);
set_n.uels{1};
card_n=length(set_n.uels{1});

set_S_structure.name='s';
set_S_structure.form='full';
set_S_structure.compress='true';
set_S=rgdx(filename,set_S_structure);

pi_new_structure.name='pi_new';
pi_new_structure.compress='true';
pi_new=rgdx(filename,pi_new_structure);

set_CALC_structure.name='calc';
set_CALC_structure.form='full';
set_CALC_structure.compress='true';
set_CALC=rgdx(filename,set_CALC_structure);
set_CALC.uels{1};
card_CALC=length(set_CALC.uels{1});
% n_calc=card_CALC;

% display(n_calc)

set_RUN_structure.name='run';
set_RUN_structure.form='full';
set_RUN_structure.compress='true';
set_RUN=rgdx(filename,set_RUN_structure);
set_RUN.uels{1};

runcost_structure.name='runcost_Inv';
runcost_structure.form='full';
runcost_structure.uels =set_RUN.uels;
runccost=rgdx(filename,runcost_structure);

RecordStates_structure.name='record_states';
RecordStates_structure.form='full';
RecordStates_structure.compress='false';
RecordStates_structure.uels={ guel('run',1),guel('calc',0:card_CALC-1),{'W','B'},...
    set_I.uels{1},set_J.uels{1},set_n.uels{1},guel('h',0:max(pi_new.val(:,2))) };
RecordStates=rgdx(filename,RecordStates_structure);

Demands_structure.name='record_Demands_realization';
Demands_structure.compress='true';
Demands=rgdx(filename,Demands_structure);
card_Demand=length(Demands.uels{3});
demand_positions=zeros(card_T,1);
for l=1:card_Demand
    temp=char(Demands.uels{3}(l));
    demand_positions(str2num(temp(2:end)))=1;
end


set(gcf,'color','w');
n=Task_class; %create object
scaling=30;
padding=1.5;
height=0.05;

if Gantt_Flag == 1
    display(['Drawing Closed Loop Gantt Chart starting at time t = ',num2str(slider_val)])
elseif Gantt_Flag == 2
    display(['Drawing Open Loop Gantt Chart at time t = ',num2str(slider_val)])
end

for calc=N_Calc_start:N_Calc_end
    annotation('textbox','LineStyle','none','position',[(0.75+padding+calc-(N_Calc_start-1))/scaling 1-height 1/scaling height],...
        'String',num2str(calc-1),...
        'HorizontalAlignment','left','VerticalAlignment','middle')
    %        annotation('line',ones(2,1)*(1+padding+calc-(N_Calc_start-1))/scaling,[1;1-(N_Units+1)*height],'LineStyle',':')
    annotation('line',ones(2,1)*(1+padding+calc-(N_Calc_start-1))/scaling,[1;0.1],'LineStyle',':')
    %Add demand arrows
    if(demand_positions(calc)==1)
        annotation('arrow',ones(2,1)*(1+padding+calc+1-(N_Calc_start-1))/scaling,[1;1-(N_Units+2)*height],'LineStyle',':')
    end
    drawnow
    for j=1:N_Units %units
        n.unit_N=1-(j+1)*height;
        
        if (calc==N_Calc_start)
            %Unit names
            annotation('textbox','LineStyle','none','position',[0.01 n.unit_N height*3 height],...
                'String',[char(set_J.uels{1}(j))],...
                'HorizontalAlignment','center','VerticalAlignment','middle')
            %Moving horizon rectangle marker at top of figure
            MH_length = (card_n-1)/scaling;
            if (MH_length >= 1)
                MH_length = 1
                disp('Dont worry: just that the black MH bar on gantt chart is longer than the gantt 24 hours')
            end
            annotation('rectangle',[(padding+2)/scaling 0.99 MH_length height/10],'FaceColor',[0 0 0]);
        end
        
        for i=1:card_I %tasks
            
            if i==1
                n.color=[1 1 1];
            elseif i==2
                n.color='green';
            elseif i==3
                n.color='red';
            else
                n.color=[1 1 1];
            end
%             n.color=[1 1 1];
            if (calc > card_CALC)
                disp('Exceeded calc in gantt_draw.m')
                break
            end
            
            % RecordStates(run,calc,W,task,unit,time,liftingTime)
            StartFlags=RecordStates.val(run,calc,1,i,j,:,1); %W,h0 %OpenLoop start flags
            BatchSizes=RecordStates.val(run,calc,2,i,j,:,1); %B,h0
            
            %Get EndFlags
            %             EndFlags=zeros((length(StartFlags)+pi_new.val(i,2)),1);
            %             EndFlags([find(StartFlags)+pi_new.val(i,2)],1)=1; %Based on W,h%pi_new%
            
            %open loop active task i in horizon on unit j
            ActiveTasks=find(StartFlags); %Find which indices have task i planned to run
            ActiveTasksSize=BatchSizes(ActiveTasks); %Find size of task i running
            
            if Gantt_Flag ==1 %Closed Loop
                %New tasks that started in that calc
                if length(ActiveTasks)>0 %There are sometasks that started in open loop
                    if (ActiveTasks(1)==1) %only plot closed loop implemented task i on unit j for that calc
                        n.start=ActiveTasks(1)+padding+calc-(N_Calc_start-1); %we have all start times here for the task
                        n.batchsize=ActiveTasksSize(1);
                        n.duration=pi_new.val(i,2); %2 because pi_new has numerical indices in first column
                        n.task=set_I.uels{1}(i);
                        n.unit=set_J.uels{1}(j);
                        
                        %scale the start time and duration
                        n.start=n.start/scaling;
                        n.duration=n.duration/scaling;
                        n.height=height;
                        
                        n.draw;
                        %                     drawnow;
                    end
                end
            elseif Gantt_Flag == 2 %Open Loop
                if calc==N_Calc_start
                    for start_task_index=1:length(ActiveTasks) %There are sometasks that started in open loop
                        n.start=ActiveTasks(start_task_index)+padding+calc-(N_Calc_start-1); %we have all start times here for the task
                        n.batchsize=ActiveTasksSize(start_task_index);
                        n.duration=pi_new.val(i,2); %2 because pi_new has numerical indices in first column
                        n.task=set_I.uels{1}(i);
                        n.unit=set_J.uels{1}(j);
                        
                        %scale the start time and duration
                        n.start=n.start/scaling;
                        n.duration=n.duration/scaling;
                        n.height=height;
                        
                        n.draw;
                    end
                end
            end
            %Already running task in the first calc of gantt chart (for carryover continuity at start of gantt chart)
            if calc==N_Calc_start
                for running=1:pi_new.val(i,2)-1
                    RunningFlag=RecordStates.val(run,calc,1,i,j,1,1+running); %W,h%running% at t=0 for that calc
                    RunningBatchSize=RecordStates.val(run,calc,2,i,j,1,1+running); %B,h%running% at t=0 for that calc
                    if(RunningFlag == 1)
                        n.start=1+padding+calc-(N_Calc_start-1); %we have all start times here for the task
                        n.batchsize=RunningBatchSize;
                        n.duration=pi_new.val(i,2)-running; %2 because pi_new has numerical indices in first column
                        n.task=['~',char(set_I.uels{1}(i))];
                        n.unit=set_J.uels{1}(j);
                        %scale the start time and duration
                        n.start=n.start/scaling;
                        n.duration=n.duration/scaling;
                        n.height=height;
                        n.draw;
                        %                         drawnow;
                        break %break the running for loop
                    end
                end
            end
        end
    end
end
Inventory(filename);

%             %New tasks that started in that calc
%             if length(ActiveTasks)>0 %There are sometasks that started in open loop
%                 if (ActiveTasks(1)==1) %only plot closed loop implemented task i on unit j for that calc
%                     n.start=ActiveTasks(1)+padding+calc-(N_Calc_start-1); %we have all start times here for the task
%                     n.batchsize=ActiveTasksSize(1);
%                     n.duration=pi_new.val(i,2); %2 because pi_new has numerical indices in first column
%                     n.task=set_I.uels{1}(i);
%                     n.unit=set_J.uels{1}(j);
%
%                     %scale the start time and duration
%                     n.start=n.start/scaling;
%                     n.duration=n.duration/scaling;
%                     n.height=height;
%
%                     n.draw;
% %                     drawnow;
%                 end
%             end
