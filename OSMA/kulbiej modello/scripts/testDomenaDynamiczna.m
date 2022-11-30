% wyznaczenie punktu LMM dla konkretnego namiaru względnego na którym widzi
% się statek obcy o ustalonym kursie i prędkości
clc;clear all;close all
%% SCENARIUSZ
english = true;
naviScenario=25;
coop=false;
outlines = true;
rudderA=-35;
rudderB=0;
timeStep=1;
distanceStep = 10;
bearing = 0;

%% dane sterujące
if ~coop
    rudderB=0;
end
[a,b]=navigationalSituation(naviScenario);
[aPrev,bPrev]=navigationalSituation(naviScenario);
[aRef,bRef]=navigationalSituation(naviScenario);
cpaRequired = 10*(a.breadth+b.breadth);
elapsedTime=0;
exit=true;
simulationEndTime=50;
maxElapsedTime=500;
distanceLimit = 30*(a.length+b.length);
bearingPrecision = 1;
startingDistance = a.length;
%% pętla
koniec=false;
collision = false;
simulationEnd = false;
j=0;
% 1 - pobiera dane
% 2 - ustawia statek obcy na namiarze tuż przy statku własnym
% 3 - sprawdza czy lmm jest skuteczny
% 4 - jeśli tak to zwraca punkt, jeśli nie to przesuwa statek obcy o krok
% odległości dalej
% 5 - wykonuje algorytm aż znajdzie punkt lmm dla danego ustawienia na
% konkretnym namiarze
lmmData = zeros(360/bearingPrecision+1,2);
for i = 1:360/bearingPrecision
    bearing = i*bearingPrecision;
    distanceSimulated = startingDistance;
    aX = 0;
    aY = 0;
    bX = 0;
    bY = 0;
    while true
        % zresetowanie statków do warunków poczatkowych
        a=aRef;
        b=bRef;
        % zmiana pozycji obcego
        b.x = distanceSimulated*cos(deg2rad(bearing));
        b.y = distanceSimulated*sin(deg2rad(bearing));
        % symulacja LMM
        aXPrev = aX;
        aYPrev = aY;
        bXPrev = bX;
        bYPrev = bY;
        [collision,finish,aX, aY, bX, bY] = simulateLmm(a,b,rudderA, rudderB, timeStep, cpaRequired, outlines);
        if collision
            %jeśli nie było kolizji przesuwamy statek dalej
            distanceSimulated = distanceSimulated + distanceStep;
        else
            %jeśli była kolizja to poprzednia sytuacja to LMM właściwy
            lmmData(i,1) = - aX + bX;
            lmmData(i,2) = - aY + bY;
            break;
        end
        if distanceSimulated > distanceLimit
            simulationEnd = true;
            break;
        end
    end
end

disp("Fini");

%% Rysowanie domeny dynamicznej
% ustawianie pierwszego punktu jako ostatniego, żeby domnąć krzywą
lmmData(360/bearingPrecision+1,1)=lmmData(1,1);
lmmData(360/bearingPrecision+1,2)=lmmData(1,2);
% konfigurowanie figury
f1 = figure; hold on; axis equal; grid on;
% nazywanie tego co trzeba
if rudderA==0
    if english
        wlasnySter='own idle.';
    else
        wlasnySter='własny bezczynny.';
    end
elseif rudderA==35
    if english
        wlasnySter='own to starboard.';
    else
        wlasnySter='własny w prawo.';
    end
elseif rudderA==-35
    if english
        wlasnySter='own to port.';
    else
        wlasnySter='własny w lewo.';
    end
end
if english
    trajektoriaTytul="LMM dynamic domain for own ship with manoeuvre " + wlasnySter;
else
    trajektoriaTytul="Domena dynamiczna LMM dla statku własnego i manewru LMM: " + wlasnySter;
end
title(trajektoriaTytul);
xlabel('Y [m]');
ylabel('X [m]');
% rysowanie krzywej
plot(lmmData(:,2),lmmData(:,1));
% naniesienie statku własnego
a=aRef;
outlineA=drawOutline(a.x,a.y,a.heading,a,1);
plot(outlineA(:,1),outlineA(:,2),a.colour);
if english
    legend('LMM dynamic domain', 'outline of own ship');
else
    legend('domena dynamiczna LMM', 'sylwetka statku własnego');
end