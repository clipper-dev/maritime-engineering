clc;clear; close all
%% WCZYTANIE PLIKU TEKSTOWEGO I PODZIA£ NA LINIE 
readAisData = loadAis("wezowa 5 - 15");
sylwetki = true; coIle = 30;
%% PODZIA£ STRINGÓW W PLIKU PO PRZECINKU
length = size(readAisData);
length = length(1,1);
scope = 250;
readAisWyniki = zeros([length,10]);
%% OBRÓBKA DANYCH
% zamiana stopni na metry X Y w relacji do punktu (0,0) odpowiadaj¹cego
% pozycji pocz¹tkowej
headingRotate = 0;
lambda0 = readAisData(1,2);
fi0 = readAisData(1,3);
for i=1:length
     readAisData(i,2) = ((readAisData(i,2)-lambda0)*cos(fi0/57.3))*...
         60*1852; %x, longitude, metry
     readAisData(i,3) = (readAisData(i,3)-fi0)*...
         60*1852; %y, latitude, metry
     readAisData(i,4) = readAisData(i,4)*0.514;
     readAisData(i,5) = readAisData(i,5) - headingRotate; %heading
     if i > 1
        %wyliczone wartosci w kazdej klatce SOG i ROTATION
        readAisData(i,8) = sqrt((readAisData(i,2)-readAisData(i-1,2))^2 + (readAisData(i,3)-readAisData(i-1,3))^2);%przemieszczenie
        readAisData(i,9) = ((((readAisData(i,5)-readAisData(i-1,5))/57.3)*60.2)/6);%rotation
        
     else
        %default / poczatkowe wartosci
        readAisData(i,8) = readAisData(i,4);%przemieszczenie
        readAisData(i,7) = readAisData(i,5);%cog
        readAisData(i,9) = 0; %rotation
     end
     
end
% COG calculated
for i=1:length
    
     if i < length-1
         readAisData(i,10) = readAisData(i+1,2)-readAisData(i,2);%dx
         readAisData(i,11) = readAisData(i+1,3)-readAisData(i,3);%dy
        %% COG
        deltaX = readAisData(i,10);
        deltaY = readAisData(i,11);
        if deltaX > 0 && deltaY == 0
            readAisData(i,7) = 90;
        elseif deltaX < 0 && deltaY == 0
            readAisData(i,7) = 270;
        elseif deltaX == 0 && deltaY == 0
            readAisData(i,7) = readAisData(i-1,7);
        elseif deltaX == 0 && deltaY > 0         
            readAisData(i,7) = 0;    
        elseif deltaX == 0 && deltaY < 0
            readAisData(i,7) = 180;    
        elseif deltaX > 0 && deltaY > 0
            readAisData(i,7) = atan(deltaX/deltaY)*57.3;    
        elseif deltaX > 0 && deltaY < 0
            readAisData(i,7) = 180+atan(deltaX/deltaY)*57.3;     
        elseif deltaX < 0 && deltaY < 0
            readAisData(i,7) = 180+atan(deltaX/deltaY)*57.3;     
        elseif deltaX < 0 && deltaY > 0
            readAisData(i,7) = 360+atan(deltaX/deltaY)*57.3;     
        end
         
     end
