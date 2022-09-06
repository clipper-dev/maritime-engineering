clc; close all; clear
pliki = "15full.txt";
% headingi = ([0 90 180 264]);
% xD = ([0 5 5 3]);
% yD = ([30 -5 0 -5]);
%% wczytanie pliku
   plik = convertStringsToChars(pliki);
   fileID=fopen(plik,'r');
   formatSpec = '%c';
   headingRotate = 90;
   xDelta = 0;
   yDelta = 0;
   aisMulti;
   dane=aisMultiData;