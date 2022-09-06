clc; clear; close all
timeScale=10;
%% algorytm
fileID=fopen('aaa.txt','r');
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
        raw2{end+1,1} = raw(i);
end
% PODZIA£ STRINGÓW W PLIKU PO SPACJI
length = size(raw2);
length = length(1,1);
wptData = zeros(length,7);
for i=1:length
    str1 = raw2(i);
    str2 = split(string(str1),[",","$"]);
    %% uzupe³nienie tablicy danymi waypointu
    wptData(i,1)=double(str2(1));
    if str2(2)=="AIS"
        wptData(i,2)=1; %obcy
    else
        wptData(i,2)=0; %w³asny
    end
    wptData(i,3)=double(str2(4)); %mmsi
    wptData(i,4)=double(str2(7)); %prêdkoœæ
    wptData(i,5)=double(str2(8)); %lat
    wptData(i,6)=double(str2(9)); %long
    wptData(i,7)=double(str2(10)); %kurs
end
a = size(unique(wptData(:,3)));
ships=a(1); %iloœæ statków
wptN=floor(length/ships);
fid = fopen( 'scenariusz3.txt', 'wt' );
for w=1:wptN-1
   %po waypointach
   time=wptData(wptN*ships,1)-wptData((wptN-1)*ships,1);
   for t=1:time*timeScale+1
       %po czasie
       %$OWN,0,261187000,0,-100000.0,11.4,18.944535,54.968094,357.1,1.0,0.0,0.0,,1,,,,,,,,,,,,,,,*70
       %<- gotowiec
       for i=1:ships
          %po statkach
          if wptData((w-1)*ships+i,2)==0
              type="OWN";
          else
              type="AIS";
          end
          lat=wptData((w-1)*ships+i,5)+((t-1)/(time*timeScale))*(wptData((w)*ships+i,5)-wptData((w-1)*ships+i,5));
          long=wptData((w-1)*ships+i,6)+((t-1)/(time*timeScale))*(wptData((w)*ships+i,6)-wptData((w-1)*ships+i,6));
          kurs=wptData((w-1)*ships+i,7)+((t-1)/(time*timeScale))*(wptData((w)*ships+i,7)-wptData((w-1)*ships+i,7));
          if(w==wptN-1 && t==time*timeScale+1 && i==ships)
            fprintf( fid, "$"+type+',0,'+wptData((w-1)*ships+i,3)+',0,'+wptData((w-1)*ships+i,4)+','+wptData((w-1)*ships+i,4)+','+long+','+lat+','+kurs+','+kurs+',0.0,0.0,,1,,,,,,,,,,,,,,,*70');
          else
            fprintf( fid, "$"+type+',0,'+wptData((w-1)*ships+i,3)+',0,'+wptData((w-1)*ships+i,4)+','+wptData((w-1)*ships+i,4)+','+long+','+lat+','+kurs+','+kurs+',0.0,0.0,,1,,,,,,,,,,,,,,,*70'+'\n');            
          end
       end
   end
end
fclose(fid);
