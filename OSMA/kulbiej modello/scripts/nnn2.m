%% PRZYGOTOWANIE
clc; clear all
duration = 125;
constantOffset = 57;
sv = matfile('wzorzecND.mat');
badane = [0 0 0 0 5 6 7 8 9 10 11 12 13 14 15 16];
SADane = sv.SADane;
%% USTAWIENIA
while true
    result = awp5(0, 0, false, SADane, badane);
end
%% G£ÓWNA PÊTLA
