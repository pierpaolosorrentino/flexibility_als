clearvars
close all
clc
%Percorso del codice - in questo percorso verrà creata la cartella images
%che conterrà le immagini delle correlazioni
cdbase='F:\MEG\SLA_metabolomica\SLA_valanghe\Correlazioni';

%è il titolo del grafico. Ci puoi mettere un nome, la significatività, la R, la banda
titlegraph='Theta band';

%Parametro 1 - indicare la colonna di dati compresa di intestazione
[par1,par1title,~]=xlsread('F:\MEG\SLA_metabolomica\SLA_valanghe\Correlazioni\Grafici_correlazioni.xlsx','Theta_MiToS','A1:A43');
% par1([18,55],:)=[];
%Parametro 2 - indicare la colonna di dati compresa di intestazione
[par2,par2title,~]=xlsread('F:\MEG\SLA_metabolomica\SLA_valanghe\Correlazioni\Grafici_correlazioni.xlsx','Theta_MiToS','B1:B43');
% par2([18,55],:)=[];
%Nome del grafico
savename='Theta_MiToS';

%Metti 1 per bianco e nero, metti 0 per colori
ben=0;

%ORA FAI RUN
%% NON TOCCARE

    minval1=min(par1);
    maxval1=max(par1);
    minval2=min(par2);
    maxval2=max(par2);
    
    figure('Name','temp','NumberTitle','off');
    scatter(par1,par2);
    xlimdata0=[minval1-abs(maxval1-minval1) maxval1+abs(maxval1-minval1)];
    ylimdata0=[minval2-abs(maxval2-minval2) maxval2+abs(maxval2-minval2)];
    ylim(ylimdata0);
    xlim(xlimdata0);
    
    h=refline;
    h1=[h.XData(1,1),h.XData(1,2)] ;
    h2=[h.YData(1,1),h.YData(1,2)];
    close temp
    
    
    sz=80;
    %nexttile
    if ben==1
    graphz.a=scatter(par1,par2,sz,'filled','o',...
        'MarkerEdgeColor',[0.1 .1 .1],...
        'MarkerEdgeAlpha',0.5,...
        'MarkerFaceColor',[0.5,0.5,0.5],...%azzurro=[0.1 0.7 0.8],...grey=[0.5,0.5,0.5]
        'MarkerFaceAlpha',1,...
        'LineWidth',0.5);
    else
            graphz.a=scatter(par1,par2,sz,'filled','o',...
        'MarkerEdgeColor',[.1 .1 .1],...
        'MarkerEdgeAlpha',1,...
        'MarkerFaceColor',[0.8 0.1 0.1],...%azzurro=[0.1 0.7 0.8],...grey=[0.5,0.5,0.5] % red 0.8 0.1 0.1
        'MarkerFaceAlpha',0.5,...
        'LineWidth',0.5);
    end
    line(h1,h2,'Color','black')
    
    
%     legend([graphz.a,graphz.b,graphz.c],{'HC','PDoff','PDon'},'Location','north','Orientation','horizontal');
%     legend('M and F');
    
    title(titlegraph,'FontSize',13); %Aggiunge il nome del parametro
    xlabel(par1title)
    ylabel(par2title)
    
    xlimdata0=[minval1-abs(maxval1-minval1)/7 maxval1+abs(maxval1-minval1)/7];
    ylimdata0=[minval2-abs(maxval2-minval2)/7 maxval2+abs(maxval2-minval2)/7];
    
    ylim(ylimdata0);
    xlim(xlimdata0);
    
    axis square
%% Save plot (non toccare)
% formato tiff, risoluzione 600
cd(cdbase)
mkdir('images')
cd([cdbase '\images'])
print('-dtiff','-r600',savename)

cd(cdbase)