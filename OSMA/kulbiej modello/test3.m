close all;clc;clear;close all
statek ="kcs"
czas=45;
%% ustawienia

indices35=[1.9 -0.43 0.048 2.2 2.2 1.2];
indices25=[2.4 -0.6 0.047 3.1 2.9 1.8];
indices15=[3.2 -0.7 0.035 3.9 3.7 3.3];
xx2=matfile('wynikNowy.mat');
set=xx2.betterSet;
shipVector.isOwnSet = false;
shipVector.ownSet = set;%[0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
steeringVector = [100 1];%maszyna i ster
%CZAS%

calculusVector = [czas 1 1];
initialStateVector1 = [0 0 0 0 0 0 666 0 0 0 0 0];
environmentVector.isWeather = false;
environmentVector.weather = weather(0,0,0,0,0);
environmentVector.isShallow = false;
environmentVector.depth = 100;
v1 = shipLoad3(statek, shipVector, steeringVector, calculusVector, initialStateVector1, environmentVector,'k','rect2');
%analizaBezwymiarowa(vessel, shipVector, steeringVector, calculusVector, initialStateVector, environmentVector);
data= generujTrajektorie3(v1, shipVector, steeringVector, calculusVector, initialStateVector1, environmentVector, true);
rysujWykresy(true,false,data,v1,0,1,1,40,1,1,1,1,1,0,0);
%% 

