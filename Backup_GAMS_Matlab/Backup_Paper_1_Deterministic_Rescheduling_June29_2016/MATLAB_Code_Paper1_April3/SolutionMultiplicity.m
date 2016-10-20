%Collect results from gdx files to compare closed loop quality
%Read results from filenames: "Z_N1_MH12_RF1_OPT1_DF12_DV3_DL25_DU1_S1_MC1_Profit.gdx"
clc
clear
close all
disp('Remember demand patterns are dependent on highest MH value, so dont mix Z_N1_same of MH with Z_N1_same of RF,OPT')

TitleMatrix = {'A(i)','B(i)','C(i)';
    'A(ii)','B(ii)','C(ii)';
    'A(iii)','B(iii)','C(iii)'};

N=[2];
plot_cost_profit=2;
switch plot_cost_profit
    case 1
        results_folder = 'C:\Users\dhruv\Desktop\GDX_Output\February\MH_Feb18';
        DF={3,6,12};
        DV={1,1,3};
        DL={[3 4 5];
            [6 8 10];
            [12 16 20]};
        Obj='Cost';
        MC={[1:10],[1:10],[1:10],[1:10]};
        MH = {[18:3:36],[18:3:36],[18:3:36],[18:3:36]};
        RF = {[1,3,6],[1,3,6],[1,3,6],[1,3,6]};
        OPT = {0,0,0,0};
    case 2
%         results_folder = 'C:\Users\dhruv\Desktop\GDX_Output\February\SolutionMultiplicity_Feb25\NBMax_OFF';
        results_folder = 'C:\Users\dhruv\Desktop\GDX_Output\February\SolutionMultiplicity_Feb25\NBMax_ON';
        results_folder = 'C:\Users\dhruv\Desktop\GDX_Output\February\SolutionMultiplicity_Feb25\BacklogTerminalCheck';
        
        results_folder = 'C:\Users\dhruv\Desktop\GDX_Output\March\SolutionMultiplicity_March3';
        
        results_folder = 'C:\Users\dhruv\Desktop\GDX_Output\March\Model_Study';
        results_folder = 'C:\Users\dhruv\Desktop\GDX_Output\March\Model_Study\BO_NotAllowed';
        
%         results_folder = 'C:\Users\dhruv\Desktop\GDX_Output\February\SolutionMultiplicity_Feb25\MH12';
%         results_folder = 'C:\Users\dhruv\Desktop\GDX_Output\February\SolutionMultiplicity_Feb25\MH6';
%         results_folder = 'C:\Users\dhruv\Desktop\GDX_Output\February\SolutionMultiplicity_Feb25\MH24_T3_Tau4';
%         results_folder = 'C:\Users\dhruv\Desktop\GDX_Output\February\SolutionMultiplicity_Feb25\MH24_HoldFixed0';
%         results_folder = 'C:\Users\dhruv\Desktop\GDX_Output\February\SolutionMultiplicity_Feb25\MH24_FlipTaus';
        DF={3,6,12};
%         DF={3};
        DV={1,1,3};
        DL={3,6,12};
        Obj='Profit';
        MC={[1:100],[1:100],[1:100]};
        MH = {24,24,24};
%         MH = {18,18,18};
%         MH = {12,12,12};
%         MH = {6,6,6};
%         RF = {1,1,1};
%         RF = {3,3,3};
        RF = {6,6,6};
        OPT = {0,0,0};
%         BO={0,1};
        BO={1,2};   
end
DU={1,1,1,1};S={1,1,1,1};
% fig_filename=['MH_',Obj];


