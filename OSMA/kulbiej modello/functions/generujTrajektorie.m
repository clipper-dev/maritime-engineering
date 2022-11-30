function GTData = generujTrajektorie(shipName, enginePercent, rudder, duration, initialSpeed, overRide, ownSet, isWeather, weather)
%generujTrajektorie(shipName, enginePercent, rudder, duration, initialSpeed, overRide, ownSet, isWeather, weather)
%% DANE STERUJ¥CE
drawOutlineEvery = 30;
time = duration;
timeStep = 1;
x0 = 0;
y0 = 0;
h0 = 0;
vx0 = initialSpeed;
vy0 = 0;
wz0 = 0;
deepWater = true;
hydroLevel = 2;
ownHydro = true;
%ownSet = ([-0.0606486486486487;0.0903783783783784;-0.000821621621621622;0.406724324324324;-0.332000000000000;0.0622702702702703;-0.946041666666667;-0.0377287878787879;-0.510833333333333;-0.100000000000000;-0.118918918918919;-0.0453177501826151;-0.108000000000000;-0.0300540540540541;-0.599135135135135;-0.213625000000000]);
commandMatrix = ([timeStep rudder x0 y0 h0 vx0 vy0 wz0 deepWater hydroLevel ownHydro enginePercent]);
%% WCZYTANIE MODELU STATKU Z PLIKU
%wczytanie pliku
fileID=fopen("modele/"+ shipName+".txt",'r');
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
shipA = ship("Nawigator", commandMatrix, shipData, ownSet, overRide, isWeather, weather);     
%% G£ÓWNA SYMULACJA
GTData = zeros(duration,40);
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
   GTData(i,1) = i;
   GTData(i,2) = shipA.x;
   GTData(i,3) = shipA.y;
   GTData(i,4) = shipA.heading*57.3;
   GTData(i,5) = shipA.wznd;
   GTData(i,6) = shipA.driftAngle;
   
   GTData(i,7) = shipA.speed;
   GTData(i,8) = shipA.vx;
   GTData(i,9) = shipA.vy;
   GTData(i,10) = shipA.wz;

   GTData(i,11) = shipA.Acc(1);
   GTData(i,12) = shipA.Acc(2);
   GTData(i,13) = shipA.Acc(3);
   GTData(i,14) = shipA.jj;
   GTData(i,15) = shipA.kt;
   
   GTData(i,16) = shipA.Xhull;
   GTData(i,17) = shipA.Xrudder;
   GTData(i,18) = shipA.Xpropeller;
   GTData(i,19) = shipA.Xair;
   GTData(i,20) = shipA.Xwave;
   GTData(i,21) = shipA.B(1);
   
   GTData(i,22) = shipA.Yhull;
   GTData(i,23) = shipA.Yrudder;
   GTData(i,24) = shipA.Yair;
   GTData(i,25) = shipA.Ywave;   
   GTData(i,26) = shipA.B(2);
   
   GTData(i,27) = shipA.Nhull;
   GTData(i,28) = shipA.Nrudder;
   GTData(i,29) = shipA.Nair;
   GTData(i,30) = shipA.Nwave;
   
%    
%    GTData(i,31) = shipA.apparentAngle;
%    GTData(i,32) = shipA.apparentSpeed;
   
   GTData(i,33) = shipA.h1;
   GTData(i,34) = shipA.h2;
   
   
end
end