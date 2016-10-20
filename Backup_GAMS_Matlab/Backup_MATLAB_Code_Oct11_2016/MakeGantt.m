function MakeGantt(varargin)
global filename slider_val openloop_unit_number Gantt_Flag
plot_two_gantt_flag=1;

% For original data of first paper
% results_folder = 'C:\Users\dhruv\Desktop\GDX_Output\February\Profit_Testing_Feb20\RF\BO_AllowedInv12';
% results_folder = [results_folder,'\'];
% filename1='Z_N2_MH18_RF1_OPT1_DF3_DV1_DL3_DU1_S1_MC1_Cost';
% filename2='Z_N2_MH18_RF6_OPT1_DF3_DV1_DL3_DU1_S1_MC1_Cost';

%For case study: bad decisions due to orders below beta_min
results_folder = 'C:\Users\dhruv\Box Sync\Work\Codes\GAMS_Code';
results_folder = [results_folder,'\'];
%filename1='Z_N2_MH18_RF1_OPT1_GoodDecisions';
%filename2='Z_N2_MH18_RF6_OPT1_BadDecisions';
filename1='Z_N2_MH23_RF1_OPT1_EffectOfHorizon';
filename2='Z_N2_MH23_RF4_OPT1_EffectOfHorizon';

% filename1='GREEDY0_BO0_SHIP1_Z_N2_MH24_RF1_OPT1_DF3_DV1_DL3_DU1_S1_MC1_Profit';
% filename2='GREEDY0_BO1_SHIP1_Z_N2_MH24_RF1_OPT1_DF3_DV1_DL3_DU1_S1_MC1_Profit';
% filename1='Z_N3_MH12_RF1_OPT1_DF4_DV1_DL5_DU1_S1_MC1_Cost';   
% filename1='Z_N3_MH12_RF1_OPT1_DF4_DV1_DL5_DU1_S1_MC1_Profit';

% results_folder = 'C:\Users\dhruv\Desktop\GDX_Output\February\Profit_Testing_Feb20\RF\BO_AllowedInv12';
% results_folder = [results_folder,'\'];
% filename1='Z_N2_MH18_RF1_OPT1_DF12_DV3_DL12_DU1_S1_MC3_Cost';
% filename2='Z_N2_MH18_RF6_OPT1_DF12_DV3_DL12_DU1_S1_MC3_Cost';


filename1=[results_folder,filename1];
filename2=[results_folder,filename2];
filename=filename1;
% filename='Z_N1_MH12_RF0_DF12_DV3_DL25_DU1_S0_OPT0_MC1';
% results_folder='C:\Users\Dhruv\Desktop\Work\Codes_OnlineMethods\November2015\GAMS_Code_Paper1\';
% filename='Z_N1_MH12_RF0_DF12_DV3_DL25_DU1_S0_OPT0_MC1';
    fig1_Number=101;
    fig2_Number=102;
    
if isempty(varargin)
    slider_val = 0;
    Gantt_Flag = 1; %1=>Closed Loop, %2=> Open Loop
    openloop_unit_number = 1;
    
    if ishandle(fig1_Number)
        clf(fig1_Number);
    end
    if ishandle(fig2_Number)
        clf(fig2_Number);
    end
    
    f1=figure(fig1_Number);
    f1.Units='normalized';
    f1.OuterPosition=[0 0.2 0.5 0.75];
    f1.Units='pixels';
    
    if plot_two_gantt_flag==1
        f2=figure(fig2_Number);
        f2.Units='normalized';
        f2.OuterPosition=[0.5 0.2 0.5 0.75];
        f2.Units='pixels';
    end
else
    slider_val = varargin{1};
    Gantt_Flag = varargin{2}; %1=>Closed Loop, %2=> Open Loop
    openloop_unit_number = varargin{3};
    f1=clf(fig1_Number);
    if plot_two_gantt_flag==1
        f2=clf(fig2_Number);
    end
    %         f=figure(1);
    %         f.Units='normalized';
    %         f.OuterPosition=[0.2 0.2 0.75 0.75];
    %         f.Units='pixels';
end

% Draw gantt chart
f1=figure(fig1_Number);
draw_buttons();
gantt_draw(filename1);
if plot_two_gantt_flag==1
    f2=figure(fig2_Number);
    draw_buttons();
    gantt_draw(filename2);
    
    %Now match the scales for the two inventory plots
    YLim_1=f1.CurrentAxes.YLim;
    YLim_2=f2.CurrentAxes.YLim;
       
    if YLim_2(2) > YLim_1(2)
        f1.CurrentAxes.YLim=YLim_2;
        disp(['YLim for figure ',num2str(fig1_Number),' adjusted']);
    elseif YLim_2(2) < YLim_1(2)
        f2.CurrentAxes.YLim=YLim_1;
        disp(['YLim for figure ',num2str(fig2_Number),' adjusted']);
    end
end
%     if Gantt_Flag==1
%         gantt_ClosedLoop();
%     elseif Gantt_Flag==2
%         gantt_OpenLoop();
%     end
    function draw_buttons()
        popup = uicontrol('Style', 'popup',...
            'String', {'Closed-Loop','Open-Loop'},...
            'Position', [20 40 100 20], 'Value',Gantt_Flag,...
            'Callback', @which_gantt);
        
        %     txt1 = uicontrol('Style','text',...
        %         'Position',[20 20 100 20],...
        %         'String','Unit # = ');
        %
        %     edt1 = uicontrol('Style','edit',...
        %         'Position',[90 25 30 15],...
        %         'String',num2str(openloop_unit_number),'Callback',@OpenLoopUnitNumber);
        
        
        % Calc value
        sld = uicontrol('Style', 'slider',...
            'Min',0,'Max',192,'Value',slider_val,...
            'Position', [150 20 250 20],'SliderStep',[1/193 24/193],...
            'Callback', @calc);
        
        txt2 = uicontrol('Style','text',...
            'Position',[150 40 130 20],...
            'String','Gantt Start Time = ');
        
        edt2 = uicontrol('Style','edit',...
            'Position',[260 45 30 15],...
            'String',num2str(slider_val),'Callback',@calc_text);
        
        drawnow
    end

    function which_gantt(source,callbackdata)
        val = source.Value;
        if(val == 1)
            %             disp('Closed Loop Gantt Chart')
            Gantt_Flag = 1;
        else
            %             disp('Open Loop Gantt Chart')
            Gantt_Flag = 2;
        end
        MakeGantt(slider_val,Gantt_Flag,openloop_unit_number);
    end

    function calc(source,callbackdata)
        val = round(source.Value);
        MakeGantt(val,Gantt_Flag,openloop_unit_number);
    end

    function calc_text(source,callbackdata)
        source.Value=round(str2double(source.String));
        calc(source);
    end

    function OpenLoopUnitNumber(source,callbackdata)
        Gantt_Flag = 2;
        MakeGantt(slider_val,Gantt_Flag,str2num(source.String));
    end

end
