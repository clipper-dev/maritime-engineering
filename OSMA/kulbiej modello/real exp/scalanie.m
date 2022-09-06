pliki = (["obrobiona1.txt" "25full.txt" "15full.txt" "5full.txt"]);
headingi = ([0 0 0 0]);
xD = ([0 0 0 0]);
yD = ([0 0 0 0]);
trajectoriesXY = double([150,10]);
velocitiesXY = double([150,10]);
rotationZ = double([150,4]);
for cyrkulacja=1:4
   plik = convertStringsToChars(pliki(cyrkulacja));
   fileID=fopen(plik,'r');
   formatSpec = '%c';
   headingRotate = headingi(cyrkulacja);
   xDelta = xD(cyrkulacja);
   yDelta = yD(cyrkulacja);
   aisMulti;
   lengths(cyrkulacja) = length;
   %% MAJSTROWANIE DANYCH DO WYKRESU WYKRESU
   %trajektoria
   trajectoriesXY(1:length,2*cyrkulacja-1) = aisMultiData(1:length,6);
   trajectoriesXY(1:length,2*cyrkulacja) = aisMultiData(1:length,7);
   velocitiesXY(1:length,2*cyrkulacja-1) = aisMultiData(1:length,8);
   velocitiesXY(1:length,2*cyrkulacja) = aisMultiData(1:length,9);
   rotationZ(1:length,cyrkulacja) = aisMultiData(1:length,11);
end