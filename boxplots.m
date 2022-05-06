%% SET DATA (MODIFICARE)
close all
clearvars
clc

%Percorso codice
cdbase='F:\MEG\SLA_metabolomica\SLA_valanghe\Boxplots';

%Indicare le celle contenenti i dati (comprese le intestazioni nella prima
%riga). I valori devono stare sulla colonna, mentre sogg e gruppi sulle righe
[par,parnames,~]=xlsread('F:\MEG\SLA_metabolomica\SLA_valanghe\Boxplots\data_suppl_mat_no_out.XLSX','thresholds','F1:F85');

%numero di gruppi (2 o 3)
numgroups=2;

%Indicare la numerosità di ogni gruppo (se manca inserire [])
gr1=42;
gr2=42;
gr3=[];
gr4=[];
gr5=[];

%Nomi dei gruppi - se manca inserire []
ngr1='HC';
ngr2='SLA';
ngr3=[];
ngr4=[];%non testato a 4 gruppi
ngr5=[];%non testato a 5 gruppi

%Bianco e nero? Supportato solo per 2 e 3 gruppi
ben=0; %0=colori | 1=bianco e nero

%Nome del file da salvare
savename='Theta_th2';

%%% PER I COLORI VEDI RIGO 91 %%%

cd(cdbase)
mkdir('images')
%% Plotting
allgrdim=[gr1,gr2,gr3,gr4,gr5];
k=0;
j=0;
grtotmat=nan(max(allgrdim),numgroups);
for zz1=1:numgroups
    grtotmat(1:allgrdim(zz1),zz1)=par(1+k:gr1+j,1);
    if zz1==1
        k=k+gr1;
        j=j+gr2;
    elseif zz1==2
        k=k+gr2;
        j=j+gr3;
    end
end

% h_1=boxplotnew(grtotmat,numgroups);
h_1=graphplot(grtotmat,numgroups);

%Scelta elementi da visualizzare
for zz1=1:size(h_1,2)
    h_1(1,zz1).ViolinPlot.Visible='off';
    h_1(1,zz1).ScatterPlot.Visible='on';
    h_1(1,zz1).MeanPlot.Visible='on'; %in realtà è anche questo la mediana
    h_1(1,zz1).WhiskerPlot.Visible='on';
    h_1(1,zz1).MedianPlot.Visible='off';
    alphabaff=0.5;
    bafsux=h_1(1,zz1).WhiskerPlot.XData;
    bafsuy=[h_1(1,zz1).BoxPlot.YData(1,1),h_1(1,zz1).WhiskerPlot.YData(1,1),];
    patch(bafsux,bafsuy,'black','EdgeAlpha',alphabaff);
    bafhorx1=[h_1(1,zz1).WhiskerPlot.XData(1,1)+0.1,h_1(1,zz1).WhiskerPlot.XData(1,1)-0.1];
    bafhory1=[h_1(1,zz1).WhiskerPlot.YData(1,1),h_1(1,zz1).WhiskerPlot.YData(1,1)];
    patch(bafhorx1,bafhory1,'black','EdgeAlpha',alphabaff);
    bafgiux=h_1(1,zz1).WhiskerPlot.XData;
    bafgiuy=[h_1(1,zz1).BoxPlot.YData(3,1),h_1(1,zz1).WhiskerPlot.YData(1,2)];
    patch(bafgiux,bafgiuy,'black','EdgeAlpha',alphabaff);
    bafhorx2=[h_1(1,zz1).WhiskerPlot.XData(1,1)+0.1,h_1(1,zz1).WhiskerPlot.XData(1,1)-0.1];
    bafhory2=[h_1(1,zz1).WhiskerPlot.YData(1,2),h_1(1,zz1).WhiskerPlot.YData(1,2)];
    patch(bafhorx2,bafhory2,'black','EdgeAlpha',alphabaff);
    h_1(1,zz1).WhiskerPlot.Visible='off';
    k=1;
    for zz2=1:size(h_1(1,zz1).ScatterPlot.YData,2)
        if h_1(1,zz1).ScatterPlot.YData(1,zz2)>=h_1(1,zz1).WhiskerPlot.YData(1,1) && h_1(1,zz1).ScatterPlot.YData(1,zz2)<=h_1(1,zz1).WhiskerPlot.YData(1,2)
            scatdel(1,k)=zz2;
            k=k+1;
        end
    end
    h_1(1,zz1).ScatterPlot.YData(scatdel)=[];
    h_1(1,zz1).ScatterPlot.XData(scatdel)=[];
    scatdel=[];
end

