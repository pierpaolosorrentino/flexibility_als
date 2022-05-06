clc
clearvars
close all
%% create a table
%load a table with observations on the rows, predictors on the first
%columns and the response variable on the last column
[num,txt,raw]=xlsread('C:\Users\emahn\Google Drive\hermitage\lavori\pd_fingerprint\meg_fingerprint\protocolli PD TESS-CAR.xlsx','regdata');

%code path
cdbase='C:\Users\SoNoN\Google Drive\hermitage\matlab\codici_vari\altro';
cd(cdbase)

savename='pred1';

%savefolder
savef='savename';

saveme=1; %if saveme=1 it saves the results in the 'savef' folder, created in 'cdbase' path

%%
tabdata = array2table(num);
tabdata.Properties.VariableNames=txt;
%% remover
% tabdata(:,[6])=[]; %remove param
% tabdata([5,15,16,33],:)=[]; %remove subj

%%
%set the names of the variables
predictors_name=tabdata.Properties.VariableNames(1:end-1);
responsevar_name=tabdata.Properties.VariableNames{end};

y=table2array(tabdata(:,end)); %takes the RESPONSE variable
x=table2array(tabdata(:,1:end-1)); %takes the predictors




%% Collinearity through VIF (Variance inflation factor)
%VIFs (usually calculated through regression among predictors) are also the diagonal elements of the inverse of the correlation matrix [1], a convenient result that eliminates the need to set up the various regressions
%[1] Belsley, D. A., E. Kuh, and R. E. Welsch. Regression Diagnostics. Hoboken, NJ: John Wiley & Sons, 1980.
R0 = corrcoef(x); % correlation matrix
VIF=diag(inv(R0))'; %cutoff at 5 or 10


%% Step by step model
rsquare=zeros(1,size(x,2));
for zz1=1:size(x,2)
    stats=regstats(y,x(:,1:zz1));
    rsquare(zz1)=stats.rsquare;
    clearvars stats
end

fig1=figure;
subplot(2,3,1);
bar(rsquare)
ylim([0,1])
axis square
title('R squared of predictors in step addition')
ylabel(['Explained ' responsevar_name ' variance (R2)'])
xticklabels(predictors_name);
xtickangle(45)

% Complete model
Stats_aux = regstats(y,x,'linear');

subplot(2,3,2);
plot(y,Stats_aux.yhat,'sr','MarkerSize',10,'MarkerFaceColor',[1 .6 .6]);
title('Comparison between actual and predicted values')
axis equal
minx=min([y Stats_aux.yhat],[],'all');
maxx=max([y Stats_aux.yhat],[],'all');
xlim([minx+minx*.1,maxx+maxx*.1]);
ylim([minx+minx*.1,maxx+maxx*.1]);

h=refline(1,0);
set(h,'Color','k')
xlabel(['Actual ' responsevar_name ' values'])
ylabel(['Predicted ' responsevar_name ' values'])

stdres=(y-Stats_aux.yhat)/std(y-Stats_aux.yhat);

subplot(2,3,3);
plot(stdres,'.k','MarkerSize',10), grid
axis square
title('Residuals evaluation in the complete model')
yline(0,'--k');
xlabel(['Predicted ' responsevar_name ' value'])
ylabel('Standardized residuals')

% leave one out analysis
disp('leave one out analysis')

y_sogg=zeros(size(y))';
s_sogg=zeros(size(y));
r2_sogg=zeros(size(y))';
pval_sogg=zeros(size(x,2)+1,size(y,1));
for k=1:length(y)
    y_sog=y;
    x_sog=x;
    y_sog(k)=[];
    x_sog(k,:)=[];
    
    Stats_aux_sogg = regstats(y_sog,x_sog,'linear');
    y_sogg(k)=[1 x(k,:)]*Stats_aux_sogg.beta;
    s_sogg(k)=y(k)-([1 x(k,:)]*Stats_aux_sogg.beta);
    r2_sogg(k)=Stats_aux_sogg.rsquare;
    pval_sogg(:,k)=Stats_aux_sogg.tstat.pval;
end
pval_log=pval_sogg<0.05;

subplot(2,3,5);
plot(y,y_sogg,'sr','MarkerSize',10,'MarkerFaceColor',[1 .6 .6])%[0.1 0.7 0.8])
title('Comparison between actual and predicted values with LOOCV')
axis equal
minx=min([y y_sogg'],[],'all');
maxx=max([y y_sogg'],[],'all');
xlim([minx+minx*.1,maxx+maxx*.1]);
ylim([minx+minx*.1,maxx+maxx*.1]);
h=refline(1,0);
set(h,'Color','k')
xlabel(['Actual ' responsevar_name ' values'])
ylabel(['Predicted ' responsevar_name ' values'])

standres_sogg=s_sogg/std(s_sogg);

subplot(2,3,6);
plot(standres_sogg,'.k','MarkerSize',10), grid
axis square
title('Residuals evaluation with LOOCV')
yline(0,'--k');
xlabel(['Predicted ' responsevar_name ' value'])
ylabel('Standardized residuals')

%Save the results in the Stats structure
% Note: regstats add intercept (i.e. column of 1) by default
Stats.R2 = Stats_aux.rsquare;
Stats.AdjR2=Stats_aux.adjrsquare;
Stats.pval(:,1) = predictors_name';
Stats.pval(:,2) = num2cell(Stats_aux.tstat.pval(2:end));
Stats.beta(:,1) = predictors_name';
Stats.beta(:,2) = num2cell(Stats_aux.beta(2:end));
Stats.yhat = Stats_aux.yhat;
Stats.stdres = stdres;
Stats.stdres_loocv = standres_sogg;
Stats.VIF(:,1) = predictors_name';
Stats.VIF(:,2) = num2cell(VIF');

subplot(2,3,4);
fs=9;
title('Data')
text(0.05,0.9,'R2','FontSize',fs,'VerticalAlignment','top')
text(0.4,0.9,num2str(Stats.R2),'FontSize',fs,'VerticalAlignment','top')
text(0.05,0.85,'AdjR2','FontSize',fs,'VerticalAlignment','top')
text(0.4,0.85,num2str(Stats.AdjR2),'FontSize',fs,'VerticalAlignment','top')
text(0.4,0.7,'p','FontSize',fs,'VerticalAlignment','top')
text(0.7,0.7,'β','FontSize',fs,'VerticalAlignment','top')
text(0.05,0.6,Stats.pval(:,1),'FontSize',fs,'VerticalAlignment','top')
text(0.4,0.6,Stats.pval(:,2),'FontSize',fs,'VerticalAlignment','top')
text(0.7,0.6,Stats.beta(:,2),'FontSize',fs,'VerticalAlignment','top')
axis square
set(gca,'xticklabel',{[]},'yticklabel',{[]})

x0=10;
y0=10;
width=1500;
height=800;
set(gcf,'position',[x0,y0,width,height])
%%
if saveme==1
mkdir(savef)
cd([cdbase '\' savef])
print(fig1,'-dtiff','-r600',savename)
save(savename,'Stats');
end
cd(cdbase)