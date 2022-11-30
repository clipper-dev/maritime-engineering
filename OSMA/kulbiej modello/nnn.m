%% Wczytywanie danych
clc;clear all; close all;
% current
%
% loading ships data
[a,b]=navigationalSituation(38);

% create two dimentiional array for data
res = zeros(10000,10);
i = 1210;
tic
while true
    wynik = hdgChange(a,b,1852,1/57.3,true)
    if wynik == false || wynik == true
        break
    end
    res(i,1) = i;
    res(i,2) = wynik;
    res(i,3) = wynik + a.heading;
    res(i,4) = (wynik + a.heading) * 57.3;
    res(i,5) = wynik * 57.3;
    res(i,6) = a.heading;
    res(i,7) = distance(a,b);
    i = i + 1;
    a = a.calculateMovement(1,-1);
    b = b.calculateMovement(1,-1);
    if i == 10000
        break
    end
end
toc
disp("Fini")