function LAData = loadAis(name)
%% WCZYTANIE PLIKU TEKSTOWEGO I PODZIA£ NA LINIE 
fileID=fopen(name + ".txt",'r');
formatSpec = '%c';
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
LAData = zeros([length,20]);
for i=1:length
    dataString = raw2(i);
    dataString = split(string(dataString),",");
     LAData(i,1) = i;%iteration
     LAData(i,2) = dataString(7); %x, longitude
     LAData(i,3) = dataString(8); %y, latitude
     LAData(i,4) = dataString(6); %velocity
     LAData(i,5) = dataString(10); %heading
     LAData(i,6) = dataString(9);%cog ais
     LAData(i,7) = 0;%cog calculated
     LAData(i,8) = 0;%sog calculated
     LAData(i,9) = i;%rotation
     LAData(i,10) = i;%delta czas
end
end