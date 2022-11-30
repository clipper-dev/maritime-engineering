%% DANE STERUJ¥CE
timeStep = 1;
rudder = -35;
x0 = 0;
y0 = 0;
h0 = 0;
vx0 = 5.911;
vy0 = 0;
wz0 = 0;
deepWater = true;
hydroLevel = 2;
ownHydro = true;
ownSet = ([-0.0606486486486487;0.0903783783783784;-0.000821621621621622;0.406724324324324;-0.332000000000000;0.0622702702702703;-0.946041666666667;-0.0377287878787879;-0.510833333333333;-0.100000000000000;-0.118918918918919;-0.0453177501826151;-0.108000000000000;-0.0300540540540541;-0.599135135135135;-0.213625000000000]);
commandMatrix = ([timeStep rudder x0 y0 h0 vx0 vy0 wz0 deepWater hydroLevel ownHydro]);
%% WCZYTANIE MODELU STATKU Z PLIKU
%wczytanie pliku
fileID=fopen('modele/'+shipToLoad+'.txt','r');
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
vessel = ship("Nawigator", commandMatrix, shipData, ownSet, false);    