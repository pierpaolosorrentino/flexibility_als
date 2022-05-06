%% Seleziona il bin e fai run and advance
clearvars, clc, close all
chosenbin=1; %Scegli il bin!

%% caricare nel workspace i file gruppoxtx_total.mat dei due gruppi
%SCORRI TUTTO IL CODICE FACENDO RUN AND ADVANCE

%% Set paths
pathbase1 = matlab.desktop.editor.getActiveFilename;
pathbase2 = fliplr(pathbase1);
for zz1 = 1:size(pathbase2,2)
    if pathbase2(1) ~= '\' & '/' %#ok<*AND2>
        pathbase2(1) = [];
    else
        break
    end
end
pathbase = fliplr(pathbase2);
mkdir('savefinalresults')
pathsave = [pathbase 'savefinalresults\'];
pathdata = [pathbase 'savedfiles_1\'];

clear pathbase1 pathbase2

%% Load data
cd(pathdata)

dataset = dir('*total.mat'); %oppure *serie.mat
data1 = load(dataset(1).name);
data2 = load(dataset(2).name);

fname1 = char(fieldnames(data1));
dname1 = 'data1.';
% ntoeval1 = append(dname1,fname1);
ntoeval1 = [dname1,fname1];
fname2 = char(fieldnames(data2));
dname2 = 'data2.';
% ntoeval2 = append(dname2,fname2);
ntoeval2 = [dname2,fname2];

eval(['data1 = ' ntoeval1 ';']);
eval(['data2 = ' ntoeval2 ';']);

data1 = data1{chosenbin};
data2 = data2{chosenbin};

clearvars -except data1 data2 pathbase pathsave pathdata
%% Statistics
cd(pathbase)
p = zeros(size(data1,2),size(data1{1},2));

for zz1 = 1:size(data1,2) %loop on bands
   for zz2 = 1:size(data1{zz1},2) %loop parameters
       p(zz1,zz2) = permtest(data1{zz1}(:,zz2),data2{zz1}(:,zz2),10000);
   end
end

%% Save
cd(pathdata)
datanames = dir('*subjnames.mat'); %oppure *serie.mat
name1 = load(datanames(1).name);
name2 = load(datanames(2).name);
fname1 = char(fieldnames(name1));
dname1 = 'name1.';
% ntoeval1 = append(dname1,fname1);
ntoeval1 = [dname1,fname1];
fname2 = char(fieldnames(name2));
dname2 = 'name2.';
% ntoeval2 = append(dname2,fname2);
ntoeval2 = [dname2,fname2];

eval(['soggnames1 = ' ntoeval1 ';']);
eval(['soggnames2 = ' ntoeval2 ';']);

cd(pathsave)
xlswrite('results.xlsx',{'Delta', 'Theta', 'Alpha', 'Beta', 'Gamma', 'Broadband'}','Foglio1','A2')
xlswrite('results.xlsx',{'Pattern, Switch, Bool distances'},'Foglio1','B1')
xlswrite('results.xlsx',p,'Foglio1','B2')

xlswrite('results.xlsx',soggnames1','DataCtrl','A2')
xlswrite('results.xlsx',{'Delta Pattern', 'Delta Switch', 'Delta Booldist', 'Theta Pattern', 'Theta Switch', 'Theta Booldist', 'Alpha Pattern', 'Alpha Switch', 'Alpha Booldist', 'Beta Pattern', 'Beta Switch', 'Beta Booldist', 'Gamma Pattern', 'Gamma Switch', 'Gamma Booldist', 'BB Pattern', 'BB Switch', 'BB Booldist'},'DataCtrl','B1')
xlswrite('results.xlsx',cell2mat(data1),'DataCtrl','B2')

xlswrite('results.xlsx',soggnames2','DataPZ','A2')
xlswrite('results.xlsx',{'Delta Pattern', 'Delta Switch', 'Delta Booldist', 'Theta Pattern', 'Theta Switch', 'Theta Booldist', 'Alpha Pattern', 'Alpha Switch', 'Alpha Booldist', 'Beta Pattern', 'Beta Switch', 'Beta Booldist', 'Gamma Pattern', 'Gamma Switch', 'Gamma Booldist', 'BB Pattern', 'BB Switch', 'BB Booldist'},'DataPZ','B1')
xlswrite('results.xlsx',cell2mat(data2),'DataPZ','B2')

cd(pathbase)

