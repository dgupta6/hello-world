%Collect results from gdx files to compare closed loop quality
%Read results from filenames: "Z_N1_MH12_RF1_OPT1_DF12_DV3_DL25_DU1_S1_MC1_Profit.gdx"
clc
clear
close all
disp('Remember demand patterns are dependent on highest MH value, so dont mix Z_N1_same of MH with Z_N1_same of RF,OPT')

flag_plot_MH  = 0;
flag_plot_RF  = 0;
flag_plot_OPT = 0;
flag_plot_Greedy = 0;
plot_errorbar = 0;
scale_data    = 1;
set_same_scale= 0;
autoscale=0;

TitleMatrix = {'A(i)','B(i)','C(i)';
    'A(ii)','B(ii)','C(ii)';
    'A(iii)','B(iii)','C(iii)'};

% N=1;
N=2;
% N=3;

data_store = cell(4,2,3,3,3);
p_value = cell(4,2,3,3,3); %"plot_MH_RF_OPT_Greedy(1-4);plot_cost_profit(1-2);DF(1-3);DL(1-3);(RF1-3 or MH1-3 or RF1-3) within a subplot"
tbl = cell(4,2,3,3,3);
stats = cell(4,2,3,3,3);

corr_value = cell(3,4,2,3,3,3); %Type of corr (Pearson, Kendall, Spearman), %"plot_MH_RF_OPT_Greedy(1-4);plot_cost_profit(1-2);DF(1-3);DL(1-3);(RF1-3 or MH1-3 or RF1-3) within a subplot"
corr_p_value = cell(3,4,2,3,3,3);

for plot_MH_RF_OPT_Greedy =1:3
    for plot_cost_profit = 1:2
        
        f1=figure(1000*plot_MH_RF_OPT_Greedy + 100*plot_cost_profit);
                         f1.Visible='off'; %Need not see now since figures would be saved as pdf
        switch plot_MH_RF_OPT_Greedy
            case 1
                flag_plot_MH  = 1;
                flag_plot_RF  = 0;
                flag_plot_OPT = 0;
                flag_plot_Greedy = 0;
            case 2
                flag_plot_MH  = 0;
                flag_plot_RF  = 1;
                flag_plot_OPT = 0;
                flag_plot_Greedy = 0;
            case 3
                flag_plot_MH  = 0;
                flag_plot_RF  = 0;
                flag_plot_OPT = 1;
                flag_plot_Greedy = 0;
            case 4
                flag_plot_MH  = 0;
                flag_plot_RF  = 0;
                flag_plot_OPT = 0;
                flag_plot_Greedy = 1;
            otherwise
                disp('plot_MH_RF_OPT index should be 1:3')
        end
        
        if flag_plot_MH==1
            switch plot_cost_profit
                case 1
                    if N==2
                        results_folder = 'C:\Users\dhruv\Desktop\GDX_Output\February\MH_Feb18';
                        DF={3,6,12};
                        DV={1,1,3};
                        DL={[3 4 5];
                            [6 8 10];
                            [12 16 20]};
                        Obj='Cost';
                        MC={[1:10],[1:10],[1:10],[1:10]};
                        
%                         MC={[1:100],[1:100],[1:100],[1:100]};
%                         results_folder = 'C:\Users\dhruv\Desktop\GDX_Output\April\N2_All_MC100';
%                         disp('MC100')
                        
                        MH = {[18:3:36],[18:3:36],[18:3:36],[18:3:36]};
                        RF = {[1,3,6],[1,3,6],[1,3,6],[1,3,6]};
                        OPT = {0,0,0,0};
                    elseif N==3
                        results_folder = 'C:\Users\dhruv\Desktop\GDX_Output\March\Network3_March30\Cost_OneLoad\';
                        results_folder = 'C:\Users\dhruv\Desktop\GDX_Output\March\Network3_March31\N3_All';
                        DF={3,6,12};
                        DV={1,1,3};
                        DL={[1 2 3];
                            [2 4 6];
                            [4 8 12]};
                        Obj='Cost';
                        MC={[1:10],[1:10],[1:10],[1:10]};
                        %                         MH = {[18:3:30],[18:3:30],[18:3:30],[18:3:30]};
                        MH = {[18:3:27],[18:3:27],[18:3:27],[18:3:27]};
                        RF = {[1,3,6],[1,3,6],[1,3,6],[1,3,6]};
                        OPT = {0,0,0,0};
                    end
                    %                     N=5;
                    %                     results_folder = 'C:\Users\dhruv\Desktop\GDX_Output\March\LeadTimeN5_March9\GAMS_Code_Paper1';
                    %                     DF={6,12,24};
                    %                     DV={1,3,4};
                    %                     DL={6;12;24};
                    %                     Obj='Cost';
                    %                     MC={[1:10],[1:10],[1:10],[1:10]};
                    % %                     MH = {[24:6:48],[24:6:48],[24:6:48],[24:6:48]};
                    % %                     MH = {[30:6:48],[30:6:48],[30:6:48],[30:6:48]};
                    %                     MH = {[36:6:72],[36:6:72],[36:6:72],[36:6:72]};
                    % %                     RF = {[1,3,6],[1,3,6],[1,3,6],[1,3,6]};
                    % %                       RF = {[3,6,12],[3,6,12],[3,6,12],[3,6,12]};
                    %                       RF = {[6,12],[6,12],[6,12],[6,12]};
                    %                     OPT = {0,0,0,0};
                case 2
                    if N==2
                        results_folder = 'C:\Users\dhruv\Desktop\GDX_Output\February\Profit_Testing_Feb20\MH\BO_NotAllowed_Inv12';
                        %             results_folder = 'C:\Users\dhruv\Desktop\GDX_Output\February\Profit_Testing_Feb20\MH\BO_NotAllowed_Inv3';
                        %                                 results_folder = 'C:\Users\dhruv\Desktop\GDX_Output\February\Profit_Testing_Feb20\MH\BO_Allowed_Inv12';
                        %             results_folder = 'C:\Users\dhruv\Desktop\GDX_Output\February\Profit_Testing_Feb20\MH\BO_Allowed_Inv3';
                        DF={3,6,12};
                        DV={1,1,3};
                        DL={3,6,12};
                        Obj='Profit';
                        MC={[1:10],[1:10],[1:10],[1:10]};
