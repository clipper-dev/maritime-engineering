clc;clear all
xx3=matfile('n7.mat');
betterSet=xx3.betterSet;
shipVector.isOwnSet = true;
shipVector.ownSet = betterSet;
steeringVector = [100 35];%maszyna i ster
calculusVector = [1 1 1];
initialStateVector1 = [0 0 0 0 0 0 5.81 0 0 0 0 0];
initialStateVector2 = [0 0 0 0 0 0 5.81*0.8 0 0 0 0 0];
environmentVector.isWeather = false;
environmentVector.weather = weather(0,0,0,0,0);
environmentVector.isShallow = false;
environmentVector.depth = 100;
a = shipLoad3("nawigator", shipVector, steeringVector, calculusVector, initialStateVector1, environmentVector,'r','rect2');
b = shipLoad3("nawigator", shipVector, steeringVector, calculusVector, initialStateVector2, environmentVector,'b','rect2');

initialDist = 50;
bearing = 345;
course = 75;
precision=1;
limit=4500;
d1=initialDist;
for j=1:limit/precision
    b=b.updateShip([d1*sin(bearing/57.3) d1*cos(bearing/57.3) 0 0 0 course/57.3 5.81 0 0 0 0 0]);
    distData(j)=distance(a,b);
    [dist,results]=distanceOutline(a.x,a.y,a.heading,b.x,b.y,b.heading,a,b);
    distDataOutline(j)=dist;
    newData(j)=(distData(j)-distDataOutline(j))/distData(j);
    d(j)=d1;    
    d1=initialDist+j*precision;
end

%surf(cpaData)
figure
hold on

plot(d/60,newData*100);
xlabel('odległość w długościach statku własnego [-]');
ylabel('różnica w odległościach [%]');
disp("Fini");