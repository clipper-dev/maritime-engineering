classdef ship
    %SHIPCLASS Obiekt klasy statek do wywo³ywania w symulacjach
    %   Detailed explanation goes here
    
    properties
        %% WEKTOR STANU W UK£ADZIE INERCJALNYM
        vx
        vy
        vz
        wx
        wy
        wz
        vynd
        wznd
        ax
        ay
        az
        ex
        ey
        ez
        %% WEKTOR STANU W UK£ADZIE NIEINERCJALNYM
        x
        y
        pitch
        roll
        heading
        %% STA£E I PRZELICZNIKI
        pi = 3.1415;
        waterDensity = 1.025;
        airDensity = 0.0013;
        %% DANE STERUJ¥CE
        
        hydroCoefficientLevel %jeœli "0" to uproszczone liniowe, jeœli "1" to nieliniowe proste, jeœli "2" to nieliniowe z³o¿one
        %% PODSTAWOWE DANE IDENTYFIKACYJNE
        name
        shipMMSI
        shipType
        %% PODSTAWOWE DANE GEOMETRYCZNE / GENERAL PARTICULARS
        length
        breadth
        draught
        cB %wspó³czynnik pe³notliwoœci podwodzia
        sW %powierzchnia zwil¿ona kad³uba
        xG  %wspó³rzêdna œrodka ciê¿koœci od midshipu
        yG
        zG %wspó³rzena œrodka ciê¿koœci od p³aszczyzny podstawowej
        GM  %pocz¹tkowa wysokoœæ metacentryczna
        KG %wzniesienie punktu metacentrycznego
        rXX %ramienia momentów bezw³adoœci masy wokó³ osi x y z
        rYY
        rZZ
        % air resistance
        airAreaX
        airAreaY
        xAir
        yAir
        zAir
        cAx 
        cAy
        cAz
        
        %% DANE PÊDNIKA / PROPELLER DETAILS
        propellerDiameter %œrednica
        propellerRotation
        pd %
        AeA0 %
        propellerZ %liczba ostrzy
        propellerNo %liczba œrub
        xP %wspó³rzêdna po³o¿enia œruby od midshipu
        kT0 %wspó³rzêdne wielomianu drugiego stopnia którym aproksymuje siê krzyw¹ charakterystyki œruby
        kT1 
        kT2
        thrustDeduction
        wakeFraction
        jj
        kt
        %% DANE STERU / RUDDER SPECIFICATION
        rudderWetSurface
        rudderArea 
        xRudder 
        zRudder
        rudderRotation
        rudderAngle
        rudderDelta
        rudderCoefficient1
        rudderCoefficient2
        rudderCoefficient3
        rudderCoefficient4
        vyRudder
        vxRudder
        alfaRudder
        betaLocal
        h1
        h2
        h3
        % jakieœ tam wspó³czynniki korekcyjne
        tR
        aH
        xR
        xH
        %% WSPÓ£CZYNNIKI HYDRODYNAMICZNE / HYDRODYNAMIC COEFFICIENTS
        shipAspectRatio
        shipAddedMassCoefficient
        X_vv
        X_vr
        X_rr
        X_vvvv
        Y_v
        Y_r
        Y_vvv
        Y_rrr
        Y_vrr
        Y_vvr
        N_v
        N_r
        N_vvv
        N_rrr
        N_vrr
        N_vvr
        hydroCoefficientMatrix
        %% MASA, MASY DODANE, MOMENTY BEZW£ADNOŒCI I MOMENTY BEZW£ADNOŒCI DODANE
        m
        Ixx
        Iyy 
        Izz
        X_0
        X_u1
        Y_v1
        Y_p1
        Y_r1
        Z_w1
        Z_q1
        K_v1
        K_p1
        K_r1
        M_q1
        N_v1
        N_r1
        % uproszczone
        mx
        my
        jzz        
        %% DYNAMIKA
        M
        Acc
        P
        B
        % si³y
        ForceX
        Xhull
        Xpropeller
        Xrudder
        Xair
        Xwave
        ForceY
        Yhull
        Ypropeller
        Yrudder
        Yair
        Ywave
        MomentK
        MomentN
        Nhull
        Npropeller
        Nrudder
        Nair
        Nwave
        %% KINEMATYKA
        speed
        driftAngle
        %% POGODA
        isWeather
        weather
        apparentSpeed
        apparentAngle
    end
    
    methods
        %% statek, deklaracja, statyczne i dynamiczne dane
        function s = ship(name, commandMatrix, shipData, hydroSet, hydroOverride, isWeather, weather)
            % SHIPCLASS ship(name, commandMatrix, shipData, hydroSet, hydroOverride, isWeather, weather)
            %% DANE IDENTYFIKACYJNE
            s.name = name;
            s.shipMMSI = (shipData(1));
            s.shipType = (shipData(2));
            %% DANE STERUJ¥CE
            s.hydroCoefficientLevel = commandMatrix(10);
            s.rudderAngle = commandMatrix(2);
            s.propellerRotation = (shipData(21))*commandMatrix(12)/100;
            %% POGODA
            s.isWeather = isWeather;
            s.weather = weather;
            %% INICJALIZACJA WEKTORA STANU STATKU
            s.vx = commandMatrix(6);
            s.vy = commandMatrix(7);
            s.vz = 0;
            s.wx =0;
            s.wy=0;
            s.wz=commandMatrix(8);
            s.ax=0;
            s.ay=0;
            s.az=0;
            s.ex=0;
            s.ey=0;
            s.ez=0;
            s.x=commandMatrix(3);
            s.y=commandMatrix(4);
            s.pitch=0;
            s.roll=0;
            s.heading=commandMatrix(5);
            %% KINEMATYKA
            if s.vx ~= 0
                s.driftAngle = atan(s.vy/s.vx);
            else
                s.driftAngle = 0;
            end
            s.speed = sqrt(s.vx*s.vx + s.vy*s.vy);
            %% INICJALIZACJA GEOSTATYCZNYCH DANYCH STATKU
            s.length = (shipData(3));
            s.breadth = (shipData(4));
            s.draught = (shipData(5));
            s.cB = (shipData(6));
            s.sW = (shipData(7));
            s.rXX = (shipData(8));
            s.rYY = (shipData(9));
            s.rZZ = (shipData(10));
            s.xG = (shipData(11));
            s.yG = (shipData(12));
            s.zG = (shipData(13));
            s.GM = (shipData(14));
            s.KG = (shipData(15));
            % AIR
            s.airAreaX = (shipData(48));
            s.airAreaY = (shipData(49));
            s.xAir = (shipData(50));
            s.yAir = (shipData(51));
            s.zAir = (shipData(52));
            s.cAx = (shipData(53));
            s.cAy = (shipData(54));
            s.cAz = (shipData(55));
            % PROPELLER
            s.propellerDiameter = (shipData(20));
            s.kT0 = (shipData(22));
            s.kT1 = (shipData(23));
            s.kT2 = (shipData(24));
            if shipData(44) == 0
            s.thrustDeduction = 0.3;
            else
            s.thrustDeduction = shipData(44);
            end
            if shipData(43) == 0
            s.wakeFraction = 0.4;
            else
            s.wakeFraction = shipData(43);
            end
            s.jj = 0;
            s.kt = 0;
            % RUDDER
            if shipData(42) == 0
                s.rudderArea = 0.01*(1+25*((s.breadth*s.breadth)/(s.length*s.length)))*s.length*s.draught;
            else
                s.rudderArea = shipData(42);
            end
            s.alfaRudder = 0;
            s.betaLocal = 0;
            s.h1 = 0;
            s.h2 = 0;
            s.h3 = 0;
            s.rudderDelta = (6.13 * 1.85)/(1.85+2.25);
            s.rudderCoefficient1 = 2.06*s.cB*s.breadth/s.length+0.14;
            s.rudderCoefficient2 = -0.9;
            s.rudderCoefficient3 = 2.26*1.82*0.7;
            s.rudderCoefficient4 = 0.55 - 0.8*s.cB*s.breadth/s.length+0.14;
            s.tR = 0.39;
            s.aH = 3.6 *s.cB*s.breadth/s.length;
            s.xR = -0.5;
            s.xH = -0.4;
            s.vyRudder = 0;
            s.vxRudder = 0;
            % WSPÓ£CZYNNIKI HYDRODYNAMICZNE / HYDRODYNAMIC COEFFICIENTS
            s.X_0 = (shipData(25));
                s.shipAspectRatio = 2*s.draught/s.length;
                s.shipAddedMassCoefficient = s.cB*s.breadth / s.length;
            if hydroOverride == true
                s.X_vv = hydroSet(1);
                s.X_vr = hydroSet(2);
                s.X_rr =hydroSet(3);
                s.X_vvvv=hydroSet(4);
                s.Y_v =hydroSet(5);
                s.Y_r =hydroSet(6);
                s.Y_vvv =hydroSet(7);
                s.Y_rrr = hydroSet(8);
                s.Y_vrr =hydroSet(9);
                s.Y_vvr =hydroSet(10);
                s.N_v =hydroSet(11);
                s.N_r =hydroSet(12);
                s.N_vvv =hydroSet(13);
                s.N_rrr = hydroSet(14);
                s.N_vvr =hydroSet(15);
                s.N_vrr =hydroSet(16);
            elseif (commandMatrix(9) == true) && (commandMatrix(11) == false)
                s.X_vv = 1.15*s.shipAddedMassCoefficient - 0.18;
                s.X_vr = 0.1*s.shipAddedMassCoefficient+0.08;
                s.X_rr = -0.085*s.shipAddedMassCoefficient+0.008;
                s.X_vvvv = -6.68*s.shipAddedMassCoefficient+1.1;
                s.Y_v = -(3.14*s.shipAspectRatio/2+1.4*s.shipAddedMassCoefficient);
                s.Y_r = 0.6*s.shipAddedMassCoefficient;
                s.Y_vvv = -0.185*s.length/s.breadth + 0.48;
                s.Y_rrr = (s.length/s.draught)*(-0.0233*s.cB*s.draught/s.breadth + 0.0063);
                s.Y_vrr = -(0.26*(1-s.cB)*s.length/s.breadth + 0.11);
                s.Y_vvr =1.5*s.draught*s.cB/s.breadth - 0.65;
                s.N_v =-s.shipAspectRatio;
                s.N_r = -0.5*s.shipAspectRatio+s.shipAspectRatio*s.shipAspectRatio;
                s.N_vvv =0.69*s.cB - 0.66;
                s.N_rrr = 0.25*s.shipAddedMassCoefficient - 0.056;
                s.N_vvr = 1.55*s.shipAddedMassCoefficient-0.76;
                s.N_vrr = -0.075*(1 - s.cB)*s.length/s.breadth - 0.098;
            elseif (commandMatrix(9) == false) && (commandMatrix(11) == false)
                
            else
                s.X_vv = (shipData(26));
                s.X_vr = (shipData(27));
                s.X_rr =(shipData(28));
                s.X_vvvv=(shipData(29));
                s.Y_v =(shipData(30));
                s.Y_r =(shipData(31));
                s.Y_vvv =(shipData(32));
                s.Y_rrr = (shipData(33));
                s.Y_vrr =(shipData(34));
                s.Y_vvr =(shipData(35));
                s.N_v =(shipData(36));
                s.N_r =(shipData(37));
                s.N_vvv =(shipData(38));
                s.N_rrr = (shipData(39));
                s.N_vvr =(shipData(40));
                s.N_vrr =(shipData(41));
            end
            s.hydroCoefficientMatrix = ([s.X_vv; s.X_vr; s.X_rr; s.X_vvvv; s.Y_v; s.Y_r; s.Y_vvv; s.Y_rrr; s.Y_vrr; s.Y_vvr; s.N_v; s.N_r; s.N_vvv; s.N_rrr; s.N_vvr; s.N_vrr]);
            % MASA, MASY DODANE, MOMENTY BEZW£ADNOŒCI I MOMENTY BEZW£ADNOŒCI DODANE
            s.m = s.length * s.breadth * s.draught * s.cB * s.waterDensity;
            s.Ixx = s.m * s.rXX * s.rXX;
            s.Iyy = s.m * s.rYY * s.rYY;
            s.Izz = s.m * s.rZZ * s.rZZ;
            % uproszczone
            s.mx = 0.02*s.m;
            s.my = 0.2*s.m;
            s.jzz = 0.01*s.Izz;
            if commandMatrix(9) == true
                s.X_u1 = s.m / (s.pi * sqrt((s.length*s.length)/(s.breadth*s.draught*s.cB))-14);
                s.Y_v1 = 0.5*s.waterDensity*s.length*s.length*s.length*(-s.pi*((s.draught/s.length)/(s.draught/s.length))*(1+0.16*(s.cB*s.breadth/s.draught)-5.1*((s.breadth/s.length)/(s.breadth/s.length))));
                s.Y_p1 = s.Y_v1*(s.KG - 0.5*s.draught);
                s.Y_r1 = 0.5*s.waterDensity*s.length*s.length*s.length*s.length*-3.14*(((s.draught/s.length)/(s.draught/s.length))*(0.67*(s.breadth/s.length)-0.0033*((s.breadth/s.draught)/(s.breadth/s.draught))));
                s.Z_w1 = -1.08*s.m;
                s.Z_q1 = -0.9*s.Iyy/s.length;
                s.K_v1 = s.Y_p1;
                s.K_p1 = -0.2*s.Ixx;
                s.K_r1 = -0.0085*s.Iyy;
                s.M_q1 = s.length*s.Z_q1;
                s.N_v1 = s.Y_r1;
                s.N_r1 = 0.5*s.waterDensity*s.length*s.length*s.length*(-pi*((s.draught/s.length)/(s.draught/s.length))*(0.0833+0.017*(s.cB*s.breadth/s.draught)-0.0033*(s.breadth/s.length)));
            else
            % TODO shallow water hydroderivatives dokoñczyæ
            end
            
            %% MACIERZ MAS I MAS DODANYCH
            s.M = zeros(3,3);
            s.M = [s.m+s.mx 0 0;
                0 s.m+s.my s.xG*s.m;
                0 s.xG*s.m s.Izz+s.xG*s.xG+s.jzz];
            s.M = inv(s.M);
            s.B = zeros(3,1);
            s.Acc = zeros(3,1);
            s.ForceX = 0;
            s.Xhull = 0;
            s.Xpropeller = 0;
            s.Xrudder = 0;
            s.Xair = 0;
            s.Xwave = 0;
            s.ForceY = 0;
            s.Yhull = 0;
            s.Ypropeller = 0;
            s.Yrudder = 0;
            s.Yair = 0;
            s.Ywave = 0;
            s.MomentN = 0;
            s.Nhull = 0;
            s.Npropeller = 0;
            s.Nrudder = 0;
            s.Nair = 0;
            s.Nwave = 0;
        end
        function s = updateShip(obj,x,y,heading,vx,vy,wz)
            obj.x = x;
            obj.y = y;
            obj.heading = heading;
            obj.vx = vx;
            obj.vy = vy;
            obj.wz = wz;
            s = obj;
        end
        %% geometryczne przeliczenia
        function x = rudderTheoretical(s)
            x = 0.01*(1+25*((s.breadth*s.breadth)/(s.length*s.length)))*s.length*s.draught; 
        end
        %% pogodowe przeliczenia
        function x = apparentWindAngle(obj, windDirection, windSpeed)
            angleDifference = windDirection - obj.heading*57.3 - obj.driftAngle;
            apparentSpeed = sqrt(windSpeed^2 + obj.speed^2 + obj.speed*windSpeed*cos(angleDifference/57.3));
            apparentAngle = acos((windSpeed*cos(angleDifference/57.3)+obj.speed)/apparentSpeed)*57.3;
            if angleDifference > 180
                apparentAngle = 360-apparentAngle;
            else
                apparentAngle = apparentAngle; 
            end
            x = apparentAngle;
        end
        function x = apparentWindAngle2(obj, windDirection, windSpeed)
            y = windSpeed*cos((windDirection-180)/57.3-obj.heading) - obj.speed;
            x = windSpeed*sin((windDirection-180)/57.3-obj.heading);
            if y > 0 && x > 0
                x = atan(x/y)*57.3;
            elseif y > 0 && x < 0
                x = 360-atan(x/y)*57.3;
            elseif y < 0 && x > 0
                x = 180+atan(x/y)*57.3;
            elseif y < 0 && x < 0
                x = 180+atan(x/y)*57.3;
            elseif y==0 && x > 0
                x = 90;
            elseif y==0 && x < 0
                x = 270;
            elseif y==0 && x == 0
                x = 0;
            elseif y>0 && x == 0
                x = 0;
            elseif y<0 && x == 0
                x = 180;
            end
            if x > 360
                x = x - 360;
            end
            
        end
        function x = apparentWindSpeed(obj, windDirection, windSpeed)
            angleDifference = windDirection - obj.heading*57.3 - obj.driftAngle;
            x = sqrt(windSpeed^2 + obj.speed^2 + obj.speed*windSpeed*cos(angleDifference/57.3));
        end
        %% mechanika ruchu statku
        function disp = displacement(obj)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            disp = obj.length * obj.breadth * obj.draught * obj.cB * obj.waterDensity;
        end
        
        function c = calculateDynamics(obj,timeStep)
            %% GENERAL
            obj.speed = sqrt(obj.vx*obj.vx+obj.vy*obj.vy);
            if obj.speed == 0
                obj.vynd = 0;
                obj.wznd = 0;
                obj.driftAngle = 0;
            elseif obj.vx == 0
                
                obj.vynd = obj.vy/obj.speed;
                obj.wznd = obj.wz*obj.length/obj.speed;
                obj.driftAngle = 0;
            else
                obj.vynd = obj.vy/obj.speed;
                obj.wznd = obj.wz*obj.length/obj.speed;
                obj.driftAngle = atan(-obj.vy/obj.vx);
            end
            %% HULL FORCES
            if false
            %X
            obj.Xhull = 0.5*obj.waterDensity*obj.length*obj.draught*obj.speed*obj.speed*obj.X_0;
            %Y
            obj.Yhull = 0.5*obj.waterDensity*obj.length*obj.draught*...
                (obj.Y_v*obj.vy + obj.Y_r*obj.wz*obj.length);
            %N
            obj.Nhull = 0.5*obj.waterDensity*obj.length*obj.length*obj.draught*...
                (obj.N_v*obj.vy+obj.N_r*obj.wz*obj.length);
            elseif false
            %X
            obj.Xhull = 0.5*obj.waterDensity*obj.length*obj.draught*(...
                obj.X_0*obj.vx*obj.vx + ...
                obj.X_vv*obj.vy*obj.vy + ...
                obj.X_rr*obj.wz*obj.wz*obj.length*obj.length);
            %Y
            obj.Yhull = 0.5*obj.waterDensity*obj.length*obj.draught*(...
                obj.Y_v*obj.vy + ...
                obj.Y_r*obj.wz*obj.length + ...
                obj.Y_vvv*obj.vy*obj.vy*obj.vy + ...
                obj.Y_rrr*obj.wz*obj.wz*obj.wz*obj.length*obj.length*obj.length);
            %N
            obj.Nhull = 0.5*obj.waterDensity*obj.length*obj.length*obj.draught*(...
                obj.N_v*obj.vy + ...
                obj.N_r*obj.wz*obj.length + ...
                obj.N_vvv*obj.vy*obj.vy*obj.vy + ...
                obj.N_rrr*obj.wz*obj.wz*obj.wz*obj.length*obj.length*obj.length);    
            else
            %X
            obj.Xhull = 0.5*obj.waterDensity*obj.length*obj.draught*obj.speed*abs(obj.speed)*(...
                obj.X_0 + ...
                obj.X_vv*obj.vynd*obj.vynd + ...
                obj.X_vr*obj.vynd*obj.wznd + ...
                obj.X_rr*obj.wznd*obj.wznd + ...
                obj.X_vvvv*obj.vynd*obj.vynd*obj.vynd*obj.vynd);
            %Y
            obj.Yhull = 0.5*obj.waterDensity*obj.length*obj.draught*obj.speed*obj.speed*(...
                obj.Y_v*obj.vynd + ...
                obj.Y_r*obj.wznd + ...
                obj.Y_vvv*obj.vynd*obj.vynd*obj.vynd + ...
                obj.Y_vvr*obj.vynd*obj.vynd*obj.wznd + ...
                obj.Y_vrr*obj.vynd*obj.wznd*obj.wznd + ...
                obj.Y_rrr*obj.wznd*obj.wznd*obj.wznd);
            %N
            obj.Nhull = 0.5*obj.waterDensity*obj.length*obj.length*obj.draught*obj.speed*obj.speed*(...
                obj.N_v*obj.vynd + ...
                obj.N_r*obj.wznd + ...
                obj.N_vvv*obj.vynd*obj.vynd*obj.vynd + ...
                obj.N_vvr*obj.vynd*obj.vynd*obj.wznd + ...
                obj.N_vrr*obj.vynd*obj.wznd*obj.wznd + ...
                obj.N_rrr*obj.wznd*obj.wznd*obj.wznd);
            end
            
            %% PROPELLER FORCES
            %X
            
                C1=2;
                C2=1.6;
                betaP = obj.driftAngle +0.5*obj.wznd;
                fBeta = (2.718^(-C1*abs(betaP)))*(C2-1);
                wakeFractionNew = 1 - (1+fBeta)*(1-obj.wakeFraction);
            if obj.propellerRotation == 0 || 0 >= obj.vx
                propellerJ = 0;
            else
                propellerJ = ((1-wakeFractionNew)*obj.vx)/(obj.propellerDiameter*obj.propellerRotation);
            end
            
            propellerKT = obj.kT0 + obj.kT1 * propellerJ + obj.kT2*propellerJ*propellerJ;
            obj.Xpropeller = (1-obj.thrustDeduction)*obj.waterDensity * obj.propellerRotation * obj.propellerRotation *...
                obj.propellerDiameter* obj.propellerDiameter* obj.propellerDiameter* obj.propellerDiameter * propellerKT;
            obj.jj = propellerJ;
            obj.kt = propellerKT;
            %Y
            obj.Ypropeller = 0;
            %N
            obj.Npropeller = 0;
            
            %% RUDDER FORCES

            if obj.propellerRotation == 0 || 0>=obj.vx
                cTH = 0;
                vyR = obj.vy - obj.wz*0.5*obj.length;
                vRudder = 0;
                obj.betaLocal = 0;
            else
                cTH = 2.546*propellerKT/(propellerJ*propellerJ);
                if cTH < -1
                    cTH = -1
                end
                vyR = obj.vy - obj.wz*0.5*obj.length;
                vRudder = obj.vx*(1-wakeFractionNew)*sqrt(1+cTH);
                obj.betaLocal = -atan(-vyR/vRudder)*57.3;
            end
            obj.alfaRudder = obj.rudderAngle + obj.betaLocal;
            coefficient = -0.0204*cTH + 1.078;
            uR=obj.vx*1.09*(1-wakeFractionNew)*sqrt(0.624*(1+0.5*(sqrt(1+(8*propellerKT)/(3.14*propellerKT*propellerKT))-1))^2+(1-0.624));
            betaR=obj.driftAngle+0.71*obj.wznd;
            vR=obj.speed*betaR*0.64;
            vRudder=sqrt(vR^2 + uR^2);
            ForceRudder = 0.5 * obj.waterDensity*obj.rudderArea*vRudder*vRudder*2.74*sin(obj.alfaRudder/57.3);
            %X
            obj.Xrudder = -(1-0.387)*ForceRudder*sin(obj.rudderAngle/57.3);
            %Y
            obj.Yrudder = -(1+0.312)*ForceRudder*cos(obj.rudderAngle/57.3);
            %N
            obj.Nrudder = -(-0.5-0.312*0.464)*ForceRudder*obj.length;
            %% AIR RESISTANCE FORCES
            if obj.isWeather == true