%                         MC={[1:100],[1:100],[1:100],[1:100]};
%                         results_folder = 'C:\Users\dhruv\Desktop\GDX_Output\April\N2_All_MC100'; 
%                         disp('MC100')
                        MH = {[18:3:30],[18:3:30],[18:3:30],[18:3:30]};
                        RF = {[1,3,6],[1,3,6],[1,3,6],[1,3,6]};
                        OPT = {0,0,0,0};
                    elseif N==3
                        results_folder = 'C:\Users\dhruv\Desktop\GDX_Output\March\Network3_March30\Cost_OneLoad\';
                        results_folder = 'C:\Users\dhruv\Desktop\GDX_Output\March\Network3_March31\N3_All';
                        DF={3,6,12};
                        DV={1,1,3};
                        DL={1,2,4};
                        Obj='Profit';
                        MC={[1:10],[1:10],[1:10],[1:10]};
                        %                         MH = {[18:3:30],[18:3:30],[18:3:30],[18:3:30]};
                        MH = {[18:3:27],[18:3:27],[18:3:27],[18:3:27]};
                        RF = {[1,3,6],[1,3,6],[1,3,6],[1,3,6]};
                        OPT = {0,0,0,0};
                    end
            end
            DU={1,1,1,1};S={1,1,1,1};
            fig_filename=['N',num2str(N),'_MH_',Obj];
        elseif flag_plot_RF == 1
            switch plot_cost_profit
                case 1  %COST
                    if N==2
                        %results_folder = 'C:\Users\dhruv\Desktop\GDX_Output\February\RF_Feb18';
                        results_folder = 'C:\Users\dhruv\Desktop\GDX_Output\February\Profit_Testing_Feb20\RF\BO_AllowedInv12';
                        %results_folder = 'C:\Users\dhruv\Desktop\GDX_Output\February\Profit_Testing_Feb20\RF\BO_NotAllowedInv12';
                        DF={3,6,12};
                        DV={1,1,3};
                        DL={[3 4 5];
                            [6 8 10];
                            [12 16 20]};
                        Obj='Cost';
                        MC={[1:10],[1:10],[1:10],[1:10]};
%                         MC={1,1,1,1};
%                         MC={3,3,3,3};
%                         MC={4,4,4,4};
%                         MC={5,5,5};
%                         MC={6,6,6};
%                         MC={7,7,7,7};
%                         MC={8,8,8,8};
%                         MC={9,9,9};
%                         MC={10,10,10};
%                         MC={[1:100],[1:100],[1:100],[1:100]};
%                         results_folder = 'C:\Users\dhruv\Desktop\GDX_Output\April\N2_All_MC100';    
%                         disp('MC100')
                        %             MH = {[12:6:24],[12:6:24],[12:6:24]};
                        MH = {[18:6:30],[18:6:30],[18:6:30]};
                        RF = {[1:6],[1:6],[1:6]};
                        OPT = {0,0,0,0};
                    elseif N==3
                        %                         results_folder = 'C:\Users\dhruv\Desktop\GDX_Output\March\Network3_March30\Cost_OneLoad\';
                        %                         results_folder = 'C:\Users\dhruv\Desktop\GDX_Output\March\Network3_March31\N3_All';
                        results_folder = 'C:\Users\dhruv\Desktop\GDX_Output\March\Network3_March31\N3_RF_Study_April4';
                        DF={3,6,12};
                        DV={1,1,3};
                        DL={[1 2 3];
                            [2 4 6];
                            [4 8 12]};
                        Obj='Cost';
                        %                         MH = {[18:6:30],[18:6:30],[18:6:30],[18:6:30]};
                        %                         MH = {[18:6:24],[18:6:24],[18:6:24]};
                        MH = {[18:3:24],[18:3:24],[18:3:24],[18:3:24]};
                        RF = {[1:6],[1:6],[1:6],[1:6]};
                        OPT = {0,0,0,0};
                        %                         MC={[1:10],[1:10],[1:10],[1:10]};
                        MC={[1:20],[1:20],[1:20],[1:20]};
                    end
                case 2 %PROFIT
                    if N==2
                        %                     results_folder = 'C:\Users\dhruv\Desktop\GDX_Output\February\RF_Feb18';
                        results_folder = 'C:\Users\dhruv\Desktop\GDX_Output\February\Profit_Testing_Feb20\RF\BO_NotAllowedInv12';
                        %                     results_folder = 'C:\Users\dhruv\Desktop\GDX_Output\February\Profit_Testing_Feb20\RF\BO_AllowedInv12';
                        %             results_folder = 'C:\Users\dhruv\Desktop\GDX_Output\February\Profit_Testing_Feb20\MH\BO_NotAllowed_Inv3';
                        %             results_folder = 'C:\Users\dhruv\Desktop\GDX_Output\February\Profit_Testing_Feb20\MH\BO_Allowed_Inv12';
                        %             results_folder = 'C:\Users\dhruv\Desktop\GDX_Output\February\Profit_Testing_Feb20\MH\BO_Allowed_Inv3';
                        DF={3,6,12};
                        DV={1,1,3};
                        DL={3,6,12};
                        Obj='Profit';
                        
                        MC={[1:10],[1:10],[1:10],[1:10]};
