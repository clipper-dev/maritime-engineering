clc;clear all;
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

initialDist = 55*60;
bearing = 345;
course = 75;
b=b.updateShip([initialDist*sin(bearing/57.3) initialDist*cos(bearing/57.3) 0 0 0 course/57.3 5.81 0 0 0 0 0]);
dd=distance(a,b);
[dist,results]=distanceOutline(a.x,a.y,a.heading,b.x,b.y,b.heading,a,b);
ddd=100*(dd-dist)/dd
