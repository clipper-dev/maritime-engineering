%% Wczytywanie danych
clc;clear all; close all;
% current
%
% loading ships data
[a,b]=navigationalSituation(38);

% create two dimentiional array for data
res = zeros(10000,10);
i = 1;
t=1;
tic
skip=1203;
while true
    for j=1:skip
    a = a.calculateMovement(1,-1);
    b = b.calculateMovement(1,-1);
        i = i + 1;
    end
    wynik = hdgChangeDynamic(a,b,1852,1/57.3,true,35)
    if wynik == false || wynik == true
        break
    end
    res(t,1) = i;
    res(t,2) = wynik;
    res(t,3) = wynik + a.heading;
    res(t,4) = (wynik + a.heading) * 57.3;
    res(t,5) = wynik * 57.3;
    res(t,6) = a.heading;
    res(t,7) = distance(a,b);
    
    t=t+1;
    if i == 10000
        break
    end
end
toc
disp("Fini")