results_folder = [results_folder,'\'];
n_runs = 1;
if strcmp(Obj,'Cost')
    %             n_calc=192;
    n_calc=168;
elseif strcmp(Obj,'Profit')
    n_calc=168;
end
disp('card_calc= ');disp(n_calc);
run rgdx_structure_definitions.m
axes = cell(length(DF),1); ylim_upper = -Inf; ylim_lower = +Inf;
chart = cell(length(DF),1);

n=N;

data_MC = zeros(length(BO),length(DF),length(MC{1}));
for df = 1:length(DF);
    for dl = 1:length(DL{df})
        %Define size of data for each subplot
        for bo=1:length(BO)
            
            for mc = 1:length(MC{df})
                for mh=1:length(MH{df})
                    for rf=1:length(RF{df})
                        for opt=1:length(OPT{df})
                            
%                             filename = ['Z_BO',num2str(BO{bo}),'_N',num2str(n),'_MH',num2str(MH{df}(mh)),'_RF',num2str(RF{df}(rf)),...
%                                 '_OPT',num2str(opt),'_DF',num2str(DF{df}),'_DV',num2str(DV{df}),...
%                                 '_DL',num2str(DL{df}(dl)),'_DU',num2str(DU{df}),'_S',num2str(S{df}),...
%                                 '_MC',num2str(MC{df}(mc)),'_',Obj,'.gdx'];
                            filename = ['Z_M',num2str(BO{bo}),'_N',num2str(n),'_MH',num2str(MH{df}(mh)),'_RF',num2str(RF{df}(rf)),...
                                '_OPT',num2str(opt),'_DF',num2str(DF{df}),'_DV',num2str(DV{df}),...
                                '_DL',num2str(DL{df}(dl)),'_DU',num2str(DU{df}),'_S',num2str(S{df}),...
                                '_MC',num2str(MC{df}(mc)),'_',Obj,'.gdx'];
                            
                            %Check if file exists
                            FullFileName = dir ([results_folder,filename]);
                            if isempty(char(FullFileName.name))
                                disp(['File ',filename,' not found']);
                                continue;
                            end
                            
                            if FullFileName.bytes == 0
                                disp(['File ',filename,' is of zero size']);
                                continue;
                            end
                            
                            %Check if modelStat is appropriate
                            modelStat=rgdx([results_folder,filename],modelStat_structure);
                            BOStat_OL=rgdx([results_folder,filename],BOStat_OL_structure);
                            BOStat_CL=rgdx([results_folder,filename],BOStat_CL_structure);
                            
                            [rows,cols,vals] = find(modelStat.val(1:RF{df}(rf):end) ~=1);
                            if (size(rows) ~= 0)
                                disp(['ModelStat is not 1 for ', filename])
                                disp(['ModelStat values are ',num2str(modelStat.val(rows,1)')])
                            end
                            rows=[];cols=[];vals=[];
                            
                            [rows,cols,vals] = find(modelStat.val(1:1:end) ==10);
                            if (size(rows) ~= 0)
                                disp(['ModelStat is 10 for ', filename])
                                disp(['ModelStat values are ',num2str(modelStat.val(rows,1)')])
                            end
                            rows=[];cols=[];vals=[];
                            
                            [rows,cols,vals] = find(BOStat_OL.val(1:RF{df}(rf):end) ~=0);
                            if (size(rows) ~= 0)
                                disp(['BOStat_OL is not 0 for ', filename])
                            end
                            rows=[];cols=[];vals=[];
                            
                            [rows,cols,vals] = find(BOStat_CL.val(1:RF{df}(rf):end) ~=0);
                            if (size(rows) ~= 0)
                                disp(['BOStat_CL is not 0 for ', filename])
                            end
                            rows=[];cols=[];vals=[];
                            
                            %Assign data from gdx file
                            cost = rgdx([results_folder,filename],runcost_structure);
                            profit = rgdx([results_folder,filename],runprofit_structure);
                            
                            if strcmp(Obj,'Cost')
                                data_val=cost.val;
                            elseif strcmp(Obj,'Profit')
                                data_val=profit.val;
                            else
                                disp('Wrong objective')
                            end
                           data_MC(bo,df,mc)=data_val;  
                        end
                    end
                end
            end
        end
    end                      
end

delta = squeeze(data_MC(1,:,:) - data_MC(2,:,:)); 

data1=squeeze(data_MC(1,1,:));
data2=squeeze(data_MC(2,1,:));

subplot(1,3,1)
plot(1:length(MC{1}),[squeeze(data_MC(1,1,:)),squeeze(data_MC(2,1,:))]);
xlabel('Demand Sample');
ylabel('Closed Loop Profit ($)')
title('DF3,DL3')
% set(gca,'XTick',[1:25:100])
subplot(1,3,2)
plot(1:length(MC{1}),[squeeze(data_MC(1,2,:)),squeeze(data_MC(2,2,:))]);
xlabel('Demand Sample');
ylabel('Closed Loop Profit ($)')
title('DF6,DL6')
subplot(1,3,3)
plot(1:length(MC{1}),[squeeze(data_MC(1,3,:)),squeeze(data_MC(2,3,:))]);
xlabel('Demand Sample');
ylabel('Closed Loop Profit ($)')
title('DF12,DL12')

% legend({'BO.fx=0','BO Allowed'})
legend({'Model 1','Model 2'})





