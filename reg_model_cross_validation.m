clc
clearvars
close all
%% Set data
%read an excel file with observations on the rows, predictors on the first
%columns and the response variable on the last column. Include name of the
%parameters in the first row
% [num,txt,raw]=xlsread('C:\Users\SoNoN\Google Drive\hermitage\lavori\SLA\FP\new\FP_SLA_NEW.xlsx','regdata');
[num,txt,raw]=xlsread('G:\MEG\SLA_metabolomica\SLA_valanghe\Manoscritto SLA valanghe\Neurology\REBUTTAL\modelli_predittivi_con_fenotipi_e_ECAS.xlsx','MiToS_theta','C1:J43');

%code path
cdbase='G:\MEG\SLA_metabolomica\SLA_valanghe\valanghe_SLA_codici_e_risultati';
cd(cdbase)

%choose the name for the folder
savef='K_fold_phenotype_ECAS';

%choose the name for the saved files
savename='MiToS_theta';

%choose if save the results or not
saveme=1; %if saveme=1 it saves the results in the 'savef' folder, created in 'cdbase' path

%Leave one out OR kfold cross validation (not both)
loocv=0;
kfoldcv=1;

%number of kfolds (if chosen, or it doesn't matter)
kfoldsN=5; 
%% Create a table
tabdata = array2table(num);
tabdata.Properties.VariableNames=txt;

% remover (optional)
% tabdata(:,[1])=[]; %remove param
% tabdata([6],:)=[]; %remove subj

%% set the names of the variables
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
ylim([0,0.6])
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
minx=min(min([y Stats_aux.yhat]));
maxx=max(max([y Stats_aux.yhat]));
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
% h=refline(1,0);
% set(h,'Color','k')
xlabel(['Predicted ' responsevar_name ' value'])
ylabel('Standardized residuals')


y_sogg=zeros(size(y))';
s_sogg=zeros(size(y));
r2_sogg=zeros(size(y))';
pval_sogg=zeros(size(x,2)+1,size(y,1));

if loocv==1
% leave one out analysis
disp('leave one out analysis')

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
% pval_log=pval_sogg<0.05;

elseif kfoldcv==1
    %for kfold
    n_subj=size(num,1);
    numy=round(n_subj/kfoldsN);
    numy2=n_subj/kfoldsN;
    if numy>numy2
        numy=numy-1;
    end
    resto=rem(n_subj,kfoldsN);
    grnumy=zeros(1,kfoldsN+1);
    grnumy0=linspace(1,n_subj-resto-numy+1,kfoldsN);
    grnumy(1:end-1)=grnumy0;
    grnumy(end)=n_subj-resto;
    k=0;
    for zz3=1:resto
        grnumy(end-k)=grnumy(end-k)+resto-k;
        k=k+1;
    end
    %         diff(grnumy)
    randsubjn=randperm(n_subj);
    
    % kfold analysis
    for k=1:length(grnumy)-1
        y_sog=y;
        x_sog=x;
        if k~=length(grnumy)-1
            ksogg=randsubjn(grnumy(k):grnumy(k+1)-1);
        else
            ksogg=randsubjn(grnumy(k):grnumy(k+1));
        end
        y_sog(ksogg)=[];
        x_sog(ksogg,:)=[];
        
        Stats_aux_sogg = regstats(y_sog,x_sog,'linear');
        y_sogg(ksogg)=[ones(length(ksogg),1) x(ksogg,:)]*Stats_aux_sogg.beta;
        s_sogg(ksogg)=y(ksogg)-([ones(length(ksogg),1) x(ksogg,:)]*Stats_aux_sogg.beta);
        r2_sogg(ksogg)=Stats_aux_sogg.rsquare;
        pval_sogg(:,k)=Stats_aux_sogg.tstat.pval;
    end
end

subplot(2,3,5);
plot(y,y_sogg,'sr','MarkerSize',10,'MarkerFaceColor',[1 .6 .6])%[0.1 0.7 0.8])
title('Comparison between actual and predicted values with cross validation')
axis equal
minx=min(min([y y_sogg']));
maxx=max(max([y y_sogg']));
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
title('Residuals evaluation with cross validation')
% h=refline(1,0);
% set(h,'Color','k')
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

%Plot VIF
figure, plot(VIF,'ro')
if max(VIF) > 10
    ylim([-0.5 max(VIF)+0.5]);
else
    ylim([-0.5 10.5]);
end
% h=refline(5,0);
% set(h,'Color','k')
% h=refline(10,0);
% set(h,'Color','k')
%%
if saveme==1
mkdir(savef)
cd([cdbase '\' savef])
print(fig1,'-dtiff','-r600',savename)
save(savename,'Stats');
end
cd(cdbase)