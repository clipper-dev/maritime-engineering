%% WCZYTANIE PLIKU TEKSTOWEGO I PODZIA£ NA LINIE 
fileID=fopen('obrobiona4.txt','r');
headingRotate = 270;
formatSpec = '%c';
xDelta = 0;
yDelta = 0;
tline = fgetl(fileID);
raw = cell(0,1);
while ischar(tline)
    raw{end+1,1} = tline;
    tline = fgetl(fileID);
end
fclose(fileID);
%% CZYSZCZENIE PLIKU
% USUNIÊCIE PUSTYCH LINII I NIECIEKAWYCH ZNACZKIKÓW AIS TAKICH JAK STRING
% OD WIATROMIERZA CZY OD INNYCH STATKÓW
length = size(raw);
raw2 = cell(0,1);
for i=1:length
    if contains(raw(i),'OWN')
        raw2{end+1,1} = raw(i);
    end
end
%% PODZIA£ STRINGÓW W PLIKU PO PRZECINKU
length = size(raw2);
length = length(1,1);
aisMultiData = zeros([length,19]);
obrocone = zeros([length,3]);
for i=1:length
    dataString = raw2(i);
    dataString = split(string(dataString),",");
     aisMultiData(i,1) = i;%iteration
     aisMultiData(i,2) = dataString(7); %x, longitude
     aisMultiData(i,3) = dataString(8); %y, latitude
     aisMultiData(i,4) = dataString(6); %velocity
     aisMultiData(i,5) = dataString(10); %heading
end
%% OBRÓBKA DANYCH
% zamiana stopni na metry X Y w relacji do punktu (0,0) odpowiadaj¹cego
% pozycji pocz¹tkowej

angle = (headingRotate)/57.3;
lambda0 = aisMultiData(1,2);
fi0 = aisMultiData(1,3);
for i=1:length
     aisMultiData(i,2) = ((aisMultiData(i,2)-lambda0)*cos(fi0/57.3))*...
         60*1852; %x, longitude, metry
     aisMultiData(i,3) = (aisMultiData(i,3)-fi0)*...
         60*1852; %y, latitude, metry
     aisMultiData(i,6) = xDelta - aisMultiData(i,3)*sin(angle) + aisMultiData(i,2)*cos(angle); %nowy x, przesuniêty i obrócony
     aisMultiData(i,7) = yDelta + aisMultiData(i,2)*sin(angle) + aisMultiData(i,3)*cos(angle); %nowy y, przesuniêty i obrócony
     aisMultiData(i,4) = aisMultiData(i,4)*0.514;
     aisMultiData(i,5) = aisMultiData(i,5) - headingRotate; %heading
end


   %% MAJSTROWANIE WYKRESU
   %trajektoria
close all
figure;
hold on; axis equal
plot(aisMultiData(:,6)/55,aisMultiData(:,7)/55);
