%Plot results of case study motivating example
fig_filename = 'algos_substudy_fig';

% XTickLabels = {'ALG1','ALG2','ALG3','ALG4','ALG5','ALG6','ALG7','ALG8','ALG9','ALG10'};
XTickLabels = {'1','2','3','4','5','6','7','8','9','10'};
CLProfitAbs = [3652 3849    3652	3847	3945	3949	3947	3948    3849    3947];
CLProfit = CLProfitAbs/CLProfitAbs(5)
YLims=[min(CLProfit)*0.9 max(CLProfit)*1.05];

bar(CLProfit)
set(gca,'XLim',[0.5 length(XTickLabels)+0.5],...
'XTick',[1:length(XTickLabels)],...
'XTickLabel',XTickLabels,'Fontsize',11,...
'YLim',YLims);
ylabel('Closed-loop Profit')
xlabel('ALG')



grid on

w=3.5;h=2.25;p=0.01;
set(gcf,...
    'Units','inches',...
    'Position',[1 1 w h],...
    'PaperUnits','inches',...
    'PaperPosition',[p*w p*h w h],...
    'PaperSize',[w*(1+2*p) h*(1+2*p)]);

print([pwd,'\PLOTS\',fig_filename],'-dpdf')
