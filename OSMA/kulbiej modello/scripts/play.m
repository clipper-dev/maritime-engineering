clc
smoothed = true;
smoothFactor = 0.5;
modelowanieExp;
%% WYNIKI
% wyniki z exp
tacticalDiameterExp = 116.5;
advanceExp = 123.2;
transferExp = 55.2;
%ró¿nice procentowe
dTD = 100*(tacticalDiameter - tacticalDiameterExp)/tacticalDiameterExp;
dAd = 100*(advance - advanceExp)/advanceExp;
dTr = 100*(transfer - transferExp)/transferExp;
disp("Tactical diameter = " + tacticalDiameter + ", ró¿nica " + dTD + "%");
disp("Advance = " + advance + ", ró¿nica " + dAd + "%"+...
    ", transfer = " + transfer+ ", r4ó¿nica " + dTr + "%");