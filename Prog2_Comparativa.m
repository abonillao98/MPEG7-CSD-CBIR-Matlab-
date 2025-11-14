clear all
%% Cargamos precision i recalls i calculamos F-score
% 256_base
load("precision_256_base.mat","precision_avg") 
precision_256_base = precision_avg;
load("recall_256_base.mat","recall_avg") 
recall_256_base = recall_avg;
f_score_256_base = max((2.*precision_256_base.*recall_256_base)./(precision_256_base+recall_256_base));

% 256_delmat
load("precision_256_delmat.mat","precision_avg") 
precision_256_delmat = precision_avg;
load("recall_256_delmat.mat","recall_avg") 
recall_256_delmat = recall_avg;
f_score_256_delmat = max((2.*precision_256_delmat.*recall_256_delmat)./(precision_256_delmat+recall_256_delmat));

% 256_opt
load("precision_256_opt.mat","precision_avg") 
precision_256_opt = precision_avg;
load("recall_256_opt.mat","recall_avg") 
recall_256_opt = recall_avg;
f_score_256_opt = max((2.*precision_256_opt.*recall_256_opt)./(precision_256_opt+recall_256_opt));

% 4x4
load("precision_256_4x4.mat","precision_avg") 
precision_256_4x4 = precision_avg;
load("recall_256_4x4.mat","recall_avg") 
recall_256_4x4 = recall_avg;
f_score_256_4x4 = max((2.*precision_256_4x4.*recall_256_4x4)./(precision_256_4x4+recall_256_4x4));

% 128
load("precision_128.mat","precision_avg") 
precision_128 = precision_avg;
load("recall_128.mat","recall_avg") 
recall_128 = recall_avg;
f_score_128 = max((2.*precision_128.*recall_128)./(precision_128+recall_128));


%% gráfico del precision recall
perfect_precision = [1,1,1,1,4/5,4/6,4/7,4/8,4/9,4/10];
perfect_recall = [0.25,0.5,0.75,1,1,1,1,1,1,1];
% contour per les isolines
x = linspace(0,1);
y = linspace(0,1);
[X,Y] = meshgrid(x,y); % contour nomes accepta matrius
Z = (2.*X.*Y)./(X+Y); % formula del f-score per a que calculi les isolinies
contour(X,Y,Z)
hold on

plot(perfect_recall,perfect_precision,'k-diamond','LineWidth',2)
grid on
hold on
xlabel('Recall');
ylabel('Precision');
title('Grafic Precision-Recall | Distancia: Hellinger')

plot(recall_256_base,precision_256_base,'-+')
plot(recall_256_opt,precision_256_opt,'--o')
plot(recall_256_delmat,precision_256_delmat,'-*')
plot(recall_256_4x4,precision_256_4x4,':^')
plot(recall_128,precision_128,'-.v')

legend('isoFScore','Optimal (F=1)',strcat('256 base (F=',num2str(f_score_256_base),')'), ...
    strcat('256 opt (F=',num2str(f_score_256_opt),')'),strcat('256 delmat (F=',num2str(f_score_256_delmat),')'), ...
    strcat('256 4x4 (F=',num2str(f_score_256_4x4),')'),strcat('128 (F=',num2str(f_score_128),')'),'Location','southwest')