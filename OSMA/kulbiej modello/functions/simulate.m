function [r,a,b] = simulate(ship1, ship2, time0, time, dt, outlines, movement1, movement2, rudder1, rudder2)
    t = 1;
    ship1 = ship1.setRudderOrder(rudder1/57.3);
    ship2 = ship2.setRudderOrder(rudder2/57.3);
    res = zeros(time/dt,30);
    while t < time + dt
        res(t,1) = t + time0;
        res(t,2) = distance(ship1,ship2);
        res(t,3) = cpa(ship1,ship2);
        res(t,4) = tcpa(ship1,ship2);
        if outlines
            res(t,5) = distanceOutline(ship1.x,ship1.y,ship1.heading,ship2.x,ship2.y,ship2.heading,ship1,ship2);
            res(t,6) = cpaOutline(ship1,ship2,1);
        end
        res(t,11) = ship1.x;
        res(t,12) = ship1.y;
        res(t,13) = ship1.heading;
        res(t,14) = ship1.speed;
        res(t,15) = ship1.rudderAngle;
        res(t,16) = ship1.wz;
        
        res(t,21) = ship2.x;
        res(t,22) = ship2.y;
        res(t,23) = ship2.heading;
        res(t,24) = ship2.speed;
        res(t,25) = ship2.rudderAngle;
        res(t,26) = ship2.wz;
        
        ship1 = ship1.calculateMovement(dt, movement1);
        ship2 = ship2.calculateMovement(dt, movement2);
        t = t+dt;
    end 
    r = res;
    a = ship1;
    b = ship2;
end