clear
clc

OPT = [0:2.5:10];
MH ={24};
N=2;
DF={3,6,12};
MC=10; %Aggregates data from MC1 to 10
RF=3;

append_data=[];
Obj = 'Cost';
DL={[3 4 5];
    [6 8 10];
    [12 16 20]};
for df=1:length(DF)
    for dl=1:length(DL{df})
        load([pwd,'\DATA\OPT\N',num2str(N),'_OPT_',Obj,'_DF',num2str(DF{df}),...
            '_DL',num2str(DL{df}(dl)),'_MC'],'save_data_MC');
        for rf=1:RF
            for mc=1:MC
                save_data_MC(rf,:,mc)=save_data_MC(rf,:,mc)/save_data_MC(rf,1,mc); %rf,optcr,mc
            end
        end
        save_data=mean(save_data_MC,3);
        append_data=[append_data;save_data(:,1:end)];
    end
end
append_data

CL_Cost=(mean(append_data,1)-1)*100

load([pwd,'\DATA\IntGap_',Obj,'_MH',num2str(MH{1})],'IntGap');
load([pwd,'\DATA\TrueGap_',Obj,'_MH',num2str(MH{1})],'TrueGap');
load([pwd,'\DATA\EstGap_',Obj,'_MH',num2str(MH{1})],'EstGap');
IntGap_Cost = (1-IntGap)*100
TrueGap_Cost = TrueGap'*100
EstGap_Cost = EstGap'*100

append_data=[];
Obj = 'Profit';
DL={3,6,12};
for df=1:length(DF)
    for dl=1:length(DL{df})
        load([pwd,'\DATA\OPT\N',num2str(N),'_OPT_',Obj,'_DF',num2str(DF{df}),...
            '_DL',num2str(DL{df}(dl)),'_MC'],'save_data_MC');
        for rf=1:RF
            for mc=1:MC
                save_data_MC(rf,:,mc)=save_data_MC(rf,:,mc)/save_data_MC(rf,1,mc); %rf,optcr,mc
            end
        end
        save_data=mean(save_data_MC,3);
        append_data=[append_data;save_data(:,1:end)];
    end
end
append_data
CL_Profit=(mean(append_data,1)-1)*100

load([pwd,'\DATA\IntGap_',Obj,'_MH',num2str(MH{1})],'IntGap');
load([pwd,'\DATA\TrueGap_',Obj,'_MH',num2str(MH{1})],'TrueGap');
load([pwd,'\DATA\EstGap_',Obj,'_MH',num2str(MH{1})],'EstGap');
IntGap_Profit = (1-IntGap)*100
TrueGap_Profit = TrueGap'*100
EstGap_Profit = EstGap'*100

figure(901)

subplot(1,2,1);
plot(OPT,EstGap_Cost,'-bs')
hold on
plot(OPT,TrueGap_Cost,'-ro')
plot(OPT,CL_Cost,'-g^')
% title(['A']);
title('Cost','FontWeight','Normal');
xlabel('OPTCR (%)');
% ylabel('Gap (%)')
ylabel('Percent (%)')
legend({'Est. Gap','True Gap','CL Det.'},'Location','NorthWest')
set(gca,'YLim',[0 10],'XTick',OPT,'YTick',[0:2.5:10],'YMinorTick','on','FontSize',12);
grid on
box on

subplot(1,2,2);
plot(OPT,EstGap_Profit,'-bs')
hold on
plot(OPT,abs(TrueGap_Profit),'-ro')
plot(OPT,abs(CL_Profit),'-g^')
% title(['B']);
title('Profit','FontWeight','Normal');
xlabel('OPTCR (%)');
% ylabel('Gap (%)')
ylabel('Percent (%)')
% legend({'Est Gap','True Gap','CL Gap'},'Location','NorthWest')
legend({'Est. Gap','True Gap','CL Det.'},'Location','NorthWest')
set(gca,'YLim',[0 5],'XTick',OPT,'YTick',[0:5],'YMinorTick','on','FontSize',12);
grid on
box on


if strcmp(Obj,'Cost')
    w=8.5;h=6;p=0.01;
elseif strcmp(Obj,'Profit')
    w=8.5;h=2.25;p=0.01;
end
set(gcf,...
    'Units','inches',...
    'Position',[1 1 w h],...
    'PaperUnits','inches',...
    'PaperPosition',[p*w p*h w h],...
    'PaperSize',[w*(1+2*p) h*(1+2*p)]);
print([pwd,'\PLOTS\','Gap'],'-dpdf')

