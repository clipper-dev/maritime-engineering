clc
smoothed = true;
smoothFactor = 0.5;
modelowanieExp;
%% WYNIKI
% wyniki z exp
tacticalDiameterExp = 116.5;
advanceExp = 123.2;
transferExp = 55.2;
%r�nice procentowe
dTD = 100*(tacticalDiameter - tacticalDiameterExp)/tacticalDiameterExp;
dAd = 100*(advance - advanceExp)/advanceExp;
dTr = 100*(transfer - transferExp)/transferExp;
disp("Tactical diameter = " + tacticalDiameter + ", r�nica " + dTD + "%");
disp("Advance = " + advance + ", r�nica " + dAd + "%"+...
    ", transfer = " + transfer+ ", r4�nica " + dTr + "%");