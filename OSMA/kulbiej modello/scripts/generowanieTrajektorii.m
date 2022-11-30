
%% DANE STERUJ¥CE
drawOutlineEvery = 30;
time = 150;
timeStep = 1;
rudder = 35;
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
fileID=fopen('modele/nawigator.txt','r');
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
shipA = ship("Nawigator", commandMatrix, shipData, ownSet, false);     
%% G£ÓWNA SYMULACJA
gtTrajektoria = zeros(time,10);
gtWyniki = zeros(time,34);
gtWyniki2 = zeros(time,12);
if true
%% WYLICZENIA SI£
if false
    wyniki3 = zeros(40,20);
    r = .8;
    for i=1:41
        wyniki3(i,1)=i-21;
        betaAngle = (i-21)/57.3;
        r = -0.8;
        % Y'
        wyniki3(i,2) = -(shipData(30)*betaAngle + shipData(31)*r + ...
            shipData(32)*betaAngle^3 + ...
            shipData(33)*r^3 +...
            shipData(34)*betaAngle*r^2+...
            shipData(35)*betaAngle*betaAngle*r); 
        % N'
        wyniki3(i,3) = -(shipData(36)*betaAngle + shipData(37)*r + ...
            shipData(38)*betaAngle^3 + ...
            shipData(39)*r^3 +...
            shipData(41)*betaAngle*r^2+...
            shipData(40)*betaAngle*betaAngle*r);
        r = -0.6;
        % Y'
        wyniki3(i,4) = -(shipData(30)*betaAngle + shipData(31)*r + ...
            shipData(32)*betaAngle^3 + ...
            shipData(33)*r^3 +...
            shipData(34)*betaAngle*r^2+...
            shipData(35)*betaAngle*betaAngle*r); 
        % N'
        wyniki3(i,5) = -(shipData(36)*betaAngle + shipData(37)*r + ...
            shipData(38)*betaAngle^3 + ...
            shipData(39)*r^3 +...
            shipData(41)*betaAngle*r^2+...
            shipData(40)*betaAngle*betaAngle*r);
        r = -0.4;
        % Y'
        wyniki3(i,6) = -(shipData(30)*betaAngle + shipData(31)*r + ...
            shipData(32)*betaAngle^3 + ...
            shipData(33)*r^3 +...
            shipData(34)*betaAngle*r^2+...
            shipData(35)*betaAngle*betaAngle*r); 
        % N'
        wyniki3(i,7) = -(shipData(36)*betaAngle + shipData(37)*r + ...
            shipData(38)*betaAngle^3 + ...
            shipData(39)*r^3 +...
            shipData(41)*betaAngle*r^2+...
            shipData(40)*betaAngle*betaAngle*r);
        r = -0.2;
        % Y'
        wyniki3(i,8) = -(shipData(30)*betaAngle + shipData(31)*r + ...
            shipData(32)*betaAngle^3 + ...
            shipData(33)*r^3 +...
            shipData(34)*betaAngle*r^2+...
            shipData(35)*betaAngle*betaAngle*r); 
        % N'
        wyniki3(i,9) = -(shipData(36)*betaAngle + shipData(37)*r + ...
            shipData(38)*betaAngle^3 + ...
            shipData(39)*r^3 +...
            shipData(41)*betaAngle*r^2+...
            shipData(40)*betaAngle*betaAngle*r);
        r = -0.0;
        % Y'
        wyniki3(i,10) = -(shipData(30)*betaAngle + shipData(31)*r + ...
            shipData(32)*betaAngle^3 + ...
            shipData(33)*r^3 +...
            shipData(34)*betaAngle*r^2+...
            shipData(35)*betaAngle*betaAngle*r); 
        % N'
        wyniki3(i,11) = -(shipData(36)*betaAngle + shipData(37)*r + ...
            shipData(38)*betaAngle^3 + ...
            shipData(39)*r^3 +...
            shipData(41)*betaAngle*r^2+...
            shipData(40)*betaAngle*betaAngle*r);
        r = +0.2;
        % Y'
        wyniki3(i,12) = -(shipData(30)*betaAngle + shipData(31)*r + ...
            shipData(32)*betaAngle^3 + ...
            shipData(33)*r^3 +...
            shipData(34)*betaAngle*r^2+...
            shipData(35)*betaAngle*betaAngle*r); 
        % N'
        wyniki3(i,13) = -(shipData(36)*betaAngle + shipData(37)*r + ...
            shipData(38)*betaAngle^3 + ...
            shipData(39)*r^3 +...
            shipData(41)*betaAngle*r^2+...
            shipData(40)*betaAngle*betaAngle*r);
        r = +0.4;
        % Y'
        wyniki3(i,14) = -(shipData(30)*betaAngle + shipData(31)*r + ...
            shipData(32)*betaAngle^3 + ...
            shipData(33)*r^3 +...
            shipData(34)*betaAngle*r^2+...
            shipData(35)*betaAngle*betaAngle*r); 
        % N'
        wyniki3(i,15) = -(shipData(36)*betaAngle + shipData(37)*r + ...
            shipData(38)*betaAngle^3 + ...
            shipData(39)*r^3 +...
            shipData(41)*betaAngle*r^2+...
            shipData(40)*betaAngle*betaAngle*r);
        r = +0.6;
        % Y'
        wyniki3(i,16) = -(shipData(30)*betaAngle + shipData(31)*r + ...
            shipData(32)*betaAngle^3 + ...
            shipData(33)*r^3 +...
            shipData(34)*betaAngle*r^2+...
            shipData(35)*betaAngle*betaAngle*r); 
        % N'
        wyniki3(i,17) = -(shipData(36)*betaAngle + shipData(37)*r + ...
            shipData(38)*betaAngle^3 + ...
            shipData(39)*r^3 +...
            shipData(41)*betaAngle*r^2+...
            shipData(40)*betaAngle*betaAngle*r);
        r = +0.8;
        % Y'
        wyniki3(i,18) = -(shipData(30)*betaAngle + shipData(31)*r + ...
            shipData(32)*betaAngle^3 + ...
            shipData(33)*r^3 +...
            shipData(34)*betaAngle*r^2+...
            shipData(35)*betaAngle*betaAngle*r); 
        % N'
        wyniki3(i,19) = -(shipData(36)*betaAngle + shipData(37)*r + ...
            shipData(38)*betaAngle^3 + ...
            shipData(39)*r^3 +...
            shipData(41)*betaAngle*r^2+...
            shipData(40)*betaAngle*betaAngle*r);
    end
    figure
    hold on;
