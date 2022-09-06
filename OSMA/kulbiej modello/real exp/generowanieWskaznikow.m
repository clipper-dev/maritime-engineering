function wskazniki = generowanieWskaznikow(set,vessel,rudder)
lock=true;lock1=true;lock2=true;
vessel = vessel.updateSet(set);
vessel.rudderAngle = rudder/57.3;
vessel.rudderAngleSet = rudder/57.3;
%% G£ÓWNE WYLICZENIA
while lock==true
    vessel = vessel.calculateMovement(1,2);
    if vessel.heading*57.3 > 90 && lock1 == true
        AdX = vessel.x/vessel.length;
        AdY = vessel.y/vessel.length;
        lock1 = false;
    end
    if vessel.heading*57.3 > 180 && lock2 == true
        TdX = vessel.x/vessel.length;
        TdY = vessel.y/vessel.length;
        lock2 = false;
    end
    if vessel.heading*57.3 > 359 && lock == true
        lock = false;
        deltaX = TdX - vessel.x/vessel.length;
        deltaY = TdY -vessel.y/vessel.length;
        D = sqrt(deltaX^2 + deltaY^2);
        uK = vessel.vx;
        vK = vessel.vy;
        rK = vessel.wz;
    end
end
    
wskazniki = [uK vK rK AdX AdY TdX TdY D];
end