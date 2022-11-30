%% STATYCZNE
clc; close all; clear
indices35=[1.9 -0.43 0.048 2.7 1.3 2.1 2.2 1.2];
indices25=[2.4 -0.60 0.047 3.1 1.6 2.3 2.7 1.8];
indices15=[3.2 -0.70 0.035 3.9 1.8 2.8 3.7 3.3];
% statek i zestaw hydro
xx2=matfile('ym.mat');
set=xx2.finalSet;
xx3=matfile('wynikNowy.mat');
betterSet=xx3.betterSet;
shipVector.isOwnSet = true;
shipVector.ownSet = set;%[-0.061 0.09 -0.0008 0.41 -0.31 0.062 -0.577 -0.051 -0.719 -0.75 -0.105 -0.0457 -0.253 -0.0302 -0.6 -0.274];
steeringVector = [100 35];%maszyna i ster
calculusVector = [1 1 1];
initialStateVector1 = [0 0 0 0 0 0 5.81 0 0 0 0 0];
environmentVector.isWeather = false;
environmentVector.weather = weather(0,0,0,0,0);
environmentVector.isShallow = false;
environmentVector.depth = 100;
s = shipLoad3("nawigator", shipVector, steeringVector, calculusVector, initialStateVector1, environmentVector,'k');
% KONIEC STATYCZNYCH

%% DYNAMICZNE
tic

wskaznikBezwzgledny = true;
newIndices35=generowanieWskaznikow(betterSet,s,35);
newIndices25=generowanieWskaznikow(betterSet,s,25);
newIndices15=generowanieWskaznikow(betterSet,s,15);
error=3*porownanieBledu2(newIndices35,indices35,wskaznikBezwzgledny)+...
    2*porownanieBledu2(newIndices25,indices25,wskaznikBezwzgledny)+...
    porownanieBledu2(newIndices15,indices15,wskaznikBezwzgledny)
prevError = error;

iteration = 0;
modifier = 0.1;
total = 3;
lockK = true;
newSet = betterSet;
err=error;
while lockK == true
    iteration=iteration+1
    mmm3
    if err < 0.01 || error < 0.01
       lockK = false; 
    end
    modifier = rand*modifier;
end
newIndicesOld=generowanieWskaznikow(set,s,35);
newIndices35=generowanieWskaznikow(betterSet,s,35);
newIndices25=generowanieWskaznikow(betterSet,s,25);
newIndices15=generowanieWskaznikow(betterSet,s,15);
error=3*porownanieBledu2(newIndices35,indices35,wskaznikBezwzgledny)+...
    2*porownanieBledu2(newIndices25,indices25,wskaznikBezwzgledny)+...
    porownanieBledu2(newIndices15,indices15,wskaznikBezwzgledny)

toc

%%
xx2=matfile('wynikNowy.mat');
set=xx2.betterSet;
shipVector.isOwnSet = true;
shipVector.ownSet = set;%[0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
steeringVector = [100 35];%maszyna i ster
%CZAS%
czas=500;
calculusVector = [czas 1 1];
initialStateVector1 = [0 0 0 0 0 0 5.81 0 0 0 0 0];
environmentVector.isWeather = false;
environmentVector.weather = weather(0,0,0,0,0);
environmentVector.isShallow = false;
environmentVector.depth = 100;
v1 = shipLoad3("nawigator", shipVector, steeringVector, calculusVector, initialStateVector1, environmentVector,'k');
%analizaBezwymiarowa(vessel, shipVector, steeringVector, calculusVector, initialStateVector, environmentVector);
data= generujTrajektorie3(v1, shipVector, steeringVector, calculusVector, initialStateVector1, environmentVector, true);
%rysujWykresy(true,false,data,v1,0,1,2,90,1,0,0,0,0,0);
%wsteczna
disp("Fini");
