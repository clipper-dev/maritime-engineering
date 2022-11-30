clc;clear all;close all
%% SCENARIUSZ
coop=false;
rudderA=-35;
rudderB=0;
timeStep=0.01;

%% dane sterujące
if ~coop
    rudderB=0;
end
requiredCPA = 0.1;%0.5*(a.breadth+b.breadth);
waitTime=5;
exit=true;
simulationEndTime=500;
xx2=matfile('lmmWyniki.mat');
lmmCzasy=xx2.wyniki;
wyniki2=zeros(24,15,simulationEndTime/timeStep,20);
%% ostatnia symulacja
tic
parfor scenario=1:24
    waitTime=max(lmmCzasy(scenario,:))+5;
    wyniki=zeros(1,15,simulationEndTime/timeStep,20);
    for rudder=1:15
    [a,b]=navigationalSituation(scenario);
        minDistance=distance(a,b);
        lock = false;
        actualRudder=35-5*(rudder-1);
        for i=1:simulationEndTime/timeStep
            if i>waitTime/timeStep && ~lock
                lock = true;
                a=a.setRudderOrder(actualRudder/57.3);
                b=b.setRudderOrder(rudderB/57.3);
            end
            a=a.calculateMovement(timeStep,1);
            b=b.calculateMovement(timeStep,1);
            distanceO=distanceOutline(a.x,a.y,a.heading,b.x,b.y,b.heading,a,b);
            if distanceO<minDistance
                minDistance=distanceO;
            end
            if distanceO<=requiredCPA
                collisionTime=i;
                break;
            end
            %% zapis do wyniki(i,k)
            wyniki(1,rudder,i,1)=i;
            wyniki(1,rudder,i,2)=a.x;
            wyniki(1,rudder,i,3)=a.y;
            wyniki(1,rudder,i,4)=a.vx;
            wyniki(1,rudder,i,5)=a.vy;
            wyniki(1,rudder,i,6)=a.wz;
            wyniki(1,rudder,i,7)=b.x;
            wyniki(1,rudder,i,8)=b.y;
            wyniki(1,rudder,i,9)=b.vx;
            wyniki(1,rudder,i,10)=b.vy;
            wyniki(1,rudder,i,11)=b.wz;
            wyniki(1,rudder,i,12)=distance(a,b);
            wyniki(1,rudder,i,13)=distanceO;
            wyniki(1,rudder,i,14)=a.heading;
            wyniki(1,rudder,i,15)=b.heading;
            wyniki(1,rudder,i,16)=a.rudderAngle;
            wyniki(1,rudder,i,17)=b.rudderAngle;
            wyniki(1,rudder,i,18)=cpa(a,b);
            %%
        end
    end
    wyniki2(scenario,:,:,:)=wyniki(1,:,:,:);
end
toc
disp("Fini");