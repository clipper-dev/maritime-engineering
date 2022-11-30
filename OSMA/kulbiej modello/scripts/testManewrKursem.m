%dla sytuacji nawigacyjnej wykresla krzywa osiagnietego CPA w funkcji
%odleglosci miedzy statkami gdy zostanie wykonany manewr. do trzech
%wariantow zmiany kursu.
close all; clc; clear
v1=shipDefault("nawigator",666,0,0,100);
v2=shipDefault("nawigator",666,0,0,100);
%% parametry sterujące
obrysy=false;
zmiana1=0;
zmiana2=0;
zmiana3=0;
precision=1;
limit=15000;
wyniki=zeros(4,limit/precision);
dziedzina=zeros(1,limit/precision);
bearing=45;
course=270;
courseOwn=0;
initial=50;
%% mechanika
for i=1:limit/precision
    d1=initial+i*precision;
    dziedzina(1,i)=d1;
    v2=v2.updateShip([d1*sin(bearing/57.3) d1*cos(bearing/57.3) 0 0 0 course/57.3 666 0 0 0 0 0]);
    if obrysy
    %wyjsciowa sytuacja
    v1=v1.updateShip([0 0 0 0 0 courseOwn/57.3 666 0 0 0 0 0]);
    wyniki(1,i)=cpaOutline(v1,v2,1);
    %zmiana1
    v1=v1.updateShip([0 0 0 0 0 (courseOwn+zmiana1)/57.3 5.81*0.9 0 0 0 0 0]);
    wyniki(2,i)=cpaOutline(v1,v2,1);
    %zmiana2
    v1=v1.updateShip([0 0 0 0 0 (courseOwn+zmiana2)/57.3 5.81*0.8 0 0 0 0 0]);
    wyniki(3,i)=cpaOutline(v1,v2,1);
    %zmiana3
    v1=v1.updateShip([0 0 0 0 0 (courseOwn+zmiana3)/57.3 5.81*0.7 0 0 0 0 0]);
    wyniki(4,i)=cpaOutline(v1,v2,1);  
    else
    %wyjsciowa sytuacja
    v1=v1.updateShip([0 0 0 0 0 (courseOwn+zmiana3)/57.3 5.81 0 0 0 0 0]);
    wyniki(1,i)=cpa(v1,v2);
    %zmiana1
    v1=v1.updateShip([0 0 0 0 0 (courseOwn+zmiana3)/57.3 5.81*0.9 0 0 0 0 0]);
    wyniki(2,i)=cpa(v1,v2);
    %zmiana2
    v1=v1.updateShip([0 0 0 0 0 (courseOwn+zmiana3)/57.3 5.81*0.75 0 0 0 0 0]);
    wyniki(3,i)=cpa(v1,v2);
    %zmiana3
    v1=v1.updateShip([0 0 0 0 0 (courseOwn+zmiana3)/57.3 5.81*0.5 0 0 0 0 0]);
    wyniki(4,i)=cpa(v1,v2);
    end
end

%% wykres
%przeskalowanko
dziedzina=dziedzina/1852;
wyniki=wyniki/1852;
figure
hold on
xlabel("Odległość między statkami w chwili wykonania manewru [Nm]");
ylabel("Osiągnięta odległość minięcia CPA [Nm]");
plot(dziedzina(1,:),wyniki(2,:));
plot(dziedzina(1,:),wyniki(3,:));
plot(dziedzina(1,:),wyniki(4,:));
x = xlim; % current y-axis limits
plot([x(1) x(2)],[1 1]);
legend('zmiana prędkości o 10%','zmiana prędkości o 25%','zmiana prędkości o 50%');

