clc;clear all;close all
a=shipDefault3('nawigator','k','true');
enemyNumber=6;
dist = 100;
for i=1:enemyNumber
    armada(i)=shipDefault3('nawigator','b','true');
    bearing = 0+i*360/enemyNumber;
    course = 360*rand;
    armada(i)=armada(i).updateShip([dist*cos(bearing/57.3) dist*sin(bearing/57.3) 0 0 0 course/57.3 5.81 0 0 0 0 0]);
end

figure;hold on;axis equal;grid on;hold on;
xlabel('Y [m]');
ylabel('X [m]');
%narysowanie statków i odleg³oœci dla podgl¹du
outlineA=drawOutline(a.x,a.y,a.heading,a,1);
plot(outlineA(:,1),outlineA(:,2),a.colour);
for i=1:enemyNumber
    outlineArmada(i,:,:)=drawOutline(armada(i).x,armada(i).y,armada(i).heading,armada(i),1);
    plot(outlineArmada(i,:,1),outlineArmada(i,:,2),armada(i).colour);
    
    [dist,results]=distanceOutline(a.x,a.y,a.heading,armada(i).x,armada(i).y,armada(i).heading,a,armada(i));
    plot(results(:,2),results(:,1),'k');
    myText = sprintf('%.1f m', dist);
    text(0.5*(results(2,2)+results(1,2))+5,0.5*(results(2,1)+results(1,1))+5, myText);
end

disp("Fini");