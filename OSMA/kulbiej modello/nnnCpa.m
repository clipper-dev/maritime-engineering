%% Wczytywanie danych
% generowanie tablicy z danymi symulacji
% koniec dla zalozonego cpa
% porownanie 3 roznych metod
clc;clear all; close all;
% loading ships data
[a,b]=navigationalSituation(38);

b=b.updateShip([-5000 -5000 0 0 0 0.1571 7.08 0 0 0 0 0]);

cpaOutline(a,b,1)
cpa(a,b)