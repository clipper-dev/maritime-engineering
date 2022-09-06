function c = awp3(order, number, figures, expWybrane)
%% DANE WEJ�CIOWE
metoda = 1; %0 - wzgl�dny, 1 - bezwzl�dny b��d
e = zeros(9,1);ePrev = zeros(9,1);eDif = zeros(9,1);eBest = zeros(9,1); %przechowywanie macierzy b��d�w
duration = 125;
constantOffset = 57;
tuningRange = 1; %w wielkokroto�ciach +/- warto�ci wej�ciowej 
tuningStep = 0.01; %w wielkokroto�ciach warto�ci wej�ciowej 
trials = 10;%floor(tuningRange/tuningStep);
%% LOAD SEQUENCE %wzorcowe warto�ci

baseSet = ([-0.0;0.0;-0.0;0.0;...
   -0.307;0.062;-0.58;-0.041;-0.721;-0.38;...
    -0.1;-0.045;-0.25;-0.03;-0.6;-0.27]);
sv = matfile('strojenieWynik.mat');
initialSet = sv.finalSet;
%initialSet = baseSet;
hydroSet = initialSet; %aktualnie badany
previousHydroSet = initialSet; %u�ywany do por�wnania
finalSet = initialSet; %zwracany jako wynik
dataModel = generujTrajektorie("nawigator", 35, duration, 5.911, true, hydroSet);
dataModelVector = ocenaTrajektorii(35,dataModel,0.098)
modelWybrane = [dataModel(20,8) dataModel(70,8) dataModel(120,8);...
    dataModel(20,9) dataModel(70,9) dataModel(120,9);...
    dataModel(20,5) dataModel(70,5) dataModel(120,5)];
e(1) = stopienBledu(modelWybrane(1,:),expWybrane(1,:));
e(2) = stopienBledu(modelWybrane(2,:),expWybrane(2,:));
e(3) = stopienBledu(modelWybrane(3,:),expWybrane(3,:));
dataModel = generujTrajektorie("nawigator", 20, duration, 5.911, true, hydroSet);
e(4) = stopienBledu( dataModel(120,8),expWybrane(4,1));
e(5) = stopienBledu( dataModel(120,9),expWybrane(4,2));
e(6) = stopienBledu( dataModel(120,5),expWybrane(4,3));
dataModel = generujTrajektorie("nawigator", 5, duration, 5.911, true, hydroSet);
e(7) = stopienBledu( dataModel(120,8),expWybrane(5,1));
e(8) = stopienBledu( dataModel(120,9),expWybrane(5,2));
e(9) = stopienBledu( dataModel(120,5),expWybrane(5,3));
ePrev = e;
%% STROJENIE

if order == 1
a = [number];    
else
%a = [1 2 3 4 5 6 7 8 9 10 11 12];
a = [5 6 11 12];
a = a(randperm(length(a)));
end
% p�tla numer 1 -> wyb�r parametru do strojenia
for var=1:length(a)
    %+
    for i=1:trials
        % testowa warto�� strojonego parametru
        hydroDif = 1/2^trials;
        if order == 2
           hydroDif = rand(); 
        end
        hydroSet(a(var)+4) = previousHydroSet(a(var)+4)+hydroDif;
        %hydroSet(a(var)) = initialSet(a(var))*(1 - i*tuningStep);
        % tymczasowy set
        if order == 3
           for j=1:12
              hydroSet(j+4)=hydroSet(j+4)*(1-2*rand()); 
           end
        end
        % oblicz ponownie
        dataModel = generujTrajektorie("nawigator", 35, duration, 5.911, true, hydroSet);
modelWybrane = [dataModel(20,8) dataModel(70,8) dataModel(120,8);...
    dataModel(20,9) dataModel(70,9) dataModel(120,9);...
    dataModel(20,5) dataModel(70,5) dataModel(120,5)];
