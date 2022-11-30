function [c, collisionTime,aCollision, bCollision] = generujTrajektorieKolizji(a,b,collisionDistance,simulationEndTime,timeStep,waitTime)
c=zeros(simulationEndTime/timeStep,15);
i=0;
lock = false;
minDistance=distance(a,b);
while i<simulationEndTime/timeStep
    i=i+1;
    if i>waitTime/timeStep && ~lock
        lock = true;
        a=a.setRudderOrder(rudderA/57.3);
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
        aCollision=a;
        bCollision=b;
        break;
    end
    %% zapis do wyniki(i,k)
    c(i,1)=a.x;
    c(i,2)=a.y;
    c(i,3)=b.x;
    c(i,4)=b.y;
    c(i,5)=distance(a,b);
    c(i,6)=distanceO;
    c(i,7)=a.heading;
    c(i,8)=b.heading;
    c(i,9)=a.rudderAngle;
    c(i,10)=b.rudderAngle;
    c(i,11)=i;
    c(i,12)=cpa(a,b);
    c(i,13)=cpaOutline(a,b,timeStep);
    %%    
end
end