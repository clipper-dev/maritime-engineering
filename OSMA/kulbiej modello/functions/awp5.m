function c = awp5(order, number, figures, tabelaWzorzec, badaneParametry)
%% DANE WEJŒCIOWE
metoda = 1; %0 - wzglêdny, 1 - bezwzlêdny b³¹d
e = zeros(7,1);ePrev = zeros(7,1);eDif = zeros(7,1);eBest = zeros(7,1); %przechowywanie macierzy b³êdów
duration = 300;
tuningRange = 1; %w wielkokrotoœciach +/- wartoœci wejœciowej 
tuningStep = 0.001; %w wielkokrotoœciach wartoœci wejœciowej 
trials = floor(tuningRange/tuningStep);
%% LOAD SEQUENCE %wzorcowe wartoœci
sv = matfile('strojenieWynik.mat');
initialSet = sv.finalSet;
hydroSet = initialSet; %aktualnie badany
previousHydroSet = initialSet; %u¿ywany do porównania
finalSet = initialSet; %zwracany jako wynik
%% PIERWSZY POMIAR B£ÊDU TRAJEKTORII
hydroSet = hydroZnaki(hydroSet);
tabelaModel = tabelaManewr("nawigator",duration,5.911,hydroSet,60);
for p=1:7
   e(p)=stopienBledu(tabelaModel(:,p),tabelaWzorzec(:,p)); 
end
ePrev = e;
disp("B³¹d wejœciowy: " + sum(ePrev));

%% STROJENIE
% pêtla numer 1 -> wybór parametru do strojenia
k = 1;
lock = false;
while true
    % ustawianie iteratora pêtli
    if k > 15
        k = 1;
    else
        k = k+1;
    end
    if badaneParametry(k) > 0
       for i = 1:2*trials
           hydroSet(k) = initialSet(k) + (i/trials - 1);
           hydroSet = hydroZnaki(hydroSet);
           tabelaModel = tabelaManewr("nawigator",duration,5.911,hydroSet,60);
           for p=1:7
               e(p)=stopienBledu(tabelaModel(:,p),tabelaWzorzec(:,p)); 
           end
           if sum(e) - sum(ePrev) < 0
                ePrev = e;
                previousHydroSet = hydroSet;
                lock = true;
%            else
%                
%                 disp("Tym razem: " + sum(e));
           end
          
       end
       hydroSet = previousHydroSet;
    end
    disp(k + " fini");
    if k == 16
        if lock == false
            break;
        else
            finalSet = previousHydroSet;
            save('strojenieWynik.mat','finalSet');
            disp("Póki co najlepszu sumarycznym b³êdzie: " + sum(ePrev));
            lock = false;
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
    disp("Znaleziono niby najlepszy zestaw o sumarycznym b³êdzie: " + sum(ePrev));
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