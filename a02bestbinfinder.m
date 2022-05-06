%% ESEGUI PRIMA "RUN AND ADVANCE" SU QUESTA SEZIONE
% La variabile bestbin generata alla fine conterrà il numero del bin
% migliore su cui fare la statistica
clearvars
[gruppo1t1_sigma, gruppo1t2_sigma, gruppo1t3_sigma, gruppo1t4_sigma, gruppo1t5_sigma, gruppo2t1_sigma, gruppo2t2_sigma, gruppo2t3_sigma, gruppo2t4_sigma, gruppo2t5_sigma, gruppo3t1_sigma, gruppo3t2_sigma, gruppo3t3_sigma, gruppo3t4_sigma, gruppo3t5_sigma]=deal([]);
%FAI RUN AND ADVANCE
%% Ora Carica nel workspace tutti i gruppoxtx_sigma e compila questa szione

numofgr=2; %numero di gruppi (minimo 1, massimo 3)
numoft=1; %numero di tempi/task/condizioni (minimo 1, massimo 5)
numofsigma=numofgr*numoft; %NON MODIFICARE

% FAI RUN AND ADVANCE
%% RUN AND ADVANCE
[binsumgruppo1t1, binsumgruppo1t2, binsumgruppo1t3, binsumgruppo1t4, binsumgruppo1t5, binsumgruppo2t1, binsumgruppo2t2, binsumgruppo2t3, binsumgruppo2t4, binsumgruppo2t5, binsumgruppo3t1, binsumgruppo3t2, binsumgruppo3t3, binsumgruppo3t4, binsumgruppo3t5_sigma]=deal([0,0,0,0,0]);