e(1) = stopienBledu(modelWybrane(1,:),expWybrane(1,:));
e(2) = stopienBledu(modelWybrane(2,:),expWybrane(2,:));
e(3) = stopienBledu(modelWybrane(3,:),expWybrane(3,:));
dataModel = generujTrajektorie("nawigator", 20, duration, 5.911, true, hydroSet);
e(4) = stopienBledu( dataModel(120,8),expWybrane(4,1));
e(5) = stopienBledu( dataModel(120,9),expWybrane(4,2));
e(6) = stopienBledu( dataModel(120,5),expWybrane(4,3));
dataModel = generujTrajektorie("nawigator", 5, duration, 5.911, true, hydroSet);
e(7) = stopienBledu( dataModel(120,8),expWybrane(5,1));
e(8) = stopienBledu( dataModel(120,9),expWybrane(5,2));
e(9) = stopienBledu( dataModel(120,5),expWybrane(5,3));
        if metoda == 0
            % por�wnaj b��dy wzgl�dne, je�li obecny lepszy, zast�p
            eDif(1) = (e(1) - ePrev(1))/ePrev(1);
            eDif(2) = (e(2) - ePrev(2))/ePrev(2);
            eDif(3) = (e(3) - ePrev(3))/ePrev(3);
            eDif(4) = (e(4) - ePrev(4))/ePrev(4);
            eDif(5) = (e(5) - ePrev(5))/ePrev(5);
            eDif(6) = (e(6) - ePrev(6))/ePrev(6);
            eDif(7) = (e(7) - ePrev(7))/ePrev(7);
            eDif(8) = (e(8) - ePrev(8))/ePrev(8);
            eDif(9) = (e(9) - ePrev(9))/ePrev(9);
            % ocena i nadpisanie
            if sum(eDif) < 0
                trials=trials-1;
                 ePrev = e;
                 previousHydroSet = hydroSet;
            end
        else
            % por�wnaj b��dy bezwzgl�dne, je�li obecny lepszy, zast�p
            % ocena i nadpisanie
            if sum(e) - sum(ePrev) < 0
                trials=trials-1;
                 ePrev = e;
                 previousHydroSet = hydroSet;
            end
        end
    end
    %-
    for i=1:trials
        % testowa warto�� strojonego parametru
        hydroDif = -1/2^trials;
        if order == 2
           hydroDif = -rand(); 
        end
        hydroSet(a(var)+4) = previousHydroSet(a(var)+4)+hydroDif;
        %hydroSet(a(var)) = initialSet(a(var))*(1 - i*tuningStep);
        % tymczasowy set
        
        if order == 3
           for j=1:12
              hydroSet(j+4)=hydroSet(j+4)*(1-2*rand()); 
           end
        end
        % oblicz ponownie
        dataModel = generujTrajektorie("nawigator", 35, duration, 5.911, true, hydroSet);
modelWybrane = [dataModel(20,8) dataModel(70,8) dataModel(120,8);...
    dataModel(20,9) dataModel(70,9) dataModel(120,9);...
    dataModel(20,5) dataModel(70,5) dataModel(120,5)];
e(1) = stopienBledu(modelWybrane(1,:),expWybrane(1,:));
e(2) = stopienBledu(modelWybrane(2,:),expWybrane(2,:));
e(3) = stopienBledu(modelWybrane(3,:),expWybrane(3,:));
dataModel = generujTrajektorie("nawigator", 20, duration, 5.911, true, hydroSet);
e(4) = stopienBledu( dataModel(120,8),expWybrane(4,1));
e(5) = stopienBledu( dataModel(120,9),expWybrane(4,2));
e(6) = stopienBledu( dataModel(120,5),expWybrane(4,3));
dataModel = generujTrajektorie("nawigator", 5, duration, 5.911, true, hydroSet);
e(7) = stopienBledu( dataModel(120,8),expWybrane(5,1));
e(8) = stopienBledu( dataModel(120,9),expWybrane(5,2));
e(9) = stopienBledu( dataModel(120,5),expWybrane(5,3));
        if metoda == 0
            % por�wnaj b��dy wzgl�dne, je�li obecny lepszy, zast�p
            eDif(1) = (e(1) - ePrev(1))/ePrev(1);
            eDif(2) = (e(2) - ePrev(2))/ePrev(2);
            eDif(3) = (e(3) - ePrev(3))/ePrev(3);
            eDif(4) = (e(4) - ePrev(4))/ePrev(4);
            eDif(5) = (e(5) - ePrev(5))/ePrev(5);
            eDif(6) = (e(6) - ePrev(6))/ePrev(6);
            eDif(7) = (e(7) - ePrev(7))/ePrev(7);
            eDif(8) = (e(8) - ePrev(8))/ePrev(8);
            eDif(9) = (e(9) - ePrev(9))/ePrev(9);
            % ocena i nadpisanie
            if sum(eDif) < 0
                trials=trials-1;
                 ePrev = e;
                 previousHydroSet = hydroSet;
            end
        else
            % por�wnaj b��dy bezwzgl�dne, je�li obecny lepszy, zast�p
            % ocena i nadpisanie
            if sum(e) - sum(ePrev) < 0
                trials=trials-1;
                 ePrev = e;
                 previousHydroSet = hydroSet;
            end
        end
    end
end
finalSet = previousHydroSet;
difference = initialSet - finalSet;
%% ZAPISANIE WYNIKU
%% WYKRESY
%clc; close all
    c = sum(ePrev);
if ~isequal(initialSet,finalSet)
    %disp("Znaleziono lepszy zestaw o sumarycznym b��dzie: " + sum(ePrev));
    save('strojenieWynik.mat','finalSet');
else
    disp("Nie tym razem :( B��d wci�� " + c);
end
if figures == true
     close all
     dataModel = generujTrajektorie("nawigator", 35, duration, 5.911, true, finalSet);
     porownanieWykresy;
end
end