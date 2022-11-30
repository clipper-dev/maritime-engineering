%% Wczytywanie danych
clc;clear all; close all;

%% multi simulation
times = [50 500];
movements1 = [0];
movements2 = [-1];
rudders1 = [0 0];
rudders2 = [0];
[a,b]=navigationalSituation(38);
tic

[res,aa,bb] = multiSimulate(a,b,times,1,true,movements1, movements2, rudders1, rudders2);
rudders1 = [0 0];
[res2,aa2,bb2] = multiSimulate(a,b,times,1,true,movements1, movements2, rudders1, rudders2);
toc
figure;hold on;
plot(res(:,14));
% figure;hold on;
% plot(res(:,16));
disp("Fini");