for zz1=1:5
    if isempty(gruppo1t1_sigma)==0
        binsumgruppo1t1(zz1)=(gruppo1t1_sigma{zz1}(1,1)+gruppo1t1_sigma{zz1}(1,2)+gruppo1t1_sigma{zz1}(1,3)+gruppo1t1_sigma{zz1}(1,4)+gruppo1t1_sigma{zz1}(1,5)+gruppo1t1_sigma{zz1}(1,6))/6;
    end
    if isempty(gruppo1t2_sigma)==0
        binsumgruppo1t2(zz1)=(gruppo1t2_sigma{zz1}(1,1)+gruppo1t2_sigma{zz1}(1,2)+gruppo1t2_sigma{zz1}(1,3)+gruppo1t2_sigma{zz1}(1,4)+gruppo1t2_sigma{zz1}(1,5)+gruppo1t2_sigma{zz1}(1,6))/6;
    end
    if isempty(gruppo1t3_sigma)==0
        binsumgruppo1t3(zz1)=(gruppo1t3_sigma{zz1}(1,1)+gruppo1t3_sigma{zz1}(1,2)+gruppo1t3_sigma{zz1}(1,3)+gruppo1t3_sigma{zz1}(1,4)+gruppo1t3_sigma{zz1}(1,5)+gruppo1t3_sigma{zz1}(1,6))/6;
    end
    if isempty(gruppo1t4_sigma)==0
        binsumgruppo1t4(zz1)=(gruppo1t4_sigma{zz1}(1,1)+gruppo1t4_sigma{zz1}(1,2)+gruppo1t4_sigma{zz1}(1,3)+gruppo1t4_sigma{zz1}(1,4)+gruppo1t4_sigma{zz1}(1,5)+gruppo1t4_sigma{zz1}(1,6))/6;
    end
    if isempty(gruppo1t5_sigma)==0
        binsumgruppo1t5(zz1)=(gruppo1t5_sigma{zz1}(1,1)+gruppo1t5_sigma{zz1}(1,2)+gruppo1t5_sigma{zz1}(1,3)+gruppo1t5_sigma{zz1}(1,4)+gruppo1t5_sigma{zz1}(1,5)+gruppo1t5_sigma{zz1}(1,6))/6;
    end
    if isempty(gruppo2t1_sigma)==0
        binsumgruppo2t1(zz1)=(gruppo2t1_sigma{zz1}(1,1)+gruppo2t1_sigma{zz1}(1,2)+gruppo2t1_sigma{zz1}(1,3)+gruppo2t1_sigma{zz1}(1,4)+gruppo2t1_sigma{zz1}(1,5)+gruppo2t1_sigma{zz1}(1,6))/6;
    end
    if isempty(gruppo2t2_sigma)==0
        binsumgruppo2t2(zz1)=(gruppo2t2_sigma{zz1}(1,1)+gruppo2t2_sigma{zz1}(1,2)+gruppo2t2_sigma{zz1}(1,3)+gruppo2t2_sigma{zz1}(1,4)+gruppo2t2_sigma{zz1}(1,5)+gruppo2t2_sigma{zz1}(1,6))/6;
    end
    if isempty(gruppo2t3_sigma)==0
        binsumgruppo2t3(zz1)=(gruppo2t3_sigma{zz1}(1,1)+gruppo2t3_sigma{zz1}(1,2)+gruppo2t3_sigma{zz1}(1,3)+gruppo2t3_sigma{zz1}(1,4)+gruppo2t3_sigma{zz1}(1,5)+gruppo2t3_sigma{zz1}(1,6))/6;
    end
    if isempty(gruppo2t4_sigma)==0
        binsumgruppo2t4(zz1)=(gruppo2t4_sigma{zz1}(1,1)+gruppo2t4_sigma{zz1}(1,2)+gruppo2t4_sigma{zz1}(1,3)+gruppo2t4_sigma{zz1}(1,4)+gruppo2t4_sigma{zz1}(1,5)+gruppo2t4_sigma{zz1}(1,6))/6;
    end
    if isempty(gruppo2t5_sigma)==0
        binsumgruppo2t5(zz1)=(gruppo2t5_sigma{zz1}(1,1)+gruppo2t5_sigma{zz1}(1,2)+gruppo2t5_sigma{zz1}(1,3)+gruppo2t5_sigma{zz1}(1,4)+gruppo2t5_sigma{zz1}(1,5)+gruppo2t5_sigma{zz1}(1,6))/6;
    end
    if isempty(gruppo3t1_sigma)==0
        binsumgruppo3t1(zz1)=(gruppo3t1_sigma{zz1}(1,1)+gruppo3t1_sigma{zz1}(1,2)+gruppo3t1_sigma{zz1}(1,3)+gruppo3t1_sigma{zz1}(1,4)+gruppo3t1_sigma{zz1}(1,5)+gruppo3t1_sigma{zz1}(1,6))/6;
    end
    if isempty(gruppo3t2_sigma)==0
        binsumgruppo3t2(zz1)=(gruppo3t2_sigma{zz1}(1,1)+gruppo3t2_sigma{zz1}(1,2)+gruppo3t2_sigma{zz1}(1,3)+gruppo3t2_sigma{zz1}(1,4)+gruppo3t2_sigma{zz1}(1,5)+gruppo3t2_sigma{zz1}(1,6))/6;
    end
    if isempty(gruppo3t3_sigma)==0
        binsumgruppo3t3(zz1)=(gruppo3t3_sigma{zz1}(1,1)+gruppo3t3_sigma{zz1}(1,2)+gruppo3t3_sigma{zz1}(1,3)+gruppo3t3_sigma{zz1}(1,4)+gruppo3t3_sigma{zz1}(1,5)+gruppo3t3_sigma{zz1}(1,6))/6;
    end
    if isempty(gruppo3t4_sigma)==0
        binsumgruppo3t4(zz1)=(gruppo3t4_sigma{zz1}(1,1)+gruppo3t4_sigma{zz1}(1,2)+gruppo3t4_sigma{zz1}(1,3)+gruppo3t4_sigma{zz1}(1,4)+gruppo3t4_sigma{zz1}(1,5)+gruppo3t4_sigma{zz1}(1,6))/6;
    end
    if isempty(gruppo3t5_sigma)==0
        binsumgruppo3t5(zz1)=(gruppo3t5_sigma{zz1}(1,1)+gruppo3t5_sigma{zz1}(1,2)+gruppo3t5_sigma{zz1}(1,3)+gruppo3t5_sigma{zz1}(1,4)+gruppo3t5_sigma{zz1}(1,5)+gruppo3t5_sigma{zz1}(1,6))/6;
    end
end




binsumtot=(binsumgruppo1t1+binsumgruppo1t2+binsumgruppo1t3+binsumgruppo1t4+binsumgruppo1t5+binsumgruppo2t1+binsumgruppo2t2+binsumgruppo2t3+binsumgruppo2t4+binsumgruppo2t5+binsumgruppo3t1+binsumgruppo3t2+binsumgruppo3t3+binsumgruppo3t4+binsumgruppo3t5_sigma)/numofsigma;
one5=[1 1 1 1 1];
binsumdiff=one5-binsumtot;
minimumdiff=min(abs(binsumdiff));

bestbin=find(abs(binsumdiff)==minimumdiff); %Questa variabile contiene il numero del bin da utilizzare
textbin=mat2str(bestbin);

load splat
sound(y)
disp(['Fine! Il bin da utilizzare è il numero ' textbin])

% clearvars -except bestbin