%GESTIONE COLORI
col1=[0.1 0.7 0.8];	%AZZURRO
col2=[1 0.2 0.2]; %ROSSO [0.9 0.3 0]; %ARANCIONE
col3=[0.8 0.5 0.1]; %GIALLO
col4=[0.5 0.5 0.8]; %VIOLA
col5=[0.4 0.6 0.2]; %VERDE
tavolozza{1}=col1;
tavolozza{2}=[col1;col2;col1;col2;col1;col2;col1;col2;col1;col2];
tavolozza{3}=[col1;col2;col3;col1;col2;col3;col1;col2;col3];
tavolozza{4}=[col1;col2;col3;col4;col1;col2;col3;col4];
tavolozza{5}=[col1;col2;col3;col4;col5;col1;col2;col3;col4;col5];

bn1=[0.9 0.9 0.9]; %NERO
bn2=[0.0 0.0 0.0]; %BIANCO
bn3=[0.5 0.5 0.5]; %GRIGIO
tavbn{2}=[bn1;bn2;bn1;bn2;bn1;bn2;bn1;bn2;bn1;bn2];
tavbn{3}=[bn1;bn2;bn3;bn1;bn2;bn3;bn1;bn2;bn3];
revtavbn{2}=[bn2;bn1;bn2;bn1;bn2;bn1;bn2;bn1;bn2;bn1];
revtavbn{3}=[bn3;bn2;bn1;bn3;bn2;bn1;bn3;bn2;bn1];

for zz1=1:size(h_1,2)
    if ben==0
        h_1(1,zz1).MeanPlot.Color=tavolozza{numgroups}(zz1,:);
        h_1(1,zz1).ScatterPlot.MarkerFaceColor=tavolozza{numgroups}(zz1,:);
        h_1(1,zz1).ScatterPlot.MarkerFaceAlpha=0.4;
        h_1(1,zz1).BoxPlot.FaceColor=tavolozza{numgroups}(zz1,:);
        h_1(1,zz1).BoxPlot.EdgeAlpha=1; %solitamente 0
        h_1(1,zz1).BoxPlot.EdgeColor=[0,0,0]; %solitamente 0
        h_1(1,zz1).BoxPlot.FaceAlpha=0.4; %solitamente 0.4
    else
        %in caso di bianco e nero
        h_1(1,zz1).MeanPlot.Color=tavbn{numgroups}(zz1,:);
        h_1(1,zz1).ScatterPlot.MarkerFaceColor=revtavbn{numgroups}(zz1,:);
        h_1(1,zz1).ScatterPlot.MarkerFaceAlpha=0.6;
        h_1(1,zz1).ScatterPlot.MarkerEdgeColor=[0 0 0];
        h_1(1,zz1).BoxPlot.EdgeAlpha=0.6; %solitamente 0
        h_1(1,zz1).BoxPlot.FaceAlpha=0.6; %solitamente 0.4
        h_1(1,zz1).BoxPlot.FaceColor=revtavbn{numgroups}(zz1,:);
        h_1(1,zz1).WhiskerPlot.Color=revtavbn{numgroups}(zz1,:);
        h_1(1,zz1).MeanPlot.Color=[0,0,0];
        h_1(1,zz1).BoxPlot.EdgeColor=[0,0,0];
    end
end

%DETTAGLI
yticklabels();
axis([]);

% if numpar==1
title(parnames(1,1),'FontWeight','Normal');
axis square %Squadra gli assi
nxticks=linspace(h_1(1,1).WhiskerPlot.XData(1,1),h_1(1,size(h_1,2)).WhiskerPlot.XData(1,1),size(h_1,2));
xticks(nxticks);
xticklabels({ngr1,ngr2,ngr3,ngr4,ngr5});


fig = gcf;
fig.InvertHardcopy = 'off';

minval=min(min(grtotmat,[],'omitnan'));
maxval=max(max(grtotmat,[],'omitnan'));
ylimdata=[minval-(abs(minval-maxval)/10) maxval+(abs(minval-maxval)/3)];
ylim(ylimdata);
xlimdata=[0.5 h_1(1,size(h_1,2)).WhiskerPlot.XData(1,1)+0.15+0.35];
xlim(xlimdata);
set(gcf,'color','w');
%Crea una linea orizzontale sullo 0 se tutti i valori sono al di sotto
%dello zero
if minval(1,1) && maxval(1,1)<0
    hline = refline(0, 0);
    hline.Color = 'k';
end

%% Legend adn stuff

if minval>0
    ylimdata=[minval-(abs(minval-maxval)/10) maxval+(abs(minval-maxval)/4)];
    if ylimdata(1,1)<0
        ylimdata(1,1)=0;
    end
else
    ylimdata=[minval-(abs(minval-maxval)/10) maxval+(abs(minval-maxval)/4)];
end
ylim(ylimdata);

%% Save plot
cd([cdbase '\images'])
print('-dtiff','-r600',savename)
saveas(fig,[savename '.svg']);
cd(cdbase)