grid on;
    plot(wyniki3(:,1),wyniki3(:,2))
    plot(wyniki3(:,1),wyniki3(:,4))
    plot(wyniki3(:,1),wyniki3(:,6))
    plot(wyniki3(:,1),wyniki3(:,8))
    plot(wyniki3(:,1),wyniki3(:,10))
    plot(wyniki3(:,1),wyniki3(:,12))
    plot(wyniki3(:,1),wyniki3(:,14))
    plot(wyniki3(:,1),wyniki3(:,16))
    plot(wyniki3(:,1),wyniki3(:,18))
    legend("Y', r=-0.8","Y', r=-0.6","Y', r=-0.4",...
        "Y', r=-0.2","Y', r=0.0","Y', r=0.2",...
        "Y', r=-0.4","Y', r=0.6","Y', r=0.8");
    hold off;
    figure
    hold on;
grid on;
    plot(wyniki3(:,1),wyniki3(:,3))
    plot(wyniki3(:,1),wyniki3(:,5))
    plot(wyniki3(:,1),wyniki3(:,7))
    plot(wyniki3(:,1),wyniki3(:,9))
    plot(wyniki3(:,1),wyniki3(:,11))
    plot(wyniki3(:,1),wyniki3(:,13))
    plot(wyniki3(:,1),wyniki3(:,15))
    plot(wyniki3(:,1),wyniki3(:,17))
    plot(wyniki3(:,1),wyniki3(:,19))
    legend("N', r=-0.8","N', r=-0.6","N', r=-0.4",...
        "N', r=-0.2","N', r=0.0","N', r=0.2",...
        "N', r=-0.4","N', r=0.6","N', r=0.8");
    hold off;
    
end

