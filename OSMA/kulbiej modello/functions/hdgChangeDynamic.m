function c = hdgChange(ship1,ship2,cpaSet,precision,outlines,rudder)
    %COURSECHANGE Return the course change required to reach reaquired CPA
    %   Return the course change required to reach reaquired CPA, true if no change and false if no solution
    d = distance(ship1,ship2);
    rudder = rudder / 57.3;
    ship1 = ship1.setRudderOrder(rudder);
    if outlines == true
        cpa0 = cpaOutline(ship1,ship2,1);
    else
        cpa0 = cpa(ship1,ship2);
    end
    if cpa0 > cpaSet 
        c = true;
        return
    end
    if d < cpaSet
        c = false;
        return
    end
    iterationBound = 1000;
    iteration = 0;
    initialHeading = ship1.heading;
    while true
        iteration = iteration + 1;
        if iteration > iterationBound
            c = false;
            return
        end
        % Calculate the CPA for the current course
        if outlines == true
            cpa1 = cpaOutline(ship1,ship2,1);
        else
            cpa1 = cpa(ship1,ship2);
        end
        % If the CPA is less than the required CPA, then the course is
        % correct
        if cpa1 > cpaSet
            c = ship1.heading;
            return
        end
        % if made full circle, then no solution
        if abs(ship1.heading - initialHeading) > 6.28
            c = false;
            return
        end
        % move both ships
        ship1 = ship1.calculateMovement(1,1);
        ship2 = ship2.calculateMovement(1,-1);
    end

    
    end
    
    