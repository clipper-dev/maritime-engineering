%% DANE WEJŒCIOWE
clc;clear
SADane = [...
    35 2.0 -0.5 0.54 123 55 116;...
    30 2.2 -0.5 0.46 130 55 126;...
    25 2.4 -0.54 0.44 160 64 155;...
    20 2.8 -0.64 0.36 160 80 170;...
    15 3.3 -0.7 0.35 210 90 207;...
    10 3.8 -0.62 0.33 330 113 247];

SADane(:,2:3)=SADane(:,2:3)*5.911;
SADane(:,5:7)=SADane(:,5:7)/60.2;
% wczytanie z pliku
sv = matfile('h1.mat');
aData = generujTrajektorie("nawigator",35,300,5.911,true,sv.finalSet);
a = ocenaTrajektorii(35,aData, 10.18);
% skalowanie 
a(2:3)=a(2:3)*5.911;
a(5:7)=a(5:7)/60.2;
stopienBledu(a(:),SADane(1,:))