for i=1:time
   shipA = shipA.calculateMovement(1,"euler");
   gtTrajektoria(i,1) = i;
   gtTrajektoria(i,2) = shipA.x;
   gtTrajektoria(i,3) = shipA.y;
   gtTrajektoria(i,4) = shipA.heading*57.3;
   gtTrajektoria(i,5) = shipA.wz*shipA.length/shipA.speed;

   gtWyniki(i,1) = shipA.Acc(1);
   gtWyniki(i,2) = shipA.Acc(2);
   gtWyniki(i,3) = shipA.Acc(3);
   gtWyniki(i,4) = shipA.speed;
   gtWyniki(i,5) = shipA.vx;
   gtWyniki(i,6) = shipA.vy;
   gtWyniki(i,7) = shipA.wz;
   gtWyniki(i,8) = shipA.jj;
   gtWyniki(i,9) = shipA.kt;
   gtWyniki(i,10) = atan(shipA.vy/shipA.vx);
   
   gtWyniki(i,11) = shipA.Xhull;
   gtWyniki(i,12) = shipA.Xrudder;
   gtWyniki(i,13) = shipA.Xpropeller;
   gtWyniki(i,14) = shipA.B(1);
   gtWyniki(i,15) = shipA.Xpropeller + shipA.Xhull + shipA.Xrudder + shipA.B(1);
   gtWyniki(i,16) = shipA.Yhull;
   gtWyniki(i,17) = shipA.Yrudder;
   gtWyniki(i,18) = shipA.B(2);
   gtWyniki(i,19) = shipA.Yhull + shipA.Yrudder + shipA.B(2);
   gtWyniki(i,20) = shipA.Nhull;
   gtWyniki(i,21) = shipA.Nrudder;
   gtWyniki(i,22) = shipA.Nhull+shipA.Nrudder;
   gtWyniki(i,23) = shipA.B(3);

   gtWyniki2(i,6) = shipA.vx;
   gtWyniki2(i,7) = shipA.vy;
end
%% PLOTTING
close all
if true
%trajektoria
f1 = figure;grid on
movegui(f1,[50,800]);
plot(gtTrajektoria(:,2),gtTrajektoria(:,3))
axis equal
hold on;
%pozycje statku
for i=1:time
   if mod(i,drawOutlineEvery)==0
       outline = zeros(6,2);
       angle = (360 - gtTrajektoria(i,4))/57.3 + atan(gtWyniki2(i,7)/gtWyniki2(i,6));
       %P1
       outline(1,1)=gtTrajektoria(i,2)...
           -0.4*shipA.length*sin(angle)-0.5*shipA.breadth*cos(angle);
       outline(1,2)=gtTrajektoria(i,3)...
           +0.4*shipA.length*cos(angle)-0.5*shipA.breadth*sin(angle);
       %P2 - dziób
       outline(2,1)=gtTrajektoria(i,2)-0.5*shipA.length*sin(angle);
       outline(2,2)=gtTrajektoria(i,3)+0.5*shipA.length*cos(angle);
       %P3
       outline(3,1)=gtTrajektoria(i,2)...
           -0.4*shipA.length*sin(angle)+0.5*shipA.breadth*cos(angle);
       outline(3,2)=gtTrajektoria(i,3)...
           +0.4*shipA.length*cos(angle)+0.5*shipA.breadth*sin(angle);
       %P4
       outline(4,1)=gtTrajektoria(i,2)...
           +0.4*shipA.length*sin(angle)+0.5*shipA.breadth*cos(angle);
       outline(4,2)=gtTrajektoria(i,3)...
           -0.4*shipA.length*cos(angle)+0.5*shipA.breadth*sin(angle);
       %P5
       outline(5,1)=gtTrajektoria(i,2)...
           +0.4*shipA.length*sin(angle)-0.5*shipA.breadth*cos(angle);
       outline(5,2)=gtTrajektoria(i,3)...
           -0.4*shipA.length*cos(angle)-0.5*shipA.breadth*sin(angle);
       %P1 jeszcze raz ¿eby zamkn¹æ krzyw¹
       outline(6,1)=outline(1,1);
       outline(6,2)=outline(1,2);
       plot(outline(:,1),outline(:,2));
   end
end
f2=figure;grid on
movegui(f2,[650,800]);
hold on;
plot(gtTrajektoria(:,1),gtWyniki2(:,6))
plot(gtTrajektoria(:,1),gtWyniki2(:,7))
plot(gtTrajektoria(:,1),atan(gtWyniki2(:,7)/gtWyniki2(:,6)))
legend('V_X', 'V_Y', 'Ratio');
hold off;
%kurs i k¹t drogi
f3=figure;grid on
movegui(f3,[1250,800]);
hold on;
plot(gtTrajektoria(:,1), gtTrajektoria(:,4))
plot(gtTrajektoria(:,1), gtTrajektoria(:,4)+atan(gtWyniki2(:,7)/gtWyniki2(:,6))*57.3)
legend('HDG', 'COG');
hold off;
f4=figure;grid on
movegui(f4,[1850,800]);
plot(gtTrajektoria(:,1),gtTrajektoria(:,5));
legend("r'");


    
end
end
%% KOMENTARZE
shipA.vx;
shipA.vx*shipA.vx;
shipA.vy*shipA.vy;
vn = sqrt(shipA.vx^2 + shipA.vy^2);
comment = "Koñcowa prêdkoœæ statku to " + vn + ...
    "m/s. Spadek prêdkoœci do " + 100*vn/commandMatrix(6) + "% wartoœci pocz¹tkowej";