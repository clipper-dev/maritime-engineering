%% funkcja inicowania wektora danych (wyników) symulacji
function[y]=rej_danych(dane,statek,ts)
%% wektor dane: 12-elementowy: 
%% 1- t,2- x,3- y,4- kurs,5- pr_kat 6-przyspkat 7-pr wzdl 8 pr pop 9- pred
%% 10 wych steru 11- nas steru 12 df
dane=[dane 
      ts statek.x statek.y statek.kurs statek.pk statek.przysp_katowe  ...
      statek.pr_wzdl statek.pr_pop statek.V statek.wych_steru statek.nast_steru ...
      statek.f(1) statek.f(2) statek.f(3) statek.f(4) statek.f(5) statek.f(6)];

y=dane;

