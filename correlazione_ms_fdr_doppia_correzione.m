%da modificare rigo 7,8,9
clearvars
clc
%%
clc
file = uigetfile('*.xlsx');
[dati,~, ~] = xlsread(file,'Theta_ECAS','B2:C43'); 
[~, parametri,~] = xlsread(file,'Theta_ECAS','B1:C1');
par_clinici = 1 %7 %numero test clinici 

%%
clc
[righe,colonne] = size(dati);
parametri_riga = parametri';
parametri_colonna = parametri;
par_meg=colonne-par_clinici;

%%
clc
clear coppie p_non_corr
[rho,pvalue] = corr(dati);
k=1;
kk=1;
for i=1:par_clinici%colonne
    kk=1;
    for j=(par_clinici+1):colonne
        p_non_corr(i,kk)=pvalue(i,j);
        rho_non_corr(i,kk)=rho(i,j);
        kk=kk+1;
    end
end

%% nuova correzione
clear p_corr2 p_conc
clc
xx=1;
for i=1:par_clinici%colonne
    p_conc(1,xx:xx+par_meg-1) = p_non_corr(i,1:par_meg);
    xx=xx+par_meg;
end


p_corr2=mafdr(p_conc,'bhfdr','true');

xx=1;
for i=1:par_meg:(par_clinici*par_meg)
    p_corr(xx,(1:par_meg))=p_corr2(1,(i:i+par_meg-1));
    xx=xx+1;
end


%%
clear p_corr_ori
clc
for i=1:par_clinici%colonne
    p_corr_ori(i,1:par_meg) = mafdr(p_non_corr(i,1:par_meg),'bhfdr','true');
end
%% 
clear coppie
coppie=[];
k=1;
for i=1:par_clinici %colonne
    for j=(par_clinici+1):colonne
        if pvalue(i,j)<=0.05
            coppie{k,1}=parametri_riga{i};
            coppie{k,2}=parametri_colonna{j};
            coppie{k,3}=rho(i,j);
            coppie{k,4}=pvalue(i,j);
            coppie{k,5}=p_corr(i,j-par_clinici);
            
            coppie{k,7}=p_corr_ori(i,j-par_clinici);
            k=k+1;
        end

    end
end
%% 

titolo={'Parametro 1','Parametro 2','Rho','p-non corr','p-corr su tutti i parametri','','p-corr per parametro clinico'};
clc
risultati = strcat(file(1:end-5),'_risultati_correlazione_con_tutti_parametri.xlsx');

if isempty(coppie)==0
    xlswrite(risultati,titolo,'risultati','A1');
    xlswrite(risultati,coppie,'risultati','A2');
end

xlswrite(risultati,rho_non_corr,'Rho','B2');
xlswrite(risultati,parametri_riga(1:par_clinici),'Rho','A2');
xlswrite(risultati,parametri_colonna(par_clinici+1:par_clinici+par_meg),'Rho','B1');

xlswrite(risultati,p_non_corr,'p_non_corr','B2');
xlswrite(risultati,parametri_riga(1:par_clinici),'p_non_corr','A2');
xlswrite(risultati,parametri_colonna(par_clinici+1:par_clinici+par_meg),'p_non_corr','B1');

xlswrite(risultati,p_corr,'p_corr','B2');
xlswrite(risultati,parametri_riga(1:par_clinici),'p_corr','A2');
xlswrite(risultati,parametri_colonna(par_clinici+1:par_clinici+par_meg),'p_corr','B1');

xlswrite(risultati,p_corr_ori,'p_corr_per_parametro_clinico','B2');
xlswrite(risultati,parametri_riga(1:par_clinici),'p_corr_per_parametro_clinico','A2');
xlswrite(risultati,parametri_colonna(par_clinici+1:par_clinici+par_meg),'p_corr_per_parametro_clinico','B1');

clc
