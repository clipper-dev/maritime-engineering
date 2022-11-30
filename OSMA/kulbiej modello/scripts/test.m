% wczytanie z pliku
clear; clc;
close all;
%% 
% pogoda = ;
% vessel = shipLoad2("klvcc2L7",100,0,0,0,0,0,6,0,0,0,0,0,pogoda);
% zestawy = {'ym'};  
% sv = matfile("wyniki/"+zestawy(1)+".mat");
% aData = generujTrajektorie("klvcc2L7",100,35,duration,7.9,false,sv.finalSet,0,pogoda);
% rysujWykresy(true,false,aData,vessel,1,0,100,1,0,0,0,0);
%%
shipVector.isOwnSet = false;
shipVector.OwnSet = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
steeringVector = [100 35];%maszyna i ster
%CZAS%
calculusVector1 = [1000 5 0];
calculusVector2 = [1000 5 2];
calculusVector3 = [1000 5 2];
initialStateVector1 = [0 0 0 0 0 0 7.97 0 0 0 0 0];
initialStateVector2 = [0 0 0 0 0 0 7.97 0 0 0 0 0];
initialStateVector3 = [0 0 0 0 0 0 7.97 0 0 0 0 0];
environmentVector.isWeather = false;
environmentVector.weather = weather(0,0,0,0,0);
environmentVector.isShallow = false;
environmentVector.depth = 100;

v1 = shipLoad3('s175', shipVector, steeringVector, calculusVector1, initialStateVector1, environmentVector,'k','rect2');
v2 = shipLoad3('kvlcc2', shipVector, steeringVector, calculusVector2, initialStateVector2, environmentVector,'g','rect2');
v3 = shipLoad3('kvlcc2', shipVector, steeringVector, calculusVector3, initialStateVector3, environmentVector,'r','rect2');
armada=[v1 v2 v3];
%analizaBezwymiarowa(vessel, shipVector, steeringVector, calculusVector, initialStateVector, environmentVector);
data(1,:,:)= generujTrajektorie3(v1, shipVector, steeringVector, calculusVector1, initialStateVector1, environmentVector, true);
data(2,:,:)= generujTrajektorie3(v2, shipVector, steeringVector, calculusVector2, initialStateVector2, environmentVector, true);
data(3,:,:)= generujTrajektorie3(v3, shipVector, steeringVector, calculusVector3, initialStateVector3, environmentVector, true);

% rysujWykresy(true,true,aData1,v1,0,1,1,15,0,0,0,0,0,0);
rysujWykresyWiele(true,data,armada,0,90);