%                         MC={[1:100],[1:100],[1:100],[1:100]};
%                         results_folder = 'C:\Users\dhruv\Desktop\GDX_Output\April\N2_All_MC100';      
%                         disp('MC100')
                        %             MH = {[12:6:24],[12:6:24],[12:6:24]};
                        MH = {[18:6:30],[18:6:30],[18:6:30]};
                        RF = {[1:6],[1:6],[1:6]};
                        OPT = {0,0,0,0};
                    elseif N==3
                        %                         results_folder = 'C:\Users\dhruv\Desktop\GDX_Output\March\Network3_March30\Cost_OneLoad\';
                        %                         results_folder = 'C:\Users\dhruv\Desktop\GDX_Output\March\Network3_March31\N3_All';
                        results_folder = 'C:\Users\dhruv\Desktop\GDX_Output\March\Network3_March31\N3_RF_Study_April4';
                        DF={3,6,12};
                        DV={1,1,3};
                        DL={1,2,4};
                        Obj='Profit';
                        %                         MH = {[18:6:30],[18:6:30],[18:6:30],[18:6:30]};
                        %                         MH = {[18:3:21],[18:3:21],[18:3:21]};
                        %                         MH = {[21:3:24],[21:3:24],[21:3:24]};
                        MH = {[18:3:24],[18:3:24],[18:3:24],[18:3:24]};
                        %  MH = {[18:6:24],[18:6:24],[18:6:24]};
                        RF = {[1:6],[1:6],[1:6],[1:6]};
                        OPT = {0,0,0,0};
                        %                         MC={[1:10],[1:10],[1:10],[1:10]};
                        MC={[1:20],[1:20],[1:20],[1:20]};
                    end
            end
            DU={1,1,1,1};S={1,1,1,1};
            fig_filename=['N',num2str(N),'_RF_',Obj];
        elseif flag_plot_OPT == 1
            %         results_folder = 'C:\Users\dhruv\Desktop\GDX_Output\January_OPT_N2_V1';
            %     results_folder = 'C:\Users\dhruv\Desktop\GDX_Output\OPT_Study\GAMS_Code_Paper1_OPTStudy_Jan25_Flat_Objective';
            %     results_folder='C:\Users\dhruv\Desktop\GDX_Output\OPT_Study\GAMS_Code_Paper1_OPTStudy_Jan26_Flat_Objective_NoShipM4';
            %             results_folder='C:\Users\dhruv\Desktop\GDX_Output\OPT_Study\GAMS_Code_Paper1_OPTStudy_Jan26_GradientObjective';
            % results_folder = 'C:\Users\dhruv\Desktop\GDX_Output\OPT_Study\GAMS_Code_Paper1_OPTStudy_Jan26_GradientObjective_NoShipM4';
            %     results_folder='Z:\Code_January\GAMS_Code_Paper1_OPTStudy_Jan25_NewModel';
            %      results_folder = 'C:\Users\dhruv\Desktop\GDX_Output\GAMS_Code_Paper1_OPT_study_Jan24';
            %     results_folder = 'C:\Users\dhruv\Desktop\GDX_Output\GAMS_Code_Paper1_CTM_NoShip_Material_M4_FirstHalf';
            %     results_folder = 'C:\Users\dhruv\Desktop\GDX_Output\GAMS_Code_Paper1_StudyJan22_CTM_Email_Inventory_Constraint';
            
            disp('Assumption that OPT values, MH and DL are same across DF,DL for true gap averaging')
            disp('IntGap is ratio: lp relax/best intg, true gap,est gap are (suboptimal-bestintg)/best-integer not %age')
            
            
            switch plot_cost_profit
                case 1
                    if N==2
                        %             results_folder = 'C:\Users\dhruv\Desktop\GDX_Output\OPT_Study\GAMS_Code_Paper1_OPT_Jan26';
                        results_folder = 'C:\Users\dhruv\Desktop\GDX_Output\February\OPT_Feb18';
                        DF={3,6,12};
                        DV={1,1,3};
                        DL={[3 4 5];
                            [6 8 10];
                            [12 16 20]};
                        Obj='Cost';
                        MC={[1:10],[1:10],[1:10],[1:10]};
%                         MC={[1:100],[1:100],[1:100],[1:100]};
%                         results_folder = 'C:\Users\dhruv\Desktop\GDX_Output\April\N2_All_MC100';    
%                         disp('MC100')
                        %                 MH = {12,12,12,12};
                        %                 MH = {18,18,18,18};
                        MH = {24,24,24,24};
                        RF = {[1,3,6],[1,3,6],[1,3,6],[1,3,6]};%RF 1,3,6,9
                        OPT = {0:2.5:10,0:2.5:10,0:2.5:10,0:2.5:10};
                    elseif N==3
                        results_folder = 'C:\Users\dhruv\Desktop\GDX_Output\March\Network3_March30\Cost_OneLoad\';
                        results_folder = 'C:\Users\dhruv\Desktop\GDX_Output\March\Network3_March31\N3_All';
                        DF={3,6,12};
                        DV={1,1,3};
                        DL={[1 2 3];
                            [2 4 6];
                            [4 8 12]};
                        Obj='Cost';
                        MH = {24,24,24,24};
                        RF = {[1,3,6],[1,3,6],[1,3,6],[1,3,6]};
                        MC={[1:10],[1:10],[1:10],[1:10]};
                        OPT = {0:2.5:10,0:2.5:10,0:2.5:10,0:2.5:10};
                    end
                case 2
                    if N==2
                        results_folder = 'C:\Users\dhruv\Desktop\GDX_Output\February\Profit_Testing_Feb20\OPT\BO_NotAllowed_Inv12';
                        % results_folder = 'C:\Users\dhruv\Desktop\GDX_Output\February\Profit_Testing_Feb20\OPT\BO_NotAllowed_Inv3';
                        % results_folder = 'C:\Users\dhruv\Desktop\GDX_Output\February\Profit_Testing_Feb20\OPT\BO_Allowed_Inv12';
                        % results_folder = 'C:\Users\dhruv\Desktop\GDX_Output\February\Profit_Testing_Feb20\OPT\BO_Allowed_Inv3';
                        DF={3,6,12};
                        DV={1,1,3};
                        DL={3,6,12};
                        Obj='Profit';
                        MC={[1:10],[1:10],[1:10],[1:10]};
