function s = shipLoad3(shipName, shipVector, steeringVector, calculusVector, initialStateVector, environmentVector, colour, outline)
%generujTrajektorie(
%shipVector[isOwnSet - true or false, ownSet - matrix of hydrodynamic coefficients], 
%steeringVector[engineSetting - in percent from -100 to 100; rudder from %-35 to 35]
%calculusVector[duration - in seconds; timeStep -  >=1, defines how many iterations per second, calculusType - 0=eulerImplicit, 1=eulerExplicit, 2=rungeKutta]
%initialStateVecor[x0, y0, z0, roll, pitch, psi0, vx0; vy0; vz0; wx0; wy0; wz0] //accelerations defined to %be zero
%environmentVector[isWeather - true/false, weather - wx data object, isShallow - T/F, depth - value used for calculations]
%% WCZYTANIE MODELU STATKU Z PLIKU
%wczytanie pliku
fileID=fopen("modele/"+ shipName+".txt",'r');
formatSpec = '%c';
tline = fgetl(fileID);
raw = cell(0,1);
while ischar(tline)
    raw{end+1,1} = tline;
    tline = fgetl(fileID);
end
fclose(fileID);
% CZYSZCZENIE PLIKU
% USUNIÊCIE PUSTYCH LINII I KOMENTARZY
length = size(raw);
raw2 = cell(0,1);
for i=1:length
    if ~(contains(raw(i),'%'))
        raw2{end+1,1} = raw(i);
    end
end
% PODZIA£ STRINGÓW W PLIKU PO SPACJI
length = size(raw2);
length = length(1,1);
shipData = double([length]);
for i=1:length
    dataString = raw2(i);
    dataString = split(string(dataString));
    shipData(i) = dataString(2);
end
%% INICJALIZACJA
s = ship3(""+shipName, shipData, shipVector, steeringVector, calculusVector, initialStateVector, environmentVector,outline);
s.colour=colour;
end