function [ship1, ship2] = navigationalSituation(number)
statki=["nawigator" "kcs" "kvlcc2"];
xx2=matfile('props/scenarios.mat');
dane=xx2.dane;
a=dane(number,1);
nazwa=statki(dane(number,1));
ship1=shipDefault3(statki(dane(number,1)),'r',dane(number,11));
ship2=shipDefault3(statki(dane(number,6)),'b',dane(number,11));
ship1=ship1.updateShip([dane(number,3) dane(number,2) ...
    0 0 0 dane(number,4)*pi/180 dane(number,5) 0 0 0 0 0]);
ship2=ship2.updateShip([dane(number,8) dane(number,7) ...
    0 0 0 dane(number,9)*pi/180 dane(number,10) 0 0 0 0 0]);
end