%                 angleDifference = windDirection - obj.heading*57.3 - obj.driftAngle;
%             apparentSpeed = sqrt(windSpeed^2 + obj.speed^2 + obj.speed*windSpeed*cos(angleDifference/57.3));
%             apparentAngle = acos((windSpeed*cos(angleDifference/57.3)+obj.speed)/apparentSpeed)*57.3;
%             if angleDifference > 180
%                 apparentAngle = 360-apparentAngle;
%             else
%                 apparentAngle = apparentAngle; 
%             end
%             x = apparentAngle;
                angleDifference = obj.weather.windDirection - obj.heading*57.3 - obj.driftAngle;
                obj.apparentSpeed = sqrt(obj.weather.windSpeed^2 + obj.speed^2 + 2*obj.speed*obj.weather.windSpeed*cos(angleDifference/57.3));
                obj.apparentAngle = obj.apparentWindAngle2(obj.weather.windDirection,obj.weather.windSpeed)-90;
                
%                 disp("angleDifference = " + angleDifference);
%                 disp("windDirection = " + obj.weather.windDirection);
%                 disp("apparentSpeed = " + apparentSpeed);
%                 disp("apparent angle = " + apparentAngle);
%                 disp("cos apparentAngle = "+cos(apparentAngle/57.3));
                obj.h1 = obj.weather.windSpeed^2 + obj.speed^2 +2*obj.speed*obj.weather.windSpeed*cos(angleDifference/57.3);
                obj.h2 = obj.apparentAngle;
                %X
                obj.Xair = 0.5*obj.airDensity*obj.apparentSpeed*obj.apparentSpeed*obj.airAreaX*...
                    obj.cAx*cos(obj.apparentAngle/57.3);
                %Y
                obj.Yair = 0.5*obj.airDensity*obj.apparentSpeed*obj.apparentSpeed*obj.airAreaY*...
                    obj.cAy*sin(obj.apparentAngle/57.3);
                %N
                obj.Nair = 0.5*obj.airDensity*obj.apparentSpeed*obj.apparentSpeed*obj.length*...
                    obj.airAreaY*obj.cAz*sin(2*obj.apparentAngle/57.3);
            else
                
                %X
                obj.Xair = 0;
                %Y
                obj.Yair = 0;
                %N
                obj.Nair = 0;
            end
            %% WAVE DRIFTING SECOND ORDER FORCES
            if obj.isWeather == true
                betaWave = (obj.weather.waveDirection - obj.heading*57.3)-90;
                waveCoefficient = obj.waterDensity*obj.weather.waveHeight^2 * obj.weather.waveFrequency*obj.speed;
                %X
                obj.Xwave = -waveCoefficient*obj.breadth*cos(betaWave/57.3);
                %Y
                obj.Ywave = -waveCoefficient*obj.length*sin(betaWave/57.3);
                %N
                obj.Nwave = -obj.Ywave*obj.breadth^2/obj.length;
            else    
                %X
                obj.Xwave = 0;
                %Y
                obj.Ywave = 0;
                %N
                obj.Nwave = 0;
            end
            %% SUMMA HYDROLOGIAE
            obj.ForceX = obj.Xhull + obj.Xpropeller + obj.Xrudder + obj.Xair + obj.Xwave;
            obj.ForceY = obj.Yhull + obj.Ypropeller + obj.Yrudder + obj.Yair + obj.Ywave;
            obj.MomentN =obj.Nhull + obj.Npropeller + obj.Nrudder + obj.Nair + obj.Nwave;
            c = obj;
        end
        function c = calculateAccelerations(obj,timeStep)
