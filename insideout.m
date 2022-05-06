%% Out of the folder
% Sposta tutte le serie temporali fuori dalle cartelle e cancella le
% cartelle ormai vuote

clearvars
clc

%Percorso cartella del gruppo
fold1= 'F:\MEG\SLA_metabolomica\SLA_valanghe\valanghe_SLA_codici_e_risultati\SLA';
cd(fold1);
A=dir(fold1);
A([1 2])=[];
checkdir=find([A(:).isdir]==0);
A(checkdir)=[];

for zz1=1:size(A,1)
    cd(fold1);
    pathn=[fold1 '\' A(zz1).name];
    cd(pathn)
    B=dir(pathn);
    B([1 2])=[];
    for zz2=1:size(B,1)
        pathz=B(zz2).name;
        movefile (pathz,fold1)
    end
    clear B
end

cd(fold1);
D=dir(fold1);
D([1 2])=[];
checkdir=find([D(:).isdir]==0);
D(checkdir)=[];
for zz1=1:size(D,1)
   rmdir(D(zz1).name); 
end

%% Into the folder
%Crea una cartella per ogni soggetto e ci sposta dentro la serie temporale
clearvars
clc

%Percorso cartella del gruppo
fold1= 'G:\SLA_st\SLA';
cd(fold1);
A=dir(fold1);
A([1 2])=[];
checkdir=find([A(:).isdir]==1);
A(checkdir)=[];
for zz1=1:size(A,1)
    cd(fold1);
    sern=A(zz1).name(1:11);
    mkdir(sern);
    movefile(A(zz1).name,[fold1 '\' sern]);
end