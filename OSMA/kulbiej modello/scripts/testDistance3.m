clc;clear all;close all
xx3=matfile('n7.mat');
betterSet=xx3.betterSet;
shipVector.isOwnSet = true;
shipVector.ownSet = betterSet;
steeringVector = [100 35];%maszyna i ster
calculusVector = [1 1 1];
initialStateVector1 = [0 0 0 0 0 0 5.81 0 0 0 0 0];
initialStateVector2 = [0 0 0 0 0 0 5.81 0 0 0 0 `0];
environmentVector.isWeather = false;
environmentVector.weather = weather(0,0,0,0,0);
environmentVector.isShallow = false;
environmentVector.depth = 100;
a = shipLoad3("nawigator", shipVector, steeringVector, calculusVector, initialStateVector1, environmentVector,'r','rect2');
b = shipLoad3("nawigator", shipVector, steeringVector, calculusVector, initialStateVector2, environmentVector,'b','rect2');

margin = 0.05;

initialDist = 50;
bearing = 0;
course = 0;
precision=1;
limit=5000;
d1=initialDist;
distData=zeros(360/precision,360/precision);
for i=1:360/precision
    bearing=i*precision;
    for j=1:360/precision
        course=j*precision;
        lock=false;
        d1=initialDist;
        for k=1:limit/precision
            b=b.updateShip([d1*sin(bearing/57.3) d1*cos(bearing/57.3) 0 0 0 course/57.3 5.81 0 0 0 0 0]);
            dd=distance(a,b);
            [dist,results]=distanceOutline(a.x,a.y,a.heading,b.x,b.y,b.heading,a,b);
            newDistance=(dd-dist)/dd;
            d1=initialDist+k*precision;
            if newDistance<margin || k==limit/precision
                distData(i,j)=d1/60;
                break;
            end
        end
    end
end


%surf(cpaData)
figure
surf(distData,'EdgeColor','None','facecolor', 'interp');
view(2);
xlabel(['Względny kurs statku przeciwnego [' char(176) ']']);
ylabel(['Względny początkowy namiar [' char(176) ']']);
axis equal tight
cb=colorbar;
ylabel(cb,'odległość granicy dokładności');
disp("Fini");