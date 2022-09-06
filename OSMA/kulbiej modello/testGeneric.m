clc;clear;close all;
statek ="kcs"
czas=500;
ster=35;
%% ustawienia
v1=shipDefault(statek,666,0,czas,ster);
% xx2=matfile('ym.mat');
% set=xx2.finalSet;
% %v1=v1.updateSet(hydroSetYM(v1));
% %v1=v1.updateSet(set);
calculusVector = [czas 1 2];
[data, v1]= generujTrajektorie3(v1,calculusVector);
rysujWykresy(true,false,data,v1,0,1,1,40,1,1,1,1,1,0,0);
%% 

