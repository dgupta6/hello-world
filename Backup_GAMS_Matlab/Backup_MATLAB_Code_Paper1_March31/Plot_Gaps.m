clear
clc

OPT = [0:2.5:10];
MH ={24};

Obj='Cost'
load([pwd,'\DATA\IntGap_',Obj,'_MH',num2str(MH{1})],'IntGap');
load([pwd,'\DATA\TrueGap_',Obj,'_MH',num2str(MH{1})],'TrueGap');
load([pwd,'\DATA\EstGap_',Obj,'_MH',num2str(MH{1})],'EstGap');
IntGap_Cost = (1-IntGap)*100
TrueGap_Cost = TrueGap*100
EstGap_Cost = EstGap*100

Obj='Profit'
load([pwd,'\DATA\IntGap_',Obj,'_MH',num2str(MH{1})],'IntGap');
load([pwd,'\DATA\TrueGap_',Obj,'_MH',num2str(MH{1})],'TrueGap');
load([pwd,'\DATA\EstGap_',Obj,'_MH',num2str(MH{1})],'EstGap');
IntGap_Profit = (1-IntGap)*100
TrueGap_Profit = TrueGap*100
EstGap_Profit = EstGap*100


figure(901)

subplot(1,2,1);
plot(OPT,TrueGap_Cost,'-sb')
hold on
plot(OPT,abs(TrueGap_Profit),'-r^')
title(['A']);
xlabel('OPTCR (%)');
ylabel('True Gap (%)')
legend({'Cost','Profit'},'Location','NorthWest')
set(gca,'XTick',OPT,'YMinorTick','on','FontSize',12);
grid on
box on

subplot(1,2,2);
plot(OPT,EstGap_Cost,'-bs')
hold on
plot(OPT,EstGap_Profit,'-r^')
title(['B']);
xlabel('OPTCR (%)');
ylabel('Est Gap (%)')
legend({'Cost','Profit'},'Location','NorthWest')
set(gca,'XTick',OPT,'YMinorTick','on','FontSize',12);
grid on
box on



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
print([pwd,'\PLOTS\','Gap'],'-dpdf')

