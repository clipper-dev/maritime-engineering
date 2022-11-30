function c = awp(order, number, figures)
%% DANE WEJŒCIOWE
metoda = 1; %0 - wzglêdny, 1 - bezwzlêdny b³¹d
%e = zeros(3,1);ePrev = zeros(3,1);eDif = zeros(3,1);eBest = zeros(3,1); %przechowywanie macierzy b³êdów
duration = 200;
tuningRange = 1; %w wielkokrotoœciach +/- wartoœci wejœciowej 
tuningStep = 0.01; %w wielkokrotoœciach wartoœci wejœciowej 
trials = 10;%floor(tuningRange/tuningStep);
%% LOAD SEQUENCE
SADane = [...
    35 2.0 -0.5 0.54 123 55 116;...
    30 2.2 -0.5 0.46 130 55 126;...
    25 2.4 -0.54 0.44 160 64 155;...
    20 2.8 -0.64 0.36 160 80 170;...
    15 3.3 -0.7 0.35 210 90 207;...
    10 3.8 -0.62 0.33 330 113 247];

SADane(:,2:3)=SADane(:,2:3)*5.911;
SADane(:,5:7)=SADane(:,5:7)/60.2;

baseSet = ([-0.0;0.0;-0.0;0.0;...
   -0.307;0.062;-0.58;-0.041;-0.721;-0.38;...
    -0.1;-0.045;-0.25;-0.03;-0.6;-0.27]);
sv = matfile('strojenieWynik.mat');
initialSet = sv.finalSet;

hydroSet = initialSet; %aktualnie badany
previousHydroSet = initialSet; %u¿ywany do porównania
finalSet = initialSet; %zwracany jako wynik

dataModel = generujTrajektorie("nawigator", 35, duration, 5.911, true, hydroSet);
ocena = ocenaTrajektorii(35,dataModel, 10.18);
% skalowanie 
ocena(2:3)=ocena(2:3)*5.911;
ocena(5:7)=ocena(5:7)/60.2;
e = stopienBledu(ocena(:),SADane(1,:));
ePrev = e;
%% STROJENIE

if order == 1
a = [number];    
else
a = [1 2 3 4 5 6 7 8 9 10 11 12];
a = a(randperm(length(a)));
end
% pêtla numer 1 -> wybór parametru do strojenia
for var=1:length(a)
    %+
    for i=1:trials
        % testowa wartoœæ strojonego parametru
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
        ocena = ocenaTrajektorii(35,dataModel, 10.18);
        % skalowanie 
        ocena(2:3)=ocena(2:3)*5.911;
        ocena(5:7)=ocena(5:7)/60.2;
        stopienBledu(ocena(:),SADane(1,:));
        ePrev = e;
        if metoda == 0
            % porównaj b³êdy wzglêdne, jeœli obecny lepszy, zast¹p
            eDif = (e - ePrev)/ePrev;
            % ocena i nadpisanie
            if sum(eDif) < 0
                trials=trials-1;
                 ePrev = e;
                 previousHydroSet = hydroSet;
            end
        else
            % porównaj b³êdy bezwzglêdne, jeœli obecny lepszy, zast¹p
            % ocena i nadpisanie
            if e - (ePrev) < 0
                trials=trials-1;
                 ePrev = e;
                 previousHydroSet = hydroSet;
            end
        end
    end
    %-
    for i=1:trials
        % testowa wartoœæ strojonego parametru
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
        ocena = ocenaTrajektorii(35,dataModel, 10.18);
        % skalowanie 
        ocena(2:3)=ocena(2:3)*5.911;
        ocena(5:7)=ocena(5:7)/60.2;
        stopienBledu(ocena(:),SADane(1,:));
        ePrev = e;
        if metoda == 0
            % porównaj b³êdy wzglêdne, jeœli obecny lepszy, zast¹p
            eDif = (e - ePrev)/ePrev;
            % ocena i nadpisanie
            if (eDif) < 0
                trials=trials-1;
                 ePrev = e;
                 previousHydroSet = hydroSet;
            end
        else
            % porównaj b³êdy bezwzglêdne, jeœli obecny lepszy, zast¹p
            % ocena i nadpisanie
            if (e) - (ePrev) < 0
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
if ~isequal(initialSet,finalSet)
    disp("Znaleziono lepszy zestaw o sumarycznym b³êdzie: " + sum(ePrev));
    save('strojenieWynik.mat','finalSet');
    c = (ePrev);
else
    disp("Nie tym razem :(");
    c = (ePrev);
end
if figures == true
     close all
     dataModel = generujTrajektorie("nawigator", 35, duration, 5.911, true, finalSet);
     porownanieWykresy;
end
end