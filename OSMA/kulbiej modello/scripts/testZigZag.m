% wczytanie z pliku

close all;
xx2=matfile('ym.mat');
set=xx2.finalSet;
shipVector.isOwnSet = true;
shipVector.ownSet = set;%[0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
steeringVector = [100 20];%maszyna i ster
%CZAS%
czas=250;
calculusVector = [czas 1 1];
initialStateVector1 = [0 0 0 0 0 -0.785 5.81 0 0 0 0 0];
environmentVector.isWeather = false;
environmentVector.weather = weather(0,0,0,0,0);
environmentVector.isShallow = false;
environmentVector.depth = 100;
v1 = shipLoad3("nawigator", shipVector, steeringVector, calculusVector, initialStateVector1, environmentVector,'k');
%analizaBezwymiarowa(vessel, shipVector, steeringVector, calculusVector, initialStateVector, environmentVector);
data= zigZag("port",15,5,v1, shipVector, steeringVector, calculusVector, initialStateVector1, environmentVector, true);
xx3=matfile('wezowa5-15.mat');
aisData=xx3.readAisData;
offset = 61;
offsetX = 4.8*55; offsetY = 4.2*55;
rysujWykresyZigZag(true,false,data,v1,0,1,0,90,1,0,0,0,0,0,1,aisData,offset, offsetX, offsetY);
