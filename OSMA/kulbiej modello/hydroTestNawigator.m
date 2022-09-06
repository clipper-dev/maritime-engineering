function c = hydroTestNawigator(fileName)
%% DANE WEJ�CIOWE
metoda = 1; %0 - wzgl�dny, 1 - bezwzl�dny b��d
e = zeros(3,1);ePrev = zeros(3,1);eDif = zeros(3,1);eBest = zeros(3,1); %przechowywanie macierzy b��d�w
duration = 125;
constantOffset = 57;
tuningRange = 1; %w wielkokroto�ciach +/- warto�ci wej�ciowej 
tuningStep = 0.01; %w wielkokroto�ciach warto�ci wej�ciowej 
trials = 10;%floor(tuningRange/tuningStep);
%% LOAD SEQUENCE
dataExp = analizaWsteczna("nawigator",duration,constantOffset); %wzorcowe warto�ci

baseSet = ([-0.0;0.0;-0.0;0.0;...
   -0.307;0.062;-0.58;-0.041;-0.721;-0.38;...
    -0.1;-0.045;-0.25;-0.03;-0.6;-0.27]);
sv = matfile(fileName+".mat");
initialSet = sv.finalSet;
%initialSet = baseSet;
hydroSet = initialSet; %aktualnie badany
dataModel = generujTrajektorie("nawigator", 35, duration, 5.911, true, hydroSet);
e(1) = stopienBledu(dataExp(:,8),dataModel(:,8));
e(2) = stopienBledu(dataExp(:,9),dataModel(:,9));
e(3) = stopienBledu(dataExp(:,5),dataModel(:,5));
ePrev = e;

%% ZAPISANIE WYNIKU
%% WYKRESY
clc; close all
dataModel = generujTrajektorie("nawigator", 35, duration, 5.911, true, hydroSet);
porownanieWykresy;
end