%             obj.B(1) = obj.ForceX+obj.vy*obj.wz*(obj.m+obj.my)+obj.wz*obj.xG*obj.m*obj.wz;
%             obj.B(2) = obj.ForceY - (obj.m+obj.mx)*obj.vx*obj.wz;
%             obj.B(3) = obj.MomentN-obj.xG*obj.m*obj.vx*obj.wz;
%             obj.Acc = obj.M * obj.B;
            obj.B(1) = obj.vy*obj.wz*(obj.m+obj.my);%+obj.wz*obj.xG*obj.m*obj.wz;
            obj.B(2) = -(obj.m+obj.mx)*obj.vx*obj.wz;
            obj.B(3) =11*obj.m*(obj.Acc(2)+obj.vx*obj.wz);%obj.xG*obj.m*obj.vx*obj.wz;
            obj.Acc(1) = (obj.ForceX+obj.B(1))/(obj.m + obj.mx);
            obj.Acc(2) = (obj.ForceY + obj.B(2))/(obj.m + obj.my);
            obj.Acc(3) = (obj.MomentN-obj.B(3))/(obj.jzz + 121*obj.m+ obj.Izz);
            
            c = obj;
        end
        %% integracja
        function c = calculateMovement(obj,timeStep, method)
           obj = obj.calculateAccelerations(timeStep);
           obj = obj.calculateDynamics(timeStep);
           if(method == "euler")
               obj.vx = obj.vx + obj.Acc(1)*timeStep;
               obj.vy = obj.vy + obj.Acc(2)*timeStep;
               obj.wz = obj.wz + obj.Acc(3)*timeStep;
               obj.heading = obj.heading + obj.wz*timeStep;
               obj.x = obj.x + obj.vx * sin(obj.heading)*timeStep + obj.vy*cos(obj.heading)*timeStep;
               obj.y = obj.y + obj.vx * cos(obj.heading)*timeStep - obj.vy*sin(obj.heading)*timeStep;
           else
               
           end
           c = obj;
        end
    end
end

