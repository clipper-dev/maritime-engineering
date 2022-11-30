function [res,a,b] = multiSimulate(ship1, ship2, time, dt, outlines,  movement1, movement2, rudder1, rudder2)
    trials = length(time);
    for i = 1:trials
        if i == 1
            [res1,aa,bb] = simulate(ship1, ship2, 0,time(i), dt, outlines, movement1(i), movement2(i), rudder1(i), rudder2(i));
            res0 = res1;
        else
            if i > length(movement1)
                move1 = movement1(length(movement1));
            else
                move1 = movement1(i);
            end
            if i > length(movement2)
                move2 = movement2(length(movement2));
            else
                move2 = movement2(i);
            end
            if i > length(rudder1)
                rud1 = rudder1(length(rudder1));
            else
                rud1 = rudder1(i);
            end
            if i > length(rudder2)
                rud2 = rudder2(length(rudder2));
            else
                rud2 = rudder2(i);
            end
            [res1,aa,bb] = simulate(aa, bb, time(i-1),time(i), dt, outlines, move1, move2, rud1, rud2);
            res0 = [res0; res1];
        end
    end
    res = res0;
    a = aa;
    b = bb;
end

