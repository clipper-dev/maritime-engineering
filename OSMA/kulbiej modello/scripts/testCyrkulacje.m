clc;clear;close all
timeStep=1;
for i=1:7
    armada(i)=shipDefault2("nawigator",'k');
    armada(i)=armada(i).setRudderOrder(((-i)*5)/57.3);
end

time=60;
for t=1:time
    for i=1:7
        data(t,i,1)=armada(i).x;
        data(t,i,2)=armada(i).y;
        data(t,i,3)=armada(i).speed;
        armada(i)=armada(i).calculateMovement(timeStep,1);
    end
end

figure;hold on;axis equal; grid on;
for i=1:7
    h(i)=plot(data(:,i,2)/armada(i).length,data(:,i,1)/armada(i).length);
    outlineA=drawOutline(armada(i).x,armada(i).y,armada(i).heading,armada(i),1);
    plot(outlineA(:,1)/armada(i).length,outlineA(:,2)/armada(i).length,armada(i).colour);
end
xlabel('Y/L [-]');
ylabel('X/L [-]');
legend([h(1), h(2), h(3), h(4), h(5), h(6), h(7)], '5°','10°','15°','20°','25°','30°','35°');