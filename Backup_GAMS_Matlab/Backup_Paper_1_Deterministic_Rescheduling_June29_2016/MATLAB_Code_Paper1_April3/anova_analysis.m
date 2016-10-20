% Analyze Anova results from collect results

% data_store = cell(4,2,3,3,3);
% p_value = cell(4,2,3,3,3); %"plot_MH_RF_OPT_Greedy(1-4);plot_cost_profit(1-2);DF(1-3);DL(1-3);(RF1-3 or MH1-3 or RF1-3) within a subplot"
% tbl = cell(4,2,3,3,3);
% stats = cell(4,2,3,3,3);
clc
load Data\ANOVA\N2_p_value
% load Data\ANOVA\N2_data_store
% load Data\ANOVA\N1_p_value

N_factors_each_subplot=3;
% for plot_MH_RF_OPT_Greedy = [2 1 3 4]
for plot_MH_RF_OPT_Greedy = [2 1 3]

%     for plot_MH_RF_OPT_Greedy = [4]
    if plot_MH_RF_OPT_Greedy < 3
        plot_cost_profit_values = [1:2];
    else
        plot_cost_profit_values = [2];
    end
        for plot_cost_profit = plot_cost_profit_values
        
        if plot_cost_profit == 1
            dl_upper=3;
        else
            dl_upper=1;
        end
        
        table = zeros(N_factors_each_subplot*dl_upper,N_factors_each_subplot);
        
        for df=1:3
            for dl=1:dl_upper
                for index=1:N_factors_each_subplot
                    table(index + N_factors_each_subplot*(dl-1),df)=p_value{plot_MH_RF_OPT_Greedy,plot_cost_profit,df,dl,index}(1);
                    data_store{plot_MH_RF_OPT_Greedy,plot_cost_profit,df,dl,index};
                    [l,m]=size(data_store{plot_MH_RF_OPT_Greedy,plot_cost_profit,df,dl,index});
                    for i=1:m
%                         [h,p] = lillietest(data_store{plot_MH_RF_OPT_Greedy,plot_cost_profit,df,dl,index}(1:l,i));
                        if h ~=1
%                             p
                        end
                    end
                end
            end
        end
        if plot_MH_RF_OPT_Greedy==1
            disp('MH')
        elseif plot_MH_RF_OPT_Greedy==2
            disp('RF')
        elseif plot_MH_RF_OPT_Greedy==3
            disp('OPT')
        end
        
        if plot_cost_profit == 1
            disp('Cost')
        elseif plot_cost_profit == 2
            disp('Profit')
        end
        
        input.data=table
        latex = latexTable(input);
    end
end


% for plot_MH_RF_OPT_Greedy = 1:3
%     for plot_cost_profit = 1:2
%         for df=1:3
%             if plot_cost_profit == 1
%                 dl_upper=3;
%             else
%                 dl_upper=1;
%             end
%             for dl=1:dl_upper
%                 for index=1:3
%                     p_value{plot_MH_RF_OPT_Greedy,plot_cost_profit,df,dl,index}(1);
%
%                 end
%             end
%         end
%     end
% end
