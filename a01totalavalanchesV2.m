%% Dati da modificare manualmente
clearvars, clc, close all

%Aggiungere il percorso di un path per ogni gruppo
file_da_prendere={'F:\MEG\SLA_metabolomica\SLA_valanghe\valanghe_SLA_codici_e_risultati\CTRL_SLA\','F:\MEG\SLA_metabolomica\SLA_valanghe\valanghe_SLA_codici_e_risultati\SLA\'};

% file_da_prendere={'C:\Users\emahn\Google Drive\hermitage\matlab\meg\catena_MEG\data\4_serie_temporali\ORT1\','C:\Users\emahn\Google Drive\hermitage\matlab\meg\catena_MEG\data\4_serie_temporali\ORT2\','C:\Users\emahn\Google Drive\hermitage\matlab\meg\catena_MEG\data\4_serie_temporali\ORT3\'};

pathbase='F:\MEG\SLA_metabolomica\SLA_valanghe\valanghe_SLA_codici_e_risultati\';
pathsave=[pathbase 'savedfiles\']; %NON MODIFICARE

%Per namedata scegliere i nomi seguendo il numero del gruppo e il tempo
%del gruppo es. gruppo1t1 gruppo1t2 gruppo2t5 gruppo3t2
namedata={'gruppo1t1','gruppo2t1'};

%% Inizio
cd(pathbase);
mkdir savedfiles

categ = {'delta','theta','alpha','beta','gamma'};
freq_band={[0.5 4];[4 8];[8 13];[13 30];[30 48]};
fs=1024;

for yy = 1: size(file_da_prendere,2)
    A=dir(file_da_prendere{yy});
    A([1 2])=[];
    temp=cell(1,size(A,2));
    for kk=1:size(A,1)
        temp{kk} =  A(kk).name(1:8);
    end
    subjects=unique(temp);
    D=cell(1,size(subjects,2));
    for kk=1:size(subjects,2)
        pos=find(strcmp(subjects(kk),temp));
        B=load([file_da_prendere{yy} A(pos(1)).name]);
        B=B.dati_bf.trial';
        if length(pos)>1
            C=load([file_da_prendere{yy} A(pos(2)).name]);
            C=C.dati_bf.trial';
            %             D{kk}=[zscore(cell2mat(B.serie_temporali'),0,2) zscore(cell2mat(C.serie_temporali'),0,2)];
            D{kk}=[B{:} C{:}];
        else
            %             D{kk}=[zscore(cell2mat(B.serie_temporali'),0,2)];
            D{kk}=[B{:}];
        end
        duration{yy}{kk}=size(D{kk},2);
    end
    
    cd(pathsave)
    soggnames=[namedata{yy} '_subjnames'];
    eval([soggnames '= subjects']);
    save(soggnames,soggnames,'-v7.3')
    
    cd(pathbase)
end
cd(pathsave);
save('duration','duration');
cd(pathbase)

for zz1=1:size(duration,2)
    dur2{zz1}=cell2mat(duration{zz1});
end
dur2=cell2mat(dur2);
mindur=min(dur2);
clear A temp subjects D pos B C duration



for yy = 1: size(file_da_prendere,2)
     A=dir(file_da_prendere{yy});
    A([1 2])=[];
    temp=cell(1,size(A,2));
    for kk=1:size(A,1)
        temp{kk} =  A(kk).name(1:8);
    end
    subjects=unique(temp);
    D=cell(1,size(subjects,2));
    for kk=1:size(subjects,2)
        pos=find(strcmp(subjects(kk),temp));
        B=load([file_da_prendere{yy} A(pos(1)).name]);
        B=B.dati_bf.trial';
        if length(pos)>1
            C=load([file_da_prendere{yy} A(pos(2)).name]);
            C=C.dati_bf.trial';
            %             D{kk}=[zscore(cell2mat(B.serie_temporali'),0,2) zscore(cell2mat(C.serie_temporali'),0,2)];
            D{kk}=[B{:} C{:}];
        else
            %             D{kk}=[zscore(cell2mat(B.serie_temporali'),0,2)];
            D{kk}=[B{:}];
        end
        duration{yy}{kk}=size(D{kk},2);
    end

    
    for kk1=1:size(duration{yy},2)
        dmax=size(D{kk1},2)-mindur+1;
        randstart=randsample(1:dmax,1);
        D{kk1}=D{kk1}(:,randstart:randstart+mindur-1);
        % D{kk1}=D{kk1}(:,1:mindur);
    end
    %rr=min(cell2mat(duration{:}));
    
    % filters the data in the different frequency bands (broad band will be in the 6th cell!!!!)
    
    activations=cell(1,size(categ,2)+1);
    for kk_freq = 1:size(categ,2)
        h_freq=freq_band{kk_freq}(2);
        l_freq=freq_band{kk_freq}(1);
        f_band=categ{kk_freq};
        [b,a]=butter(2,[l_freq h_freq]/(fs/2)); %imposta parametri filtro
        filtered_series=cell(1,size(D,2));
        w=cell(1,size(D,2));
        for cc1=1:size(D,2)
            filtered_series{cc1}=filter(b,a,D{cc1},[],2); %filtra
            w{cc1}=zscore(filtered_series{cc1},0,2);%computed withe the sample standard deviation (n-1 at the denominator - that is what the flag is about)
            activations{kk_freq}{cc1}=abs(w{cc1})>3; %threshold
        end
    end
    clearvars filtered_series w
    
    %this parts adds the broad banddata nella sesta cella
    
    h=cell(1,size(D,2));
    for kk2 = 1:size(D,2)
        h{kk2}=zscore(D{kk2},0,2);
        activations{6}{kk2}=abs(h{kk2})>3; %threshold
    end
    
    % the following lines is to be used for numb regions = 90, otherwise
    % comment
    
    for kk1=1:size(activations,2) % loops across freq bands
        for kk2=1:size(activations{kk1},2) % loops across patients
            activations{kk1}{kk2}=activations{kk1}{kk2}(1:78,:);
        end
    end
    
    clearvars -except mindur activations yy file_da_prendere categ freq_band fs duration valanghe_pz aval_compl namedata pathbase pathsave aval_compl1
    
    % varies the binning of the avalanches
    
    n_binning=2:5;
    aval_binned=cell(1,size(n_binning,2));
    
    %adds no_binning
    for kk2=1:size(activations,2) % loops across freq bands
        for kk3=1:size(activations{kk2},2) % loops across patients
            %for kk4=1:size(activations{kk2}{kk3},2) % loops across trials
            aval_nobin{1}{kk2}{kk3}=activations{kk2}{kk3};
            %end
        end
    end
    
    % binns the data
    for kk1= 1:size(n_binning,2) %loops across binnings
        for kk2=1:size(activations,2) % loops across freq bands
            for kk3=1:size(activations{kk2},2) % loops across patients
                div=mod(size(activations{kk2}{kk3},2),n_binning(kk1)); %is the size divisible by the binning
                if div~=0
                    activations{kk2}{kk3}= activations{kk2}{kk3}(:,1:end-div);
                end
                for kk5=1:size(activations{kk2}{kk3},1) %scrolls across raws of the avalanche
                    temp=buffer(activations{kk2}{kk3}(kk5,:),n_binning(kk1));
                    aval_binned{kk1}{kk2}{kk3}(kk5,:)=any(temp,1);
                end
                
            end
        end
    end
    
    aval_binned = [aval_nobin aval_binned];
    %     cd(pathsave);
    %     if yy==1
    %         zname=[namedata{yy} '_zscores'];
    %         eval([zname '= aval_binned']);
    %         save(zname,zname,'-v7.3')
    %     end
    %     cd(pathbase);
    clearvars -except mindur aval_binned yy file_da_prendere activations categ freq_band fs duration valanghe_pz aval_compl namedata pathbase pathsave aval_compl1
    
    % spot individual avalanches
    
    for kk1= 1:size(aval_binned,2) %binning
        for kk2= 1:size(aval_binned{kk1},2) %freq_band
            for kk3= 1:size(aval_binned{kk1}{kk2},2) %subj
                % concatenated_avalanches= horzcat(aval_binned{kk1}{kk2}{kk3}{:});
                [avalanches{kk1}{kk2}{kk3},patterns_aval{kk1}{kk2}{kk3}]= avalanches_global_pattern(aval_binned{kk1}{kk2}{kk3},78);
            end
        end
    end
    
    clearvars -except mindur avalanches patterns_aval yy file_da_prendere activations categ freq_band fs duration valanghe_pz aval_compl namedata pathbase pathsave aval_compl1
    % estimations of sigma
    
    
    for kk1=1:size(avalanches,2)
        for kk2=1:size(avalanches{kk1},2)
            for kk3=1:size(avalanches{kk1}{kk2},2)
                kk5=1;
                sigma_temp=[];
                for kk4=1:size(avalanches{kk1}{kk2}{kk3},2)
                    if size(avalanches{kk1}{kk2}{kk3}{kk4},2)>1
                        sigma_temp(kk5) = sigma_avalanche(avalanches{kk1}{kk2}{kk3}{kk4});
                        kk5=kk5+1;
                    else
                        continue
                    end
                end
                sigma_pz{kk1}{kk2}(1,kk3)=geomean(sigma_temp); %controllare aggiunta di kk2 che prima non c'era
                std_pz{kk1}{kk2}(1,kk3)= geostd(sigma_temp);
            end
            sigma_gr{kk1}(kk2)= geomean(sigma_pz{kk1}{kk2});
            std_gr{kk1}(kk2)= geostd(sigma_pz{kk1}{kk2});
        end
    end
    
    clearvars -except mindur avalanches patterns_aval sigma_pz sigma_gr yy file_da_prendere categ freq_band fs duration valanghe_pz aval_compl namedata pathbase pathsave aval_compl1
    
    
    % Calcola quanti "pattern di valanghe" ci sono IN OGNI soggetto
    
    for kk1=1:size(patterns_aval,2) %binnu xc6ing
        for kk2=1:size(patterns_aval{kk1},2) % freq
            for kk3=1:size(patterns_aval{kk1}{kk2},2) % subj
                pattern_per_subj{kk1}{kk2}{kk3}=[patterns_aval{kk1}{kk2}{kk3}{:}];
                [K_gr1{kk1}{kk2}{kk3},~,R_gr1{kk1}{kk2}{kk3}] = unique(pattern_per_subj{kk1}{kk2}{kk3}','rows');
                freq_of_patterns_gr1{kk1}{kk2}{kk3} = accumarray(R_gr1{kk1}{kk2}{kk3},1);
                pattern_counts_gr1{kk1}{kk2}{kk3} = [K_gr1{kk1}{kk2}{kk3}, freq_of_patterns_gr1{kk1}{kk2}{kk3}];
                numb_patterns_group_gr1{kk1}{kk2}{kk3}=size(K_gr1{kk1}{kk2}{kk3},1);
            end
        end
    end
    cd(pathsave);
    %     if yy==1
    non_unique_aval_pz=patterns_aval;
    % save('non_unique_aval_pz','non_unique_aval_pz','-v7.3')
    
    
    sigmaname=[namedata{yy} '_sigma'];
    eval([sigmaname '= sigma_gr']);
    save(sigmaname,sigmaname,'-v7.3')
    
    sigmaname2=[namedata{yy} '_sigma_singoli'];
    eval([sigmaname2 '= sigma_pz']);
    save(sigmaname2,sigmaname2,'-v7.3')
    
    valanghe_pz=avalanches;
    avalname0=[namedata{yy} '_avalanches'];
    eval([avalname0 '= avalanches']);
    save(avalname0,avalname0,'-v7.3')
    
    % save('valanghe_pz','valanghe_pz','-v7.3')
    %     end
    cd(pathbase);
    
    aval_compl1{yy}{1}=numb_patterns_group_gr1;
    aval_compl1{yy}{2}=pattern_counts_gr1;
    
    
    
    clearvars -except mindur a yy file_da_prendere categ freq_band fs duration namedata valanghe_pz aval_compl namedata pathbase pathsave aval_compl1
    
    
    cd(pathsave);
    
    aval_compl=aval_compl1{yy}{1};
    for zz1=1:5
        for zz2=1:6
            aval_compl{zz1}{zz2}=cell2mat(aval_compl{zz1}{zz2})';
        end
    end
    avalname=[namedata{yy} '_aval_compl'];
    eval([avalname '= aval_compl']);
    save(avalname,avalname,'-v7.3')
    % save('duration','duration'); %non salva le duration perché sono state equiparate
    cd(pathbase);
    
    
    %% Numb switch calculator
    
    clearvars -except mindur file_da_prendere valanghe_pz aval_compl namedata pathbase pathsave aval_compl1 yy categ freq_band fs duration
    cd(pathbase);
    valanghe={'valanghe_pz'};
    
    for kk=1:size(valanghe,2)
        
        avalanches=eval(valanghe{kk});
        num_switch=cell(1,size(avalanches,2));
        for kk1=1:size(avalanches,2)
            aa=avalanches{kk1};
            for kk2=1:size(aa,2)
                num_switch{kk1}{kk2}=cell(1,size(aa{kk2},2));
                for kk3= 1: size(aa{kk2},2)
                    temp_1=horzcat(aa{kk2}{kk3}{:});
                    temp_2=diff(temp_1');
                    num_switch{kk1}{kk2}{kk3}=sum(temp_2(:)==1);
                end
            end
        end
        
        if kk==1
            num_switch_pz=num_switch;
        end
        
    end
    
    
    cd(pathsave);
    
    
    for zz1=1:5
        for zz2=1:6
            num_switch_pz{zz1}{zz2}=cell2mat(num_switch_pz{zz1}{zz2})';
        end
    end
    
    switchname=[namedata{yy} '_num_switch'];
    eval([switchname '= num_switch_pz']);
    save(switchname,switchname,'-v7.3')
    cd(pathbase);
    
    
    %% Boolean distances
    clearvars -except mindur file_da_prendere aval_compl namedata pathbase pathsave aval_compl1 yy categ freq_band fs duration
    
    cd(pathbase);
    
    for kk2=1:size(aval_compl1{yy}{2},2)
        for kk1=1:size(aval_compl1{yy}{2}{kk2},2)
            for kk=1:size(aval_compl1{yy}{2}{kk2}{kk1},2)
                temp=pdist(aval_compl1{yy}{2}{kk2}{kk1}{kk}(:,1:78),'hamming');
                aver_bool_gr1{kk2}{kk1}(1,kk)= mean(temp);
                clearvars temp
            end
        end
    end
    
    
    cd(pathsave);
    
    for zz1=1:5
        for zz2=1:6
            aver_bool_gr1{zz1}{zz2}=aver_bool_gr1{zz1}{zz2}';
        end
    end
    
    boolname=[namedata{yy} '_aver_bool'];
    eval([boolname '= aver_bool_gr1']);
    save(boolname,boolname,'-v7.3')
    cd(pathbase);
    
    %% Unione pattern-switch-booldist
    cd(pathsave);
    
    load ([namedata{yy} '_' 'aval_compl.mat']);
    load ([namedata{yy} '_' 'num_switch.mat']);
    
    for zz1=1:5
        for zz2=1:6
            totalpar{zz1}{zz2}=[eval([namedata{yy} '_' 'aval_compl{zz1}{zz2}']) eval([namedata{yy} '_' 'num_switch{zz1}{zz2}']) eval([namedata{yy} '_' 'aver_bool{zz1}{zz2}'])];
        end
    end
    boolname=[namedata{yy} '_total'];
    eval([boolname '= totalpar']);
    save(boolname,boolname,'-v7.3')
    cd(pathbase);
end
