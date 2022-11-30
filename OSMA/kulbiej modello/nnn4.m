%% Wczytywanie danych
% generowanie tablicy z danymi symulacji 
clc;clear all; close all;
% current
%
% loading ships data
[a,b]=navigationalSituation(38);

% create two dimentiional array for data
res = zeros(10000,100);
i = 1;
moveSeconds = 0; %ile sekund przesunac statki od rozpoczecia symulacji
simulateSeconds = 300; %ile symulowac ruch statku A
rudder = 35; %wychylenie steru statku A w stopniach, od zera
tic
movedSeconds = 0;
while movedSeconds < moveSeconds
    a = a.calculateMovement(1,-1);
    b = b.calculateMovement(1,-1);
end
a = a.setRudderOrder(rudder/57.3);
while i < simulateSeconds
    % save data
    res(i,1) = a.x;
    res(i,2) = a.y;
    res(i,3) = b.x;
    res(i,4) = b.y;
    res(i,5) = a.rudderAngle;
    res(i,6) = b.rudderAngle;
    res(i,7) = a.speed;
    res(i,8) = b.speed;
    res(i,9) = a.heading;
    res(i,10) = b.heading;
    res(i,11) = distance(a,b);
    res(i,12) = distanceOutline(a.x,a.y,a.heading,b.x,b.y,b.heading,a,b);
    res(i,13) = cpa(a,b);
    res(i,14) = cpaOutline(a,b,1);
    i = i + 1;
    % move ships
    a = a.calculateMovement(1,1);
    b = b.calculateMovement(1,-1);
end
toc
disp("Fini")