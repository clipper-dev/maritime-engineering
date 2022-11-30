%% Wczytywanie danych
clc;clear all; close all;

dat=matfile('wyniki/sims/38.mat');
res = dat.res;

figure;hold on;
plot(res(:,14));

%trajektorie
figure;hold on; grid on; axis equal;
plot(res(:,12),res(:,11));
plot(res(:,22),res(:,21));
disp("Fini");