%                         MC={[1:100],[1:100],[1:100],[1:100]};
%                         results_folder = 'C:\Users\dhruv\Desktop\GDX_Output\April\N2_All_MC100';  
%                         disp('MC100')
                        %                 MH = {12,12,12,12};
                        %                 MH = {18,18,18,18};
                        MH = {24,24,24,24};
                        RF = {[1,3,6],[1,3,6],[1,3,6],[1,3,6]};%RF 1,3,6,9
                        OPT = {0:2.5:10,0:2.5:10,0:2.5:10,0:2.5:10};
                    elseif N==3
                        results_folder = 'C:\Users\dhruv\Desktop\GDX_Output\March\Network3_March30\Cost_OneLoad\';
                        results_folder = 'C:\Users\dhruv\Desktop\GDX_Output\March\Network3_March31\N3_All';
                        DF={3,6,12};
                        DV={1,1,3};
                        DL={1,2,4};
                        Obj='Profit';
                        MH = {24,24,24,24};
                        RF = {[1,3,6],[1,3,6],[1,3,6],[1,3,6]};
                        MC={[1:10],[1:10],[1:10],[1:10]};
                        OPT = {0:2.5:10,0:2.5:10,0:2.5:10,0:2.5:10};
                    end
            end
            
            DU={1,1,1,1};S={1,1,1,1};
            fig_filename=['N',num2str(N),'_OPT_',Obj];
        elseif flag_plot_Greedy == 1
            results_folder = 'C:\Users\dhruv\Desktop\GDX_Output\February\GreedyObjective_Feb16\DV1';
            %             %              results_folder = 'C:\Users\dhruv\Desktop\GDX_Output\GreedyObjective_Feb16\DVZero';
            %             results_folder = 'C:\Users\dhruv\Desktop\GDX_Output\January\OPT_Study\GAMS_Code_Paper1_OPTStudy_Jan26_GradientObjective_NoShipM4';
            %             results_folder = 'C:\Users\dhruv\Desktop\GDX_Output\January\OPT_Study\GAMS_Code_Paper1_OPTStudy_Jan26_Flat_Objective_NoShipM4';
            %             results_folder = 'C:\Users\dhruv\Desktop\GDX_Output\January\OPT_Study\GAMS_Code_Paper1_OPTStudy_Jan26_GradientObjective';
            N=1;
            switch plot_cost_profit
                case 1
                    DF={3,6,12};
                    DV={1,1,3};
                    DL={[3 4 5];
                        [6 8 10];
                        [12 16 20]};
                    Obj='Cost';
                case 2
                    %                     DF={3,6,12};
                    DF={3};
                    DV={1,1,3};
                    %DV={0,0,0};
                    DL={3,6,12};
                    %                     DL={3};
                    Obj='Profit';
            end
            DU={1,1,1,1};S={1,1,1,1};
            MC={[1:100],[1:100],[1:100],[1:100]};
            %             MC={[1:10],[1:10],[1:10],[1:10]};
            %             MC={[51:100],[51:100],[51:100],[51:100]};
            %             MC={[1:50],[1:50],[1:50],[1:50]};
            %             MC={[1:10],[1:10],[1:10],[1:10]};
            MH = {12,12,12,12};
            RF = {[1,3],[1,3],[1,3],[1,3]};%RF 1,3,6,9
            OPT = {0:1:10,0:1:10,0:1:10,0:1:10};
            %             OPT = {0:2.5:10,0:2.5:10,0:2.5:10,0:2.5:10};
            fig_filename=['Greedy_OPT_',Obj];
            flag_plot_OPT=1;
        end
        
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
        
        if flag_plot_OPT == 1
            IntGap_demand = zeros(length(DF),length(DL{1}));
            TrueGap_demand = cell(length(DF),length(DL{1}));
            EstGap_demand = cell(length(DF),length(DL{1}));
        end
        
        n=N;
        for df = 1:length(DF);
            axes{df}=cell(1,length(DL{df}));
            chart{df} = cell(1,length(DL{df}));
            
            for dl = 1:length(DL{df})
                %Define size of data for each subplot
                if flag_plot_MH == 1
                    data_MC = zeros(length(RF{df}),length(MH{df}),length(MC{df}));
                elseif flag_plot_RF == 1
                    data_MC = zeros(length(MH{df}),length(RF{df}),length(MC{df}));
                elseif flag_plot_OPT == 1
                    data_MC = zeros(length(RF{df}),length(OPT{df}),length(MC{df}));
                    IntegralityGap_data_MC = zeros(n_calc+1,length(RF{df}),length(OPT{df}),length(MC{df}));
                    True_modelGap_data_MC = zeros(n_calc+1,length(RF{df}),length(OPT{df}),length(MC{df}));
                    Est_modelGap_data_MC = zeros(n_calc+1,length(RF{df}),length(OPT{df}),length(MC{df}));
                end
                
                for mc = 1:length(MC{df})
                    for mh=1:length(MH{df})
                        for rf=1:length(RF{df})
                            for opt=1:length(OPT{df})
                                
                                filename = ['Z_N',num2str(n),'_MH',num2str(MH{df}(mh)),'_RF',num2str(RF{df}(rf)),...
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
%                                 filename
                                modelStat=rgdx([results_folder,filename],modelStat_structure);
                                if (flag_plot_MH == 1 || flag_plot_RF == 1)
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
                                elseif flag_plot_OPT == 1
                                    [rows,cols,vals] = find((modelStat.val ~= 1).*(modelStat.val ~= 8));
                                    if (size(rows) ~= 0)
                                        disp(['ModelStat is not 1 or 8 for ', filename])
                                        disp(['ModelStat values are ',num2str(modelStat.val(rows,1)')])
                                        disp('Optimiziation Numbers:')
                                        rows'
                                    end
                                    rows=[];cols=[];vals=[];
                                end
                                
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
                                
                                if flag_plot_MH == 1
                                    data_MC(rf,mh,mc) = data_val;
                                elseif flag_plot_RF == 1
                                    data_MC(mh,rf,mc) = data_val;
                                elseif flag_plot_OPT == 1
                                    data_MC(rf,opt,mc) = data_val;
                                    IntGapRaw = rgdx([results_folder,filename],IntegralityGap_structure);
                                    %                                     IntGapRaw = rgdx([results_folder,filename],True_modelGap_structure);
                                    TrueGapRaw = rgdx([results_folder,filename],True_modelGap_structure);
                                    EstGapRaw = rgdx([results_folder,filename],Est_modelGap_structure);
                                    %                                     disp(filename)
                                    %                                     disp(IntGap.val)
                                    IntegralityGap_data_MC(:,rf,opt,mc) = IntGapRaw.val(:,1);
                                    True_modelGap_data_MC(:,rf,opt,mc) = TrueGapRaw.val(:,1);
                                    Est_modelGap_data_MC(:,rf,opt,mc) = EstGapRaw.val(:,1);
                                    if (strcmp(Obj,'Profit') & any(True_modelGap_data_MC > 0))
                                        disp(['TrueGap>0 for ',filename])
                                    end
                                    %                                     save([pwd,'\DATA\IntGap\IntGap_',filename(1:end-4)],'IntegralityGap_data_MC');
                                    %                                     save([pwd,'\DATA\TrueGap\TrueGap_',filename(1:end-4)],'True_modelGap_data_MC');
                                end
                                
                            end
                        end
                    end
                end
                
                
                %Average, Scale and Plot
                %                 subplot(length(DF),length(DL{df}),(df-1)*length(DL{df}) +
                %                 dl);
                subplot(length(DL{df}),length(DF),(dl-1)*length(DF) + df)
                LineSpec = {'b-s','r-o','g-^','k-+','m-x'};
                hold on
                grid on
                box on
                drawnow
                
                if strcmp(Obj,'Cost')
                    w=8.5;h=6;p=0.01;
                elseif strcmp(Obj,'Profit')
                    w=8.5;h=2;p=0.01;
                end
                set(gcf,...
                    'Units','inches',...
                    'Position',[1 1 w h],...
                    'PaperUnits','inches',...
                    'PaperPosition',[p*w p*h w h],...
                    'PaperSize',[w*(1+2*p) h*(1+2*p)]);
                %                 data = mean(data_MC,3); %Average
                %                 std_dev = std(data_MC,0,3); %standard deviation
                
                %The err_coeff is multiplied to sigma estimated to give
                %errorbars
                err_coeff = tinv(0.975,length(MC{df})-1)/sqrt(length(MC{df}));
                
                if flag_plot_MH == 1
                    %Statistical Analaysis Two-way Anova
                    %Note that the data is transposed
                    for rf=1:length(RF{df})
                        data_store{plot_MH_RF_OPT_Greedy,plot_cost_profit,df,dl,rf} = squeeze(data_MC(rf,:,:))';
                        [p_value{plot_MH_RF_OPT_Greedy,plot_cost_profit,df,dl,rf},...
                            tbl{plot_MH_RF_OPT_Greedy,plot_cost_profit,df,dl,rf},...
                            stats{plot_MH_RF_OPT_Greedy,plot_cost_profit,df,dl,rf}] = anova2(squeeze(data_MC(rf,:,:))',1,'off');
                    end
                    
                    data = mean(data_MC,3); %Average
                    std_dev = std(data_MC,0,3); %standard deviation
                    
                    %Statistical Analysis Corr values
                    %Data needs to be transposed                   
                    for rf=1:length(RF{df})
                        [corr_value{1,plot_MH_RF_OPT_Greedy,plot_cost_profit,df,dl,rf}...
                            ,corr_p_value{1,plot_MH_RF_OPT_Greedy,plot_cost_profit,df,dl,rf}]=corr(MH{df}',data(rf,:)','type','Pearson');
                        [corr_value{2,plot_MH_RF_OPT_Greedy,plot_cost_profit,df,dl,rf}...
                            ,corr_p_value{2,plot_MH_RF_OPT_Greedy,plot_cost_profit,df,dl,rf}]=corr(MH{df}',data(rf,:)','type','Kendall');
                        [corr_value{3,plot_MH_RF_OPT_Greedy,plot_cost_profit,df,dl,rf}...
                            ,corr_p_value{3,plot_MH_RF_OPT_Greedy,plot_cost_profit,df,dl,rf}]=corr(MH{df}',data(rf,:)','type','Spearman');
                    end
                    
                    if (scale_data==1)
                        std_dev = std_dev/data(1,end);
                        data = data/data(1,end); %Scale (Fastest RF, Longest MH)
                    end
                    Legend_cell=cell(length(RF{df}),1);
                    for rf=1:length(RF{df})
                        if plot_errorbar==1
                            chart{df}{dl} = errorbar(MH{df},data(rf,:),err_coeff*std_dev(rf,:),LineSpec{rf});
                        else
                            chart{df}{dl} = plot(MH{df},data(rf,:),LineSpec{rf});
                        end
                        Legend_cell{rf} = ['RF ',num2str(RF{df}(rf))];
                    end
                    %                     title(['N',num2str(n),' DF',num2str(DF{df}), ' DL',num2str(DL{df}(dl)),' OPT',num2str(OPT{df}),' ',Obj]);
                    title([TitleMatrix{dl,df}]);
                    %                     xlabel('Moving Horizon Length (Hours)');
                    xlabel('MH Length (Hours)');
                    set(gca,'XTick',MH{df},'XLim',[MH{df}(1)-1 MH{df}(end)+1]);
                    %                     ylabel({['Closed Loop '],['Quality (',Obj,')']});
                    save_data=[MH{df};data]';
                    save([pwd,'\DATA\MH\N',num2str(N),'_MH_',Obj,...
                        '_DF',num2str(DF{df}),'_DL',num2str(DL{df}(dl))],'save_data');
                    line([MH{df}(1) MH{df}(end)],[1 1],'LineStyle',':')
                elseif flag_plot_RF == 1
                    %Statistical Analaysis Two-way Anova
                    %Note that the data is transposed
                    for mh=1:length(MH{df})
                        data_store{plot_MH_RF_OPT_Greedy,plot_cost_profit,df,dl,mh} = squeeze(data_MC(mh,:,:))';
                        [p_value{plot_MH_RF_OPT_Greedy,plot_cost_profit,df,dl,mh},...
                            tbl{plot_MH_RF_OPT_Greedy,plot_cost_profit,df,dl,mh},...
                            stats{plot_MH_RF_OPT_Greedy,plot_cost_profit,df,dl,mh}] = anova2(squeeze(data_MC(mh,:,:))',1,'off');
                    end
                    
                    data = mean(data_MC,3); %Average
                    std_dev = std(data_MC,0,3); %standard deviation

                    %Statistical Analysis Corr values
                    %Data needs to be transposed
                    for mh=1:length(MH{df})
                        [corr_value{1,plot_MH_RF_OPT_Greedy,plot_cost_profit,df,dl,mh}...
                            ,corr_p_value{1,plot_MH_RF_OPT_Greedy,plot_cost_profit,df,dl,mh}]=corr(RF{df}',data(mh,:)','type','Pearson');
                        [corr_value{2,plot_MH_RF_OPT_Greedy,plot_cost_profit,df,dl,mh}...
                            ,corr_p_value{2,plot_MH_RF_OPT_Greedy,plot_cost_profit,df,dl,mh}]=corr(RF{df}',data(mh,:)','type','Kendall');
                        [corr_value{3,plot_MH_RF_OPT_Greedy,plot_cost_profit,df,dl,mh}...
                            ,corr_p_value{3,plot_MH_RF_OPT_Greedy,plot_cost_profit,df,dl,mh}]=corr(RF{df}',data(mh,:)','type','Spearman');
                    end
                    
                    if (scale_data==1)
                        std_dev = std_dev/data(end,1);
                        data = data/data(end,1); %Scale (Longest MH, Fastest RF)
                    end
                    
                    Legend_cell=cell(length(MH{df}),1);
                    for mh=1:length(MH{df})
                        if plot_errorbar==1
                            chart{df}{dl} = errorbar(RF{df},data(mh,:),err_coeff*std_dev(mh,:),LineSpec{mh});
                        else
                            chart{df}{dl} = plot(RF{df},data(mh,:),LineSpec{mh});
                        end
                        Legend_cell{mh} = ['MH ',num2str(MH{df}(mh))];
                    end
                    %                     title(['N',num2str(n),' DF',num2str(DF{df}), ' DL',num2str(DL{df}(dl)),' OPT',num2str(OPT{df}),' ',Obj]);
                    title([TitleMatrix{dl,df}]);
                    xlabel('RF (Hours)');
                    set(gca,'XTick',RF{df},'XLim',[RF{df}(1)-1 RF{df}(end)+1]);
                    %save data as mat files
                    save_data=[RF{df};data]';
                    save([pwd,'\DATA\RF\N',num2str(N),'_RF_',Obj,...
                        '_DF',num2str(DF{df}),'_DL',num2str(DL{df}(dl))],'save_data');
                    line([RF{df}(1) RF{df}(end)],[1 1],'LineStyle',':')
                elseif flag_plot_OPT == 1
                    
                    save_data_MC=data_MC;
                    save([pwd,'\DATA\OPT\N',num2str(N),'_OPT_',Obj,...
                        '_DF',num2str(DF{df}),'_DL',num2str(DL{df}(dl)),'_MC'],'save_data_MC');
                    
                    
                    %Statistical Analaysis Two-way Anova
                    %Note that the data is transposed
                    for rf=1:length(RF{df})
                        data_store{plot_MH_RF_OPT_Greedy,plot_cost_profit,df,dl,rf} = squeeze(data_MC(rf,:,:))';
                        [p_value{plot_MH_RF_OPT_Greedy,plot_cost_profit,df,dl,rf},...
                            tbl{plot_MH_RF_OPT_Greedy,plot_cost_profit,df,dl,rf},...
                            stats{plot_MH_RF_OPT_Greedy,plot_cost_profit,df,dl,rf}] = anova2(squeeze(data_MC(rf,:,:))',1,'off');
                    end
                    
                    data = mean(data_MC,3); %Average
                    std_dev = std(data_MC,0,3); %standard deviation
                    
                    %Statistical Analysis Corr values
                    %Data needs to be transposed                   
                    for rf=1:length(RF{df})
                        [corr_value{1,plot_MH_RF_OPT_Greedy,plot_cost_profit,df,dl,rf}...
                            ,corr_p_value{1,plot_MH_RF_OPT_Greedy,plot_cost_profit,df,dl,rf}]=corr(OPT{df}',data(rf,:)','type','Pearson');
                        [corr_value{2,plot_MH_RF_OPT_Greedy,plot_cost_profit,df,dl,rf}...
                            ,corr_p_value{2,plot_MH_RF_OPT_Greedy,plot_cost_profit,df,dl,rf}]=corr(OPT{df}',data(rf,:)','type','Kendall');
                        [corr_value{3,plot_MH_RF_OPT_Greedy,plot_cost_profit,df,dl,rf}...
                            ,corr_p_value{3,plot_MH_RF_OPT_Greedy,plot_cost_profit,df,dl,rf}]=corr(OPT{df}',data(rf,:)','type','Spearman');
                    end
                    
                    if (scale_data==1)
                        std_dev = std_dev/data(1,1);
                        data = data/data(1,1);  %Scale (Fastest RF, Best OPT)
                    end
                    Legend_cell=cell(length(RF{df}),1);
                    
                    for rf=1:length(RF{df})
                        if plot_errorbar==1
                            chart{df}{dl} = errorbar(OPT{df},data(rf,:),err_coeff*std_dev(rf,:),LineSpec{rf});
                        else
                            chart{df}{dl} = plot(OPT{df},data(rf,:),LineSpec{rf});
                        end
                        Legend_cell{rf} = ['RF ',num2str(RF{df}(rf))];
                    end
                    
                    %                     if flag_plot_Greedy==1
                    %                         legend(Legend_cell,'Location','NorthEast','Box','on')
                    %                     end
                    
                    %                     title(['N',num2str(n),' DF',num2str(DF{df}), ' DL',num2str(DL{df}(dl)),' MH',num2str(MH{df}),' ',Obj]);
                    title([TitleMatrix{dl,df}]);
                    xlabel('OPTCR (%age)');
                    set(gca,'XTick',OPT{df},'XLim',[OPT{df}(1)-1 OPT{df}(end)+1]);
                    %save data as mat files
                    save_data=[OPT{df};data]';
                    save([pwd,'\DATA\OPT\N',num2str(N),'_OPT_',Obj,...
                        '_DF',num2str(DF{df}),'_DL',num2str(DL{df}(dl))],'save_data');
                    line([OPT{df}(1) OPT{df}(end)],[1 1],'LineStyle',':');
                    
                    %Integrality gaps and true gaps
                    IntGap_data=zeros(rf,1);
                    TrueGap_data=zeros(rf,opt);
                    EstGap_data=zeros(rf,opt);
                    for rf=1:length(RF{df})
                        IntGap_data(rf) = mean2(IntegralityGap_data_MC(1:RF{df}(rf):(n_calc+1),rf,:,:)); %calc,RF,OPT,mc
                        TrueGap_data(rf,:) = mean(mean(True_modelGap_data_MC(1:RF{df}(rf):(n_calc+1),rf,:,:),4),1);
                        EstGap_data(rf,:) = mean(mean(Est_modelGap_data_MC(1:RF{df}(rf):(n_calc+1),rf,:,:),4),1);
                    end
                    
                    IntGap_demand(df,dl) = mean(IntGap_data(rf));
                    TrueGap_demand{df,dl} = mean(TrueGap_data,1);
                    EstGap_demand{df,dl} = mean(EstGap_data,1);
                end
                
                ylabel(Obj);
                set(gca,'YMinorTick','on');
                
                %Find ylim_upper and ylim_lower
                axes{df}{dl}=gca;
                ylim_upper = max(ylim_upper,axes{df}{dl}.YLim(2));
                ylim_lower = min(ylim_lower,axes{df}{dl}.YLim(1));
                
                
                %Axis scaling matrix
                if N==2
                    Scaling_Matrix_Y_MH_Cost = {[0.98 1.05],[0.99 1.02],[0.98 1.15];
                        [0.98 1.05],[0.99 1.02],[0.98 1.1];
                        [0.98 1.15],[0.98 1.3],[0.98 1.25]}; %[ylim_lower ylim_upper]
                    Scaling_Matrix_Y_RF_Cost = {[0.98 1.04],[0.99 1.02],[0.98 1.10];
                        [0.98 1.04],[0.99 1.02],[0.98 1.08];
                        [0.98 1.08],[0.98 1.25],[0.98 1.25]}; %[ylim_lower ylim_upper]
                    Scaling_Matrix_Y_OPT_Cost = {[0.98 1.03],[0.99 1.01],[0.98 1.05];
                        [0.99 1.02],[0.99 1.02],[0.98 1.05];
                        [0.99 1.03],[0.98 1.05],[0.98 1.07]}; %[ylim_lower ylim_upper]
                    
                    Scaling_Matrix_Y_MH_Profit = {[0.95 1.02],[0.95 1.02],[0.9 1.02]};%[ylim_lower ylim_upper]
                    Scaling_Matrix_Y_RF_Profit =  {[0.95 1.01],[0.95 1.01],[0.9 1.02]};
                    Scaling_Matrix_Y_OPT_Profit = {[0.94 1.02],[0.94 1.02],[0.94 1.02]};
                    Scaling_Matrix_Y_OPT_GreedyProfit = {[0.98 1.02],[0.96 1.02],[0.9 1.02]};
                elseif N==3
                    Scaling_Matrix_Y_MH_Cost = {[0.98 1.1],[0.98 1.2],[0.98 1.3];
                        [0.98 1.1],[0.98 1.1],[0.98 1.03];
                        [0.98 1.06],[0.98 1.4],[0.98 1.6]}; %[ylim_lower ylim_upper]
                    Scaling_Matrix_Y_RF_Cost = {[0.98 1.125],[0.98 1.15],[0.98 1.3];
                        [0.98 1.1],[0.98 1.1],[0.99 1.01];
                        [0.98 1.06],[0.98 1.6],[0.98 1.4]}; %[ylim_lower ylim_upper]                    
                    Scaling_Matrix_Y_OPT_Cost = {[0.98 1.06],[0.98 1.06],[0.98 1.1];
                        [0.98 1.06],[0.98 1.06],[0.99 1.01];
                        [0.98 1.02],[0.98 1.04],[0.98 1.06]}; %[ylim_lower ylim_upper]
                    Scaling_Matrix_Y_OPT_Profit = {[0.92 1.02],[0.92 1.02],[0.92 1.02]};
                end
                
                if autoscale==0
                    if strcmp(Obj,'Cost')
                        if flag_plot_MH == 1
                            ylim(axes{df}{dl},Scaling_Matrix_Y_MH_Cost{dl,df});
                            %                             set(axes{df}{dl},'YTick',[1:0.05:Scaling_Matrix_Y_MH_Cost{dl,df}(2)]);
                        elseif flag_plot_RF == 1
                            ylim(axes{df}{dl},Scaling_Matrix_Y_RF_Cost{dl,df});
                            %                         set(axes{df}{dl},'YTick',[1:0.01:Scaling_Matrix_Y_OPT_Cost{dl,df}(2)]);
                        elseif flag_plot_OPT == 1
                            ylim(axes{df}{dl},Scaling_Matrix_Y_OPT_Cost{dl,df});
                            %                         set(axes{df}{dl},'YTick',[1:0.05:Scaling_Matrix_Y_OPT_Cost{dl,df}(2)]);
                        end
                    elseif strcmp(Obj,'Profit')
                        if flag_plot_MH == 1
                            ylim(axes{df}{dl},Scaling_Matrix_Y_MH_Profit{dl,df});
                            %                         set(axes{df}{dl},'YTick',[1:0.05:Scaling_Matrix_Y_MH_Profit{dl,df}(2)]);
                        elseif flag_plot_RF == 1
                            ylim(axes{df}{dl},Scaling_Matrix_Y_RF_Profit{dl,df});
                            %                         set(axes{df}{dl},'YTick',[0.9:0.01:1]);
                        elseif flag_plot_OPT == 1
                            ylim(axes{df}{dl},Scaling_Matrix_Y_OPT_Profit{dl,df});
                            %set(axes{df}{dl},'YTick',[1:0.05:Scaling_Matrix_Y_OPT_Profit{dl,df}(2)]);
                            if flag_plot_Greedy == 1
                                ylim(axes{df}{dl},Scaling_Matrix_Y_OPT_GreedyProfit{dl,df});
                            end
                        end
                    end
                end
                
            end
        end
        %Set ylim_upper and ylim_lower
        if(set_same_scale==1)
            for df = 1:length(DF);
                for dl = 1:length(DL{df})
                    ylim(axes{df}{dl},[ylim_lower ylim_upper]);
                    chart{df}{dl}.LineWidth=1.5;
                    chart{df}{dl}.MarkerSize=6;
                    %     %         ylim(axes{df}{dl},[0.8 1.1]);
                end
            end
        end
        
        if (strcmp(Obj,'Cost'))
            % legend(Legend_cell,'Location','NorthEast','Orientation','vertical','EdgeColor','Black')
            % legend(Legend_cell,'Position',[0.8,0.8,0.1,0.1],'Orientation','vertical','Box','on');
            legend(Legend_cell,'Position',[0.275,-0.075,0.5,0.2],'Orientation','horizontal','Box','on');
        elseif (strcmp(Obj,'Profit'))
            %                         legend(Legend_cell,'Position',[0.275,-0.025,0.5,0.06],'Orientation','horizontal','Box','on');
            legend(Legend_cell,'Position',[0.95,0.5,0.01,0.2],'Orientation','vertical','Box','off');
            %             legend(Legend_cell,'Location','NorthWest','Orientation','vertical','Box','off');
        end
        
        
        
        for df=1:length(DF)
            for dl=1:length(DL{df})
                axis_position = get(axes{df}{dl},'Position');
                if strcmp(Obj,'Cost')
                    width_tb = 0.08; height_tb = 0.05;
                    if flag_plot_MH == 1
                        annotation('textbox',[axis_position(1)+axis_position(3)-width_tb axis_position(2)+axis_position(4)-height_tb  width_tb height_tb],...
                            'String',['F',num2str(DF{df}), ' L',num2str(DL{df}(dl))]) % annotation('textbox',[x y w h])
                    elseif (flag_plot_RF == 1 || flag_plot_OPT == 1)
                        annotation('textbox',[axis_position(1) axis_position(2)+axis_position(4)-height_tb  width_tb height_tb],...
                            'String',['F',num2str(DF{df}), ' L',num2str(DL{df}(dl))]) % annotation('textbox',[x y w h])
                    end
                elseif strcmp(Obj,'Profit')
                    width_tb = 0.08; height_tb = 0.15;
                    if flag_plot_MH == 1
                        annotation('textbox',[axis_position(1)+axis_position(3)-width_tb axis_position(2)  width_tb height_tb],...
                            'String',['F',num2str(DF{df}), ' L',num2str(DL{df}(dl))]) % annotation('textbox',[x y w h])
                    elseif (flag_plot_RF == 1 || flag_plot_OPT == 1)
                        annotation('textbox',[axis_position(1) axis_position(2)  width_tb height_tb],...
                            'String',['F',num2str(DF{df}), ' L',num2str(DL{df}(dl))]) % annotation('textbox',[x y w h])
                    end
                end
            end
        end
        %         annotation('textarrow',[0.925 0.825],[0.96,0.96],...
        %              'String',{'Increasing','Order','Frequency'},'HorizontalAlignment','center')
        if (strcmp(Obj,'Cost'))
            annotation('textarrow',[0.925 0.825],[0.96,0.96],...
                'String',{'More','Frequent','Orders'},'HorizontalAlignment','center')
            annotation('textarrow',[0.965 0.965],[0.82,0.72],...
                'String',{'Increasing','Load'},'HorizontalAlignment','center')
        elseif (strcmp(Obj,'Profit'))
            %             annotation('textarrow',[0.925 0.85],[0.94,0.94],...
            %                 'String',{'More','Frequent','Orders'},'HorizontalAlignment','center','VerticalAlignment','baseline')
        end
        
        
        print([pwd,'\PLOTS\',fig_filename],'-dpdf')
        
        if flag_plot_OPT==1
            %Averaging out IntGap and TrueGap for final reporting
            disp(Obj);
            IntGap = mean2(IntGap_demand);
            disp(['Hence IntGap ((lp relax-best intg)*100/best intg) is ',num2str((IntGap-1)*100),'%']);
            TrueGap = reshape([TrueGap_demand{:,:}],length(OPT{1}),prod(size(TrueGap_demand)));
            TrueGap = mean(TrueGap,2);
            EstGap = reshape([EstGap_demand{:,:}],length(OPT{1}),prod(size(EstGap_demand)));
            EstGap = mean(EstGap,2);
            save([pwd,'\DATA\IntGap_',Obj,'_MH',num2str(MH{1})],'IntGap');
            save([pwd,'\DATA\TrueGap_',Obj,'_MH',num2str(MH{1})],'TrueGap');
            save([pwd,'\DATA\EstGap_',Obj,'_MH',num2str(MH{1})],'EstGap');
        end
    end
end

save([pwd,'\DATA\ANOVA\','N',num2str(N),'_data_store'],'data_store');
save([pwd,'\DATA\ANOVA\','N',num2str(N),'_p_value'],'p_value');
save([pwd,'\DATA\ANOVA\','N',num2str(N),'_tabl'],'tbl');
save([pwd,'\DATA\ANOVA\','N',num2str(N),'_stats'],'stats');

save([pwd,'\DATA\ANOVA\','N',num2str(N),'_corr_value'],'corr_value');
save([pwd,'\DATA\ANOVA\','N',num2str(N),'_corr_p_value'],'corr_p_value');


%Add supertitles to subplots
%         if flag_plot_MH == 1
%             suptitle(['Closed loop quality as a function of Moving Horizon; ',...
%                 'Load increases vertically; Demand frequency decreases horizontally'])
%         elseif flag_plot_RF == 1
%             suptitle(['Closed loop quality as a function of Rescheduling Frequency; ',...
%                 'Load increases horizontally; Demand frequency decreases vertically'])
%         elseif flag_plot_OPT == 1
%             suptitle(['Closed loop quality as a function of Optimality Gap; ',...
%                 'Load increases horizontally; Demand frequency decreases vertically'])
%         end
%
%now plotting
%   markers = {'+','o','*','.','x','s','d','^','v','>','<','p','h'};
%   lineStyles = {'-', '--', ':', '-.'};
%   colors = {'y', 'm', 'c', 'r', 'g', 'b', 'k'};
% close all