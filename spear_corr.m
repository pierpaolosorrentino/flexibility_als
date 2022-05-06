clearvars,clc,close all

bb=[];
test=[];

for aa=1:4
    [r(1,aa),p(1,aa)]=corr(bb(:,1),test(:,aa),'type','spearman')
end

pcorr=mafdr(p,'BHFDR','true');


