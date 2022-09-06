%% WCZYTANIE PLIKU TEKSTOWEGO I PODZIA£ NA LINIE 
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
     aisMultiData(i,7) = yDelta + aisMultiData(i,2)*sin(angle) + aisMultiData(i,3)*cos(angle); %nowy x, przesuniêty i obrócony
     aisMultiData(i,4) = aisMultiData(i,4)*0.514;
     aisMultiData(i,5) = aisMultiData(i,5) - headingRotate; %heading
     if i > 1
     aisMultiData(i,11) = aisMultiData(i,5) - aisMultiData(i-1,5); %rotation
     end
end
% COG calculated
for i=1:length
    
     if i < length-1
        %% COG
        deltaX = aisMultiData(i+1,6)-aisMultiData(i,6);%dx
        deltaY = aisMultiData(i+1,7)-aisMultiData(i,7);%dy
        if deltaX > 0 && deltaY == 0
            aisMultiData(i,10) = 90;
        elseif deltaX < 0 && deltaY == 0
            aisMultiData(i,10) = 270;
        elseif deltaX == 0 && deltaY == 0
            aisMultiData(i,10) = aisMultiData(5,10);
        elseif deltaX == 0 && deltaY > 0         
            aisMultiData(i,10) = 0;    
        elseif deltaX == 0 && deltaY < 0
            aisMultiData(i,10) = 180;    
        elseif deltaX > 0 && deltaY > 0
            aisMultiData(i,10) = atan(deltaX/deltaY)*57.3;    
        elseif deltaX > 0 && deltaY < 0
            aisMultiData(i,10) = 180+atan(deltaX/deltaY)*57.3;     
        elseif deltaX < 0 && deltaY < 0
            aisMultiData(i,10) = 180+atan(deltaX/deltaY)*57.3;     
        elseif deltaX < 0 && deltaY > 0
            aisMultiData(i,10) = 360+atan(deltaX/deltaY)*57.3;     
        end
         
     end
end
for i=1:length
   if i > 1
         speed = sqrt((aisMultiData(i,6) - aisMultiData(i-1,6))^2 + ...
             (aisMultiData(i,7) - aisMultiData(i-1,7))^2);
         beta = (aisMultiData(i,10) - aisMultiData(i,5))/57.3;
         aisMultiData(i,8) = speed*cos(beta);
         aisMultiData(i,9) = speed*sin(beta);
     end 
end
