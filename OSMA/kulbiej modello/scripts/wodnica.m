close all;clc;clear
file = matfile('kvlcc2Obrys.mat');
wynik = file.wynik;

figure;hold on;axis equal;grid on;
plot(wynik(:,3),wynik(:,2));
plot(-wynik(:,3),wynik(:,2));