end
% Vx, Vy, wZ
for i=1:length
    if i==1
        %v total
        readAisWyniki(i,1) = sqrt((readAisData(i,2)-readAisData(i+1,2))^2 + (readAisData(i,3)-readAisData(i+1,3))^2);
        %k¹ty
        readAisWyniki(i,2) = readAisData(i,7);%cog
        readAisWyniki(i,3) = readAisData(i,5);%heading
        readAisWyniki(i,4) = readAisData(i,5)-readAisData(i,7);%beta, k¹t dryfu
        %vx oraz vy
        readAisWyniki(i,5) = readAisWyniki(i,1)*cos(readAisWyniki(i,4)/57.3);%vx
        readAisWyniki(i,6) = readAisWyniki(i,1)*sin(readAisWyniki(i,4)/57.3);%vy
        %wz
        readAisWyniki(i,7) = 60*(readAisData(i+1,5)/57.3-readAisData(i,5)/57.3)/readAisWyniki(1,5);%wz
        
        
    elseif i < length-1
        
        %v total
        readAisWyniki(i,1) = 0.5*sqrt((readAisData(i-1,2)-readAisData(i+1,2))^2 + (readAisData(i-1,3)-readAisData(i+1,3))^2);
        %k¹ty
        readAisWyniki(i,2) = 0.5*(readAisData(i-1,7)+readAisData(i,7));%cog
        readAisWyniki(i,3) = readAisData(i,5);%heading
        readAisWyniki(i,4) = readAisData(i,5)-readAisData(i,7);%beta, k¹t dryfu
        %vx oraz vy
        readAisWyniki(i,5) = readAisWyniki(i,1)*cos(readAisWyniki(i,4)/57.3);%vx
        readAisWyniki(i,6) = readAisWyniki(i,1)*sin(readAisWyniki(i,4)/57.3);%vy
        %wz
        readAisWyniki(i,7) = 60*(readAisData(i+1,5)/57.3-readAisData(i,5)/57.3)/readAisWyniki(1,5);%wz    
    else

    end
end
%% MAJSTROWANIE WYKRESU
close all
%prêdkoœci
f1 = figure('Name','Prêdkoœci postêpowe');grid on
movegui(f1,[50,100]);
hold on;
plot(readAisWyniki(1:scope,5))
plot(readAisWyniki(1:scope,6))
ylabel('prêdkoœæ [m/s]') 
xlabel('czas [s]') 
legend('wzd³u¿na', 'poprzeczna');
hold off;
%prêdkoœæ k¹towa
f2 = figure('Name', 'Prêdkoœæ k¹towa'); grid on
movegui(f2,[50,500]);
hold on;
plot(readAisWyniki(1:scope,7))
ylabel('bezwymiarowa prêdkoœæ k¹towa [-]') 
xlabel('czas [s]') 
%legend('w_Z_N_D');
hold off;
%trajektoria
f3 = figure('Name','Trajektoria');grid on
movegui(f3,[650,100]);
hold on
%title('Trajektoria')
xlabel('X [m]') 
ylabel('Y [m]') 
plot(readAisData(1:scope,2)/55,readAisData(1:scope,3)/55);
%legend('measured');
axis equal
if sylwetki == true
    l = 60/55;
    b = 10.5/55;
   for i=1:scope
           if mod(i,coIle)==0
               outline = zeros(6,2);
               angle = (360 - readAisWyniki(i,3))/57.3;% + atan(dejDane(i,9)/dejDane(i,8));
               %P1
               outline(1,1)=readAisData(i,2)/55-...
                   0.4*l*sin(angle)-0.5*b*cos(angle);
               outline(1,2)=readAisData(i,3)/55+...
                   0.4*l*cos(angle)-0.5*b*sin(angle);
               %P2 - dziób
               outline(2,1)=readAisData(i,2)/55-0.5*l*sin(angle);
               outline(2,2)=readAisData(i,3)/55+0.5*l*cos(angle);
               %P3
               outline(3,1)=readAisData(i,2)/55-...
                   0.4*l*sin(angle)+0.5*b*cos(angle);
               outline(3,2)=readAisData(i,3)/55+...
                   0.4*l*cos(angle)+0.5*b*sin(angle);
               %P4
               outline(4,1)=readAisData(i,2)/55+...
                   0.4*l*sin(angle)+0.5*b*cos(angle);
               outline(4,2)=readAisData(i,3)/55-...
                   0.4*l*cos(angle)+0.5*b*sin(angle);
               %P5
               outline(5,1)=readAisData(i,2)/55+...
                   0.4*l*sin(angle)-0.5*b*cos(angle);
               outline(5,2)=readAisData(i,3)/55-...
                   0.4*l*cos(angle)-0.5*b*sin(angle);
               %P1 jeszcze raz ¿eby zamkn¹æ krzyw¹
               outline(6,1)=outline(1,1);
               outline(6,2)=outline(1,2);
               plot(outline(:,1),outline(:,2));
           
           end
   end
end
hold off