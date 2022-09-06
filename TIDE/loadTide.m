function LTData = loadTide(name)
%% WCZYTANIE PLIKU TEKSTOWEGO I PODZIA£ NA LINIE 
fileID=fopen("DATA\" + name + ".txt",'r');
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
    if contains(raw(i),'/') || contains(raw(i),':')
        raw2{end+1,1} = raw(i);
    end
end

%% PODZIA£ STRINGÓW W PLIKU PO PRZECINKU
length = size(raw2);
length = length(1,1);
LTData = string([length,10]);
for i=1:length
    dataString = raw2(i);
    dataString = split(string(dataString)," ");
    if contains(dataString(1),'/')
       %linijka z data
       LTData(i,1) = i;%iteration
       LTData(i,2) = dataString(1);
       LTData(i,3) = ""; %
       LTData(i,4) = ""; %
       LTData(i,5) = ""; %
        
    elseif contains(dataString(1),'High')
        LTData(i,1) = i;%iteration
       LTData(i,2) = ""; %DD/MM/YYYY, data
       LTData(i,3) = dataString(2); %hh:mm, godzina
       LTData(i,4) = dataString(1); %high/low, rodzaj wody 
       if dataString(7) ~= "m"
           
            LTData(i,5) = dataString(7); %height, wysokosc plywu w metrach
       else
           
       LTData(i,5) = dataString(6); %height, wysokosc plywu w metrach
       end
    elseif contains(dataString(1),'Low') 
       LTData(i,1) = i;%iteration
       LTData(i,2) = ""; %DD/MM/YYYY, data
       LTData(i,3) = dataString(3); %hh:mm, godzina
       LTData(i,4) = dataString(1); %high/low, rodzaj wody 
       LTData(i,5) = dataString(8); %height, wysokosc plywu w metrach
        
    end
end
end