function c = awp(order, number, figures, tabelaWzorzec, predkoscWaga, odlegloscWaga)
%% DANE WEJŒCIOWE
errorLevel = 5;
metoda = 1; %0 - wzglêdny, 1 - bezwzlêdny b³¹d
e = zeros(7,1);ePrev = zeros(7,1);eDif = zeros(7,1);eBest = zeros(7,1); %przechowywanie macierzy b³êdów
duration = 200;
tuningRange = 1; %w wielkokrotoœciach +/- wartoœci wejœciowej 
tuningStep = 0.01; %w wielkokrotoœciach wartoœci wejœciowej 
trials = 6;%floor(tuningRange/tuningStep);
%% LOAD SEQUENCE %wzorcowe wartoœci

baseSet = ([-0.0;0.0;-0.0;0.0;...
   -0.307;0.062;-0.58;-0.041;-0.721;-0.38;...
    -0.1;-0.045;-0.25;-0.03;-0.6;-0.27]);
sv = matfile('strojenieWynik.mat');
initialSet = sv.finalSet;
hydroSet = initialSet; %aktualnie badany
previousHydroSet = initialSet; %u¿ywany do porównania
finalSet = 6;%initialSet; %zwracany jako wynik
%% PIERWSZY POMIAR B£ÊDU TRAJEKTORII
hydroSet = hydroZnaki(hydroSet);
tabelaModel = tabelaManewr("nawigator",duration,5.911,hydroSet,60, predkoscWaga, odlegloscWaga);
for p=1:errorLevel
   e(p)=stopienBledu(tabelaModel(p,:),tabelaWzorzec(p,:)); 
end
ePrev = e;

%% STROJENIE

if order == 1
a = [number];    
else
a = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16];
%a = [5 6 11 12];
a = a(randperm(length(a)));
end
% pêtla numer 1 -> wybór parametru do strojenia
for var=1:length(a)
    %% +
    for i=1:trials
        % testowa wartoœæ strojonego parametru
        hydroDif = 1/2^trials;
        if order == 2
           hydroDif = rand(); 
        end
        hydroSet(a(var)) = previousHydroSet(a(var))*(1+hydroDif);
        %hydroSet(a(var)) = initialSet(a(var))*(1 - i*tuningStep);
        % tymczasowy set
        if order == 3
           for j=1:12
              hydroSet(j)=hydroSet(j)*(1-2*rand()); 
           end
        end
        % oblicz ponownie b³¹d
        hydroSet = hydroZnaki(hydroSet);
        tabelaModel = tabelaManewr("nawigator",duration,5.911,hydroSet,60, predkoscWaga, odlegloscWaga);
        for p=1:errorLevel
           e(p)=stopienBledu(tabelaModel(p,:),tabelaWzorzec(p,:)); 
        end
        %% PORÓWNANIE B£ÊDÓW
        if metoda == 0
            % porównaj b³êdy wzglêdne, jeœli obecny lepszy, zast¹p
            for p=1:errorLevel
                e(p)=(e(p) - ePrev(p))/ePrev(p); 
            end
            % ocena i nadpisanie
            if sum(eDif) < 0
                trials=trials-1;
                ePrev = e;
                previousHydroSet = hydroSet;
            end
        else
            % porównaj b³êdy bezwzglêdne, jeœli obecny lepszy, zast¹p
            % ocena i nadpisanie
            if sum(e) - sum(ePrev) < 0
                trials=trials-1;
                 ePrev = e;
                 previousHydroSet = hydroSet;
            end
        end
    end
    %% -
    for i=1:trials
        % testowa wartoœæ strojonego parametru
        hydroDif = -1/2^trials;
        if order == 2
           hydroDif = -rand(); 
        end
        hydroSet(a(var)) = previousHydroSet(a(var))*(1+hydroDif);
        %hydroSet(a(var)) = initialSet(a(var))*(1 - i*tuningStep);
        % tymczasowy set
        
        if order == 3
           for j=1:12
              hydroSet(j)=hydroSet(j)*(1-2*rand()); 
           end
        end
        % oblicz ponownie b³¹d
        hydroSet = hydroZnaki(hydroSet);
        tabelaModel = tabelaManewr("nawigator",duration,5.911,hydroSet,60, predkoscWaga, odlegloscWaga);
        for p=1:errorLevel
           e(p)=stopienBledu(tabelaModel(p,:),tabelaWzorzec(p,:)); 
        end
        %% PORÓWNANIE B£ÊDÓW
        if metoda == 0
            % porównaj b³êdy wzglêdne, jeœli obecny lepszy, zast¹p
            for p=1:errorLevel
                e(p)=(e(p) - ePrev(p))/ePrev(p); 
            end
            % ocena i nadpisanie
            if sum(eDif) < 0
                trials=trials-1;
                ePrev = e;
                previousHydroSet = hydroSet;
            end
        else
            % porównaj b³êdy bezwzglêdne, jeœli obecny lepszy, zast¹p
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
    disp("Znaleziono lepszy zestaw o sumarycznym b³êdzie: " + sum(ePrev));
    save('strojenieWynik.mat','finalSet');
else
    disp("Nie tym razem :( B³¹d wci¹¿ " + c);
end
if figures == true
     close all
     dataModel = generujTrajektorie("nawigator", 35, duration, 5.911, true, finalSet);
     porownanieWykresy;
end
end