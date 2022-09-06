clc;clear;close all
timeStep=1;
[a,b]=navigationalSituation(7);
for i=1:7
    armada(i)=shipDefault2("nawigator",'k');
    armada(i)=armada(i).setRudderOrder(((i)*5)/57.3);
end
distanceMinimum =50;
figure;hold on;axis equal; grid on;
outlineA=drawOutline(a.x,a.y,a.heading,a,1);
plot(outlineA(:,1)/a.length,outlineA(:,2)/a.length,a.colour);
outlineA=drawOutline(b.x,b.y,b.heading,b,1);
plot(outlineA(:,1)/b.length,outlineA(:,2)/b.length,b.colour);
time=50;
for t=1:time
    for i=1:7
        data(t,i,1)=armada(i).x;
        data(t,i,2)=armada(i).y;
        data(t,i,3)=armada(i).speed;
        data(t,i,4)=distanceOutline(armada(i).x,armada(i).y,armada(i).heading,b.x,b.y,b.heading,armada(i),b);
        data(t,i,5)=distance(armada(i),b);
        if true
            armada(i)=armada(i).calculateMovement(timeStep,1);
        end
    end
    data(t,8,1)=b.x;
    data(t,8,2)=b.y;
    data(t,8,3)=b.speed;
    b=b.calculateMovement(timeStep,1);
end

for i=1:7
    h(i)=plot(data(:,i,2)/armada(i).length,data(:,i,1)/armada(i).length);
    outlineA=drawOutline(armada(i).x,armada(i).y,armada(i).heading,armada(i),1);
    plot(outlineA(:,1)/armada(i).length,outlineA(:,2)/armada(i).length,armada(i).colour);
end
plot(data(:,8,2)/b.length,data(:,8,1)/b.length);
outlineA=drawOutline(b.x,b.y,b.heading,b,1);
plot(outlineA(:,1)/b.length,outlineA(:,2)/b.length,b.colour);

xlabel('Y/L [-]');
ylabel('X/L [-]');
legend([h(1), h(2), h(3), h(4), h(5), h(6), h(7)], '5°','10°','15°','20°','25°','30°','35°');

figure; hold on;grid on;
for i=1:7
   h(i)=plot(data(:,i,4)); 
end
xlabel('czas [s]');
ylabel('odległość minięcia obrysów [m]');
legend([h(1), h(2), h(3), h(4), h(5), h(6), h(7)], '5°','10°','15°','20°','25°','30°','35°');

figure; hold on;grid on;
for i=1:7
   h(i)=plot(data(:,i,5)); 
end
xlabel('czas [s]');
ylabel('odległość minięcia punktów [m]');
legend([h(1), h(2), h(3), h(4), h(5), h(6), h(7)], '5°','10°','15°','20°','25°','30°','35°');
