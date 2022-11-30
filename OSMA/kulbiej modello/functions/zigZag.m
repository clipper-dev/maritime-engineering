function GTData = generujTrajektorie3(initialDirection,headingDelta, rudder, vessel, shipVector, steeringVector, calculusVector, initialStateVector, environmentVector, bezwymiaroweWykresySil)
    %generujTrajektorie(
    %shipVector[isOwnSet - true or false, ownSet - matrix of hydrodynamic coefficients],
    %steeringVector[engineSetting - in percent from -100 to 100; rudder from %-35 to 35]
    %calculusVector[duration - in seconds; timeStep -  >=1, defines how many iterations per second, calculusType - 0=eulerImplicit, 1=eulerExplicit, 2=rungeKutta]
    %initialStateVecor[x0, y0, z0, roll, pitch, psi0, vx0; vy0; vz0; wx0; wy0; wz0] //accelerations defined to %be zero
    %environmentVector[isWeather - true/false, weather - wx data object, isShallow - T/F, depth - value used for calculations]
    %% G��WNA SYMULACJA I DANE STERUJ�CE
    time = calculusVector(1);GTData = zeros(time,40);timeStep=1/calculusVector(2);numericalIntegration = calculusVector(3);
    %% G��WNE WYLICZENIA
    headingDelta = headingDelta/57.3;
    rudder = rudder/57.3;
    
    initialHeading=vessel.heading;
    if vessel.heading > 2*pi
        vessel.heading = vessel.heading - 2*pi;
    elseif vessel.heading < 0
        %vessel.heading = vessel.heading + 2*pi
    end
    if initialDirection == "starboard"
        vessel.rudderAngleSet = rudder;
    else
        vessel.rudderAngleSet = -rudder;
    end
    lock1 = true; lock2 = true;
    for i=1:time
        %wyliczenia
        for t=1:calculusVector(2)
            %         if vessel.heading > 2*pi
            %             vessel.heading = vessel.heading - 2*pi;
            %         elseif vessel.heading < 0
            %             vessel.heading = vessel.heading + 2*pi
            %         end
            headingDifference = vessel.heading - initialHeading;
            if headingDifference > pi
                headingDifference = headingDifference - 2*pi;
            end
            if headingDifference > headingDelta && lock1
                vessel.rudderAngleSet = -rudder;
                lock1=false;
                lock2=true;
            elseif headingDifference < - headingDelta && lock2
                vessel.rudderAngleSet = rudder;
                lock1=true;
                lock2=false;
            end
            vessel = vessel.calculateMovement(timeStep,numericalIntegration);
        end
        % zapis danych do tablic
        GTData(i,1) = i; %czas
        GTData(i,2) = vessel.x;
        GTData(i,3) = vessel.y;
        GTData(i,4) = vessel.heading;%radiany
        GTData(i,5) = vessel.heading+vessel.driftAngle;%cog
        GTData(i,6) = vessel.driftAngle;
        
        GTData(i,7) = vessel.speed;
        GTData(i,8) = vessel.vx;
        GTData(i,9) = vessel.vy;
        GTData(i,10) = vessel.wz;
        GTData(i,11) = vessel.vynd;
        GTData(i,12) = vessel.wznd;
        
        GTData(i,13) = vessel.ax;
        GTData(i,14) = vessel.ay;
        GTData(i,15) = vessel.ez;
        
        GTData(i,16) = vessel.Xhull;
        GTData(i,17) = vessel.Xrudder;
        GTData(i,18) = vessel.Xpropeller;
        GTData(i,19) = vessel.Xair;
        GTData(i,20) = vessel.Xwave;
        
        GTData(i,22) = vessel.Yhull;
        GTData(i,23) = vessel.Yrudder;
        GTData(i,24) = vessel.Ypropeller;
        GTData(i,25) = vessel.Yair;
        GTData(i,26) = vessel.Ywave;
        
        GTData(i,27) = vessel.Nhull;
        GTData(i,28) = vessel.Nrudder;
        GTData(i,29) = vessel.Npropeller;
        GTData(i,30) = vessel.Nair;
        GTData(i,31) = vessel.Nwave;
        GTData(i,32) = vessel.rudderAngle;
        
    end