classdef ship3
    %SHIPCLASS Obiekt klasy statek do wywo³ywania w symulacjach
    %   Detailed explanation goes here
    
    properties
        %% DANE EDYTORA
        colour='red'
        outlineCode='rect'
        outlineX
        outlineY
        %% WEKTOR STANU W UK£ADZIE INERCJALNYM
        vx
        vNS
        vEW
        vyR
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
        speedExp
        %% WEKTOR STANU W UK£ADZIE NIEINERCJALNYM
        x
        y
        z
        pitch
        roll
        heading
        %% STA£E I PRZELICZNIKI
        pi = 3.1415;
        waterDensity = 1025;
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
        propellerJ
        propellerKT
        wakeFractionNew
        yPropellerForceCoefficient
        %% DANE STERU / RUDDER SPECIFICATION
        rudderWetSurface
        rudderArea 
        xRudder 
        zRudder
        rudderRotation
        rudderAngle
        rudderSpeed
        rudderAngleSet
        rudderDelta
        rudderCoefficient1
        rudderCoefficient2
        rudderCoefficient3
        rudderCoefficient4
        vRudder
        uRudder
        VRudder
        alfaRudder
        betaLocal
        h1
        h2
        h3
        FN
        betaR
        cTH
        cTHDrop
        % jakieœ tam wspó³czynniki korekcyjne
        tR
        aH
        xR
        xH
        rudderEpsilon
        rudderEta
        rudderKappa
        rudderGammaPos
        rudderGammaNeg
        rudderLR
        rudderC1
        rudderC2Pos
        rudderC2Neg
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
        hydroSet
        %% MASA, MASY DODANE, MOMENTY BEZW£ADNOŒCI I MOMENTY BEZW£ADNOŒCI DODANE
        m
        Ixx
        Iyy 
        Izz
        R_0
        m11
        m22
        m33
        m44
        m55
        m66
        m24
        m26
        m31
        m35
        m46
        m51
             
        %% DYNAMIKA
        %macierze- masy, przyspieszeñ, si³, coriolisa, prêdkoœci
        M
        Acc
        P
        C
        V
        Phull
        Prudder
        Ppropeller
        Pwave
        Pair
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
        %% ŒRODOWISKO
        isShallow
        depth
        isWeather
        weather
        apparentSpeed
        apparentAngle
    end
    
    methods
        %% statek, deklaracja, statyczne i dynamiczne dane
        function s = ship3(shipName, shipData, shipVector, steeringVector, ...
            calculusVector, initialStateVector, enviromentVector,outlineCode)
            %shipA = ship2(""+shipName, shipData, shipVector, steeringVector, calculusVector, initialStateVector, enviromentVector);     
            %% DANE IDENTYFIKACYJNE
            s.name = shipName;
            s.shipMMSI = shipData(1);
            s.shipType = shipData(2);
            s.outlineCode = outlineCode;
            %% DANE STERUJ¥CE
            s.rudderAngle=0;
            s.rudderAngleSet = steeringVector(2)/57.3;
            s.propellerRotation = shipData(53)*steeringVector(1)/100;
            %% ŒRODOWISKO
            s.isWeather = enviromentVector.isWeather;
            s.weather = enviromentVector.weather;
            s.isShallow = enviromentVector.isShallow;
            s.depth = enviromentVector.depth;
            %% INICJALIZACJA WEKTORA STANU STATKU
            s.x = initialStateVector(1);
            s.y = initialStateVector(2);
            s.z = initialStateVector(3);
            s.roll = initialStateVector(4);
            s.pitch = initialStateVector(5);
            s.heading = initialStateVector(6);
            s.speedExp=shipData(11);
            if initialStateVector(7)==666
            s.vx = s.speedExp;
            else
            s.vx = initialStateVector(7);                
            end
            s.vy = initialStateVector(8);
            s.vz = initialStateVector(9);
            s.wx = initialStateVector(10);
            s.wy = initialStateVector(11);
            s.wz = initialStateVector(12);
            s.ax=0;
            s.ay=0;
            s.az=0;
            s.ex=0;
            s.ey=0;
            s.ez=0;
            %% KINEMATYKA
            if s.vx ~= 0
                s.driftAngle = atan(s.vy/s.vx);
            else
                s.driftAngle = 0;
            end
            s.speed = sqrt(s.vx*s.vx + s.vy*s.vy);
            %% INICJALIZACJA GEOSTATYCZNYCH DANYCH STATKU
            %podstawowe
            s.length = shipData(6);
            
            s.wznd = s.wz*s.length/s.speed;
            s.vynd = s.vy/s.speed;
            
            s.breadth = (shipData(7));
            s.draught = (shipData(8));
            s.cB = (shipData(9));
            
            s.sW = (shipData(13));
            
            s.xG = (shipData(18));
            s.yG = (shipData(19));
            s.zG = (shipData(20));
            s.rXX = (shipData(21));
            s.rYY = (shipData(22));
            s.rZZ = (shipData(23));
            
            s.GM = (shipData(41));
            s.KG = (shipData(42));
            
            % AIR
            s.airAreaX = (shipData(111));
            s.airAreaY = (shipData(112));
            s.xAir = (shipData(113));
            s.yAir = (shipData(114));
            s.zAir = (shipData(115));
            s.cAx = (shipData(116));
            s.cAy = (shipData(117));
            s.cAz = (shipData(118));
            % PROPELLER
            s.propellerDiameter = (shipData(52));
            s.kT0 = (shipData(54));
            s.kT1 = (shipData(55));
            s.kT2 = (shipData(56));
            s.xP = shipData(57);
            s.yPropellerForceCoefficient = shipData(58);
            if shipData(87) == 0 %thrust deduction factor tP
            s.thrustDeduction = 0.3;
            else
            s.thrustDeduction = shipData(87);
            end
            if shipData(86) == 0 %wake fraction coefficient
            s.wakeFraction = 0.4;
            else
            s.wakeFraction = shipData(86);
            end
            s.propellerJ = 0;
            s.propellerKT = 0;
            s.wakeFractionNew=s.wakeFraction;
            s.yPropellerForceCoefficient = shipData(58);
            % RUDDER
            if shipData(42) == 0
                s.rudderArea = 0.01*(1+25*((s.breadth*s.breadth)/(s.length*s.length)))*s.length*s.draught;
            else
                s.rudderArea = shipData(66);
            end
            s.vyR=0;
            s.cTH=1;
            s.betaR=0;
            s.FN=0;
            s.cTHDrop=1;
            s.vRudder=0;
            s.uRudder=0;
            s.VRudder=0;
            s.alfaRudder = 0;
            s.betaLocal = 0;
            s.h1 = 0;
            s.h2 = 0;
            s.h3 = 0;
            s.rudderDelta =  shipData(67);
            s.rudderCoefficient1 = 2.06*s.cB*s.breadth/s.length+0.14;
            s.rudderCoefficient2 = -0.9;
            s.rudderCoefficient3 = 2.26*1.82*0.7;
            s.rudderCoefficient4 = 0.55 - 0.8*s.cB*s.breadth/s.length+0.14;
            s.tR =  shipData(68);
            s.aH =  shipData(69);
            s.xR =  shipData(70);
            s.xH =  shipData(71);
            s.rudderEpsilon =  shipData(72);
            s.rudderEta =  shipData(73);
            s.rudderKappa =  shipData(74);
            s.rudderGammaPos =  shipData(75);
            s.rudderGammaNeg =  shipData(76);
            s.rudderLR =  shipData(77);
            s.rudderC1 =  shipData(78);
            s.rudderC2Pos =  shipData(79);
            s.rudderC2Neg =  shipData(80);
            s.rudderSpeed=  shipData(81);
            
            s.vRudder = 0;
            s.vRudder = 0;
            % WSPÓ£CZYNNIKI HYDRODYNAMICZNE / HYDRODYNAMIC COEFFICIENTS
            s.R_0 = (shipData(91));
                s.shipAspectRatio = 2*s.draught/s.length;
                s.shipAddedMassCoefficient = s.cB*s.breadth / s.length;
            if shipVector.isOwnSet==false
                s.X_vv = shipData(92);
                s.X_vr = shipData(93);
                s.X_rr =shipData(94);
                s.X_vvvv=shipData(95);
                s.Y_v =shipData(96);
                s.Y_r =shipData(97);
                s.Y_vvv =shipData(98);
                s.Y_rrr = shipData(99);
                s.Y_vrr =shipData(100);
                s.Y_vvr =shipData(101);
                s.N_v =shipData(102);
                s.N_r =shipData(103);
                s.N_vvv =shipData(104);
                s.N_rrr = shipData(105);
                s.N_vvr =shipData(106);
                s.N_vrr =shipData(107);
            else
                s.X_vv = shipVector.ownSet(1);
                s.X_vr = shipVector.ownSet(2);
                s.X_rr =shipVector.ownSet(3);
                s.X_vvvv=shipVector.ownSet(4);
                s.Y_v =shipVector.ownSet(5);
                s.Y_r =shipVector.ownSet(6);
                s.Y_vvv =shipVector.ownSet(7);
                s.Y_rrr = shipVector.ownSet(8);
                s.Y_vrr =shipVector.ownSet(9);
                s.Y_vvr =shipVector.ownSet(10);
                s.N_v =shipVector.ownSet(11);
                s.N_r =shipVector.ownSet(12);
                s.N_vvv =shipVector.ownSet(13);
                s.N_rrr = shipVector.ownSet(14);
                s.N_vvr =shipVector.ownSet(15);
                s.N_vrr =shipVector.ownSet(16);
            end
            % Uzupe³nienie zbioru wspó³czynników hydrodynamicznych
            s.hydroSet(1)=s.X_vv;
            s.hydroSet(2)=s.X_vr;
            s.hydroSet(3)=s.X_rr;
            s.hydroSet(4)=s.X_vvvv;
            s.hydroSet(5)=s.Y_v;
            s.hydroSet(6)=s.Y_r;
            s.hydroSet(7)=s.Y_vvv;
            s.hydroSet(8)=s.Y_rrr;
            s.hydroSet(9)=s.Y_vrr;
            s.hydroSet(10)=s.Y_vvr;
            s.hydroSet(11)=s.N_v;
            s.hydroSet(12)=s.N_r;
            s.hydroSet(13)=s.N_vvv;
            s.hydroSet(14)=s.N_rrr;
            s.hydroSet(15)=s.N_vvr;
            s.hydroSet(16)=s.N_vrr;
            
             % MASA, MASY DODANE, MOMENTY BEZW£ADNOŒCI I MOMENTY BEZW£ADNOŒCI DODANE
            s.m = shipData(24);
            s.Ixx = s.m * s.rXX * s.rXX;
            s.Iyy = s.m * s.rYY * s.rYY;
            s.Izz = s.m * s.rZZ * s.rZZ;
            s.m11 = shipData(25);
            s.m22 = shipData(26);
            s.m33 = shipData(27);
            s.m44 = shipData(28);
            s.m55 = shipData(29);
            s.m66 = shipData(30);
            s.m24 = shipData(31);
            s.m26 = shipData(32);
            s.m31 = shipData(33);
            s.m35 = shipData(34);
            s.m46 = shipData(35);
            s.m51 = shipData(36);
            
            %% KONTUR / OBRYS
            if outlineCode == "rect"
                s.outlineX = zeros(5);
                s.outlineY = zeros(5);
                s.outlineX(1)=s.length/2;
                s.outlineY(1)=0;
                
                s.outlineX(2)=s.length/2;
                s.outlineY(2)=s.breadth/2;
                
                s.outlineX(3)=-s.length/2;
                s.outlineY(3)=s.breadth/2;
                
                s.outlineX(4)=-s.length/2;
                s.outlineY(4)=-s.breadth/2;
                                
                s.outlineX(5)=s.length/2;
                s.outlineY(5)=-s.breadth/2;   
            elseif outlineCode == "diamond"
                s.outlineX = zeros(8);
                s.outlineY = zeros(8);
                s.outlineX(1)=s.length/2;
                s.outlineY(1)=0;
                
                s.outlineX(2)=0.8*s.length/2;
                s.outlineY(2)=s.breadth/2;
                
                s.outlineX(3)=0;
                s.outlineY(3)=s.breadth/2;
                
                s.outlineX(4)=-0.95*s.length/2;
                s.outlineY(4)=s.breadth/2;
                
                s.outlineX(5)=-s.length/2;
                s.outlineY(5)=0;
                
                s.outlineX(6)=-0.95*s.length/2;
                s.outlineY(6)=-s.breadth/2;
                
                s.outlineX(7)=0;
                s.outlineY(7)=-s.breadth/2;
                
                s.outlineX(8)=0.8*s.length/2;
                s.outlineY(8)=-s.breadth/2;
            elseif    outlineCode == "true"
                nameStr=s.name+'Obrys.mat';
                file = matfile(nameStr);
                wynik = file.wynik;
                N=length(wynik(:,1));
                s.outlineX=zeros(2*N);
                s.outlineY=zeros(2*N);
                for i=1:N
                    s.outlineX(i)=wynik(i,2);
                    s.outlineY(i)=wynik(i,3);
                end
                for i=1:N
                    s.outlineX(i+N)=wynik(N-i+1,2);
                    s.outlineY(i+N)=-wynik(N-i+1,3);
                end
            else
                s.outlineX = zeros(5);
                s.outlineY = zeros(5);
                s.outlineX(1)=s.length/2;
                s.outlineY(1)=0;
                
                s.outlineX(2)=s.length/2;
                s.outlineY(2)=s.breadth/2;
                
                s.outlineX(3)=-s.length/2;
                s.outlineY(3)=s.breadth/2;
                
                s.outlineX(4)=-s.length/2;
                s.outlineY(4)=-s.breadth/2;
                                
                s.outlineX(5)=s.length/2;
                s.outlineY(5)=-s.breadth/2;   
            end
            
            %% MACIERZ MAS I MAS DODANYCH
            s.M = zeros(3,3);
            s.M = [s.m*(1+s.m11) 0 0;
                0 s.m*(1+s.m22) s.xG*s.m;
                0 s.xG*s.m s.Izz*(1+s.m66)+s.xG*s.xG*s.m];
            s.M = inv(s.M);
            s.C = [0 -(s.m+s.m22)*s.wz -s.xG*s.m*s.wz;
                (s.m+s.m11)*s.wz 0 0;
                s.xG*s.m*s.wz 0 0];
            s.P = [0; 0; 0];
            s.Acc = [0; 0; 0];
            s.V = [s.vx; s.vy; s.wz];
            s.ForceX = 0;
            s.Phull = [0; 0; 0];
            s.Ppropeller = [0; 0; 0];
            s.Prudder = [0; 0; 0];
            s.Pair = [0; 0; 0];
            s.Pwave = [0; 0; 0];
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
        function s=updateRudder(obj,timeStep)
            if obj.rudderAngleSet~=obj.rudderAngle
               delta=abs(obj.rudderAngleSet-obj.rudderAngle);
               if delta<obj.rudderSpeed*timeStep
                   obj.rudderAngle=obj.rudderAngleSet;
               else
                  if obj.rudderAngleSet > obj.rudderAngle
                      obj.rudderAngle=obj.rudderAngle+obj.rudderSpeed*timeStep;
                  else
                      obj.rudderAngle=obj.rudderAngle-obj.rudderSpeed*timeStep;
                  end
               end
            end
            s=obj; 
        end
        function s = setRudderOrder(obj,rudder)
            obj.rudderAngleSet = rudder;
            s=obj;
        end
        function s = updateShip(obj,newStateVector)
            obj.x = newStateVector(1);
            obj.y = newStateVector(2);
            obj.z = newStateVector(3);
            obj.roll = newStateVector(4);
            obj.pitch = newStateVector(5);
            obj.heading = newStateVector(6);
            if newStateVector(7)==666
            obj.vx = obj.speedExp;
            else
            obj.vx = newStateVector(7);                
            end
            obj.vy = newStateVector(8);
            obj.vz = newStateVector(9);
            obj.wx = newStateVector(10);
            obj.wy = newStateVector(11);
            obj.wz = newStateVector(12);
            obj.speed=sqrt(obj.vx*obj.vx+obj.vy*obj.vy);
            obj.wznd = obj.wz*obj.length/obj.speed;
            obj.vynd = obj.vy/obj.speed;
            s = obj;
        end
        function s = updateSet(s,ownSet)
           s.X_vv = ownSet(1);
                s.X_vr = ownSet(2);
                s.X_rr =ownSet(3);
                s.X_vvvv=ownSet(4);
                s.Y_v =ownSet(5);
                s.Y_r =ownSet(6);
                s.Y_vvv =ownSet(7);
                s.Y_rrr = ownSet(8);
                s.Y_vrr =ownSet(9);
                s.Y_vvr =ownSet(10);
                s.N_v =ownSet(11);
                s.N_r =ownSet(12);
                s.N_vvv =ownSet(13);
                s.N_rrr = ownSet(14);
                s.N_vvr =ownSet(15);
                s.N_vrr = ownSet(16); 
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
        
        %% pojedyncze wyliczenia si³ i momentów
        function f = forceHull(obj, vx, vy, wz)
            f=[0;0;0];
            s=sqrt(vx^2+vy^2);
            vynd=vy/s;
            wznd=wz*obj.length/s;
        %X
            f(1) = (...
                obj.R_0 + ...
                obj.X_vv*vynd^2 + ...
                obj.X_vr*vynd*wznd + ...
                obj.X_rr*wznd^2 + ...
                obj.X_vvvv*vynd^4);
            %Y
            f(2) = (...
                obj.Y_v*vynd + ...
                obj.Y_r*wznd + ...
                obj.Y_vvv*vynd^3 + ...
                obj.Y_vvr*vynd*vynd*wznd + ...
                obj.Y_vrr*vynd*wznd*wznd + ...
                obj.Y_rrr*wznd^3);
            %N
            f(3) = (...
                obj.N_v*obj.vynd + ...
                obj.N_r*obj.wznd + ...
                obj.N_vvv*vynd^3 + ...
                obj.N_vvr*vynd*vynd*wznd + ...
                obj.N_vrr*vynd*wznd*wznd + ...
                obj.N_rrr*wznd^3);
        end
        function f = forceRudder(obj, delta, vx, vy, wz)
            f=[0;0;0];
            s=sqrt(vx^2+vy^2);
            vynd=vy/s;
            wznd=wz*obj.length/s;
            driftAngle = atan(-vy/vx);
            %X
            betaP = driftAngle -obj.xP*wznd;
            if betaP > 0                
            fBeta = (2.718^(-obj.rudderC1*abs(betaP)))*(obj.rudderC2Pos-1);
            else
            fBeta = (2.718^(-obj.rudderC1*abs(betaP)))*(obj.rudderC2Neg-1);                
            end
            obj.wakeFractionNew = 1 - (1+fBeta)*(1-obj.wakeFraction);
            if obj.propellerRotation == 0 || 0 >= vx
                obj.propellerJ = 0;
            else
                obj.propellerJ = ((1-obj.wakeFractionNew)*vx)/(obj.propellerDiameter*obj.propellerRotation);
            end
            
            obj.propellerKT = obj.kT0 + obj.kT1 * obj.propellerJ + obj.kT2*obj.propellerJ*obj.propellerJ;
            if obj.propellerRotation == 0 || 0>=vx
                uR=0;
                vR=0;
                obj.betaLocal=0;
            else              
                uR=vx*obj.rudderEpsilon*(1-obj.wakeFractionNew)*...
                    sqrt(obj.rudderEta*(1+obj.rudderKappa*(sqrt(1+(8*obj.propellerKT)/(3.14*obj.propellerJ*obj.propellerJ))-1))^2+...
                (1-obj.rudderEta));
                betaR=driftAngle+0.71*wznd;
                if betaR > 0                    
                    vR=s*betaR*obj.rudderGammaPos;
                else                    
                    vR=s*betaR*obj.rudderGammaNeg;
                end
                obj.betaLocal = -atan(vR/uR)*57.3;
            end
            obj.alfaRudder = delta + obj.betaLocal;
            vRudder=sqrt(vR^2 + uR^2);
            ForceRudder = 0.5 * obj.waterDensity*obj.rudderArea*vRudder*vRudder*obj.rudderDelta*sin(delta/57.3);
            ForceRudder = ForceRudder/(0.5*obj.waterDensity*obj.length*obj.draught*s^2);
            %X
            f(1) = -(1-obj.tR)*ForceRudder*sin(delta/57.3);
            %Y
            f(2) = -(1+obj.aH)*ForceRudder*cos(delta/57.3);
            %N
            f(3) = -(obj.xR+obj.aH*obj.xH)*ForceRudder*cos(delta/57.3);
        end
        function f = forcePropeller(obj, vx, vy, wz)
            f=[0;0;0];
            s=sqrt(vx^2+vy^2);
            vynd=vy/s;
            wznd=wz*obj.length/s;
            driftAngle = atan(-vy/vx);
            %X
            betaP = driftAngle -obj.xP*wznd;
            if betaP > 0                
            fBeta = (2.718^(-obj.rudderC1*abs(betaP)))*(obj.rudderC2Pos-1);
            else
            fBeta = (2.718^(-obj.rudderC1*abs(betaP)))*(obj.rudderC2Neg-1);                
            end
            obj.wakeFractionNew = 1 - (1+fBeta)*(1-obj.wakeFraction);
            if obj.propellerRotation == 0 || 0 >= vx
                obj.propellerJ = 0;
            else
                obj.propellerJ = ((1-obj.wakeFractionNew)*vx)/(obj.propellerDiameter*obj.propellerRotation);
            end
            
            obj.propellerKT = obj.kT0 + obj.kT1 * obj.propellerJ + obj.kT2*obj.propellerJ*obj.propellerJ;
            f(1) = (1-obj.thrustDeduction)*obj.waterDensity * obj.propellerRotation * obj.propellerRotation *...
                obj.propellerDiameter^4*obj.propellerKT;
            f(1) = f(1)/(0.5*9.81*obj.length*obj.draught*s^2);
            %Y
            f(2) = obj.yPropellerForceCoefficient*f(1);
            %N
            f(3) = -0.5*f(2);
        end
        %% CA£OŒCIOWE OBLICZENIA HYDRODYNAMICZNE
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
            %X
            obj.Xhull = 0.5*obj.waterDensity*obj.length*obj.draught*obj.speed*abs(obj.speed)*(...
                obj.R_0 + ...
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
                        
            %% PROPELLER FORCES
            %X
            betaP = obj.driftAngle -obj.xP*obj.wznd;
            if betaP > 0                
            fBeta = (2.718^(-obj.rudderC1*abs(betaP)))*(obj.rudderC2Pos-1);
            else
            fBeta = (2.718^(-obj.rudderC1*abs(betaP)))*(obj.rudderC2Neg-1);                
            end
            obj.wakeFractionNew = 1 - (1+fBeta)*(1-obj.wakeFraction);
            if obj.propellerRotation == 0 || 0 >= obj.vx
                obj.propellerJ = 0;
            else
                obj.propellerJ = ((1-obj.wakeFractionNew)*obj.vx)/(obj.propellerDiameter*obj.propellerRotation);
            end
            
            obj.propellerKT = obj.kT0 + obj.kT1 * obj.propellerJ + obj.kT2*obj.propellerJ*obj.propellerJ;
            obj.Xpropeller = (1-obj.thrustDeduction)*obj.waterDensity * obj.propellerRotation * obj.propellerRotation *...
                obj.propellerDiameter^4*obj.propellerKT;
            %Y
            obj.Ypropeller = obj.yPropellerForceCoefficient*obj.Xpropeller;
            %N
            obj.Npropeller = -0.5*obj.Ypropeller*obj.length;
            
            %% RUDDER FORCES
            
            if obj.propellerRotation == 0 || 0>=obj.vx
                uR=0;
                vR=0;
                obj.alfaRudder = obj.rudderAngle;
            else              
                uR=obj.vx*obj.rudderEpsilon*(1-obj.wakeFractionNew)*...
                    sqrt(obj.rudderEta*(1+obj.rudderKappa*(sqrt(1+(8*obj.propellerKT)/(3.14*obj.propellerJ*obj.propellerJ))-1))^2+...
                (1-obj.rudderEta));
                betaR=obj.driftAngle-obj.rudderLR*obj.wznd;
                if betaR > 0                    
                    vR=obj.speed*betaR*obj.rudderGammaPos;
                else                    
                    vR=obj.speed*betaR*obj.rudderGammaNeg;
                end
                obj.alfaRudder = obj.rudderAngle-atan(vR/uR);
            end
            vRudder=sqrt(vR^2 + uR^2);
            ForceRudder = 0.5 * obj.waterDensity*obj.rudderArea*vRudder*vRudder*obj.rudderDelta*sin(obj.alfaRudder);
            %X
            obj.Xrudder = -(1-obj.tR)*ForceRudder*sin(obj.rudderAngle);
            %Y
            obj.Yrudder = -(1+obj.aH)*ForceRudder*cos(obj.rudderAngle);
            %N
            obj.Nrudder = -(obj.xR+obj.aH*obj.xH)*ForceRudder*obj.length*cos(obj.rudderAngle);
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
        function c=calculateDynamics2(s)
            %24 kroki
            %1
            s.speed=sqrt(s.vx^2+(s.vy-s.wz*s.xG)^2);
            %2 & 3 & 4
            if s.speed==0
                s.driftAngle = 0;
                s.vynd=0;
                s.wznd=0;
            else
                s.driftAngle=asin((-s.vy-s.wz*s.xG)/s.speed);
                s.vynd=s.vy/s.speed;
                s.wznd=s.wz*s.length/s.speed;
            end
            %5
            s.wakeFractionNew=s.wakeFraction*exp(-4*(s.driftAngle-s.xP*s.wznd)^2);
            %6
            s.propellerJ=((1-s.wakeFractionNew)*s.vx)/(s.propellerRotation*s.propellerDiameter);
            %7
            s.propellerKT=s.kT0+s.kT1*s.propellerJ+s.kT2*s.propellerJ^2;
            %8
            betaR=s.driftAngle-s.rudderLR*s.wznd;
            %9
            if betaR>0
                gamma=s.rudderGammaPos;
            else
                gamma=s.rudderGammaNeg;
            end
            %10
            s.vRudder=s.speed*gamma*betaR;
            %11
            s.uRudder=s.vx*(1-s.wakeFractionNew)*s.rudderEpsilon*sqrt(s.rudderEta*(1+...
                s.rudderKappa*(sqrt(1+2.258*s.propellerKT/(s.propellerJ^2))-1))^2+(1-s.rudderEta));
            %12
            s.VRudder=sqrt(s.vRudder^2+s.uRudder^2);
            %13
            s.alfaRudder=s.rudderAngle-atan(s.vRudder/s.uRudder);
            %14
            FN=0.5*s.rudderArea*s.waterDensity*s.rudderDelta*s.VRudder*s.VRudder*sin(s.alfaRudder);
            %15
            s.Xhull=0.5*s.waterDensity*s.length*s.draught*s.speed*s.speed*...
                (-s.R_0 + ...
                s.X_vv*s.vynd*s.vynd + ...
                s.X_vr*s.vynd*s.wznd + ...
                s.X_rr*s.wznd*s.wznd + ...
                s.X_vvvv*s.vynd*s.vynd*s.vynd*s.vynd);
            %16
            s.Xrudder=-(1-s.tR)*FN*sin(s.rudderAngle);
            %17
            s.Xpropeller=(1-s.thrustDeduction)*s.waterDensity*s.propellerKT*s.propellerRotation^2*s.propellerDiameter^4;
            %18
            s.Yhull = 0.5*s.waterDensity*s.length*s.draught*s.speed*s.speed*(...
                s.Y_v*s.vynd + ...
                s.Y_r*s.wznd + ...
                s.Y_vvv*s.vynd*s.vynd*s.vynd + ...
                s.Y_vvr*s.vynd*s.vynd*s.wznd + ...
                s.Y_vrr*s.vynd*s.wznd*s.wznd + ...
                s.Y_rrr*s.wznd*s.wznd*s.wznd);
            %19
            s.Yrudder=-(1+s.aH)*FN*cos(s.rudderAngle);
            %20
            s.Nhull = 0.5*s.waterDensity*s.length*s.length*s.draught*s.speed*s.speed*(...
                s.N_v*s.vynd + ...
                s.N_r*s.wznd + ...
                s.N_vvv*s.vynd*s.vynd*s.vynd + ...
                s.N_vvr*s.vynd*s.vynd*s.wznd + ...
                s.N_vrr*s.vynd*s.wznd*s.wznd + ...
                s.N_rrr*s.wznd*s.wznd*s.wznd);
            %21
            s.Nrudder=-(s.xR+s.aH*s.xH)*s.length*FN*cos(s.rudderAngle);            
            %22
            s.ForceX=s.Xhull+s.Xrudder+s.Xpropeller;
            %23
            s.ForceY=s.Yhull+s.Yrudder;            
            %24
            s.MomentN=s.Nhull+s.Nrudder;                       
            c=s;
        end
        function c=calculateDynamics3(s)
            %24 kroki
            %1
            s.speed=sqrt(s.vx^2+(s.vy-s.wz*s.xG)^2);
            %1 & 3 
            if s.vx==0
                s.driftAngle = 0;
                s.vynd=0;
                s.wznd=0;
            else
                s.driftAngle=atan(-s.vy/s.vx);
                s.vynd=s.vy/s.speed;
                s.wznd=s.wz*s.length/s.speed;
            end
            %2
            s.vyR=s.vy-s.wz*0.5*s.length;
            %4
            s.propellerJ=((1-s.wakeFraction)*s.vx)/(s.propellerRotation*s.propellerDiameter);
            %5
            s.propellerKT=s.kT0+s.kT1*s.propellerJ+s.kT2*s.propellerJ^2;
            %6
            s.cTH=2.564*s.propellerKT/(s.propellerJ^2);
            %7
            s.vRudder=s.vx*(1-s.wakeFraction)*sqrt(1+s.cTH);
            %8
            s.betaR=atan(-s.vyR/s.vRudder);
            %9
            s.alfaRudder=s.rudderAngle+s.betaR;
            %10
            s.cTHDrop=-0.0204*s.cTH+1.078;
            %14
            s.FN=0.5*s.rudderArea*s.waterDensity*s.rudderDelta*s.vRudder*s.vRudder*sin(s.alfaRudder);
            %15
            s.Xhull=0.5*s.waterDensity*s.length*s.draught*s.vx*s.vx*...
                (-s.R_0 + ...
                s.X_vv*s.vynd*s.vynd + ...
                s.X_vr*s.vynd*s.wznd + ...
                s.X_rr*s.wznd*s.wznd + ...
                s.X_vvvv*s.vynd*s.vynd*s.vynd*s.vynd);
            %16
            s.Xrudder=-(1)*s.FN*sin(s.rudderAngle);
            %17
            s.Xpropeller=(1-s.thrustDeduction)*s.waterDensity*s.propellerKT*s.propellerRotation^2*s.propellerDiameter^4;
            %18
            s.Yhull = 0.5*s.waterDensity*s.length*s.draught*s.speed*s.speed*(...
                s.Y_v*s.driftAngle + ...
                s.Y_r*s.wznd + ...
                s.Y_vvv*s.vynd*s.vynd*s.vynd + ...
                s.Y_vvr*s.vynd*s.vynd*s.wznd + ...
                s.Y_vrr*s.vynd*s.wznd*s.wznd + ...
                s.Y_rrr*s.wznd*s.wznd*s.wznd);
            %19
            s.Yrudder=-(1+s.aH)*s.FN*cos(s.rudderAngle);
            %20
            s.Nhull = 0.5*s.waterDensity*s.length*s.length*s.draught*s.speed*s.speed*(...
                s.N_v*s.vynd + ...
                s.N_r*s.wznd + ...
                s.N_vvv*s.vynd*s.vynd*s.vynd + ...
                s.N_vvr*s.vynd*s.vynd*s.wznd + ...
                s.N_vrr*s.vynd*s.wznd*s.wznd + ...
                s.N_rrr*s.wznd*s.wznd*s.wznd);
            %21
            %s.Nrudder=-(s.xR+s.aH*s.xH)*s.length*FN*cos(s.rudderAngle);  
            s.Nrudder=-0.5*s.length*s.FN*cos(s.rudderAngle);            
            %22
            s.ForceX=s.Xhull+s.Xrudder+s.Xpropeller;
            %23
            s.ForceY=s.Yhull+s.Yrudder;            
            %24
            s.MomentN=s.Nhull+s.Nrudder;                       
            c=s;
        end
        %% PRZYSPIESZENIA
        function c=calculateAccelerations(obj)
            
            %METODA MACIERZY
            M2 = [0 -(obj.m+obj.m*obj.m22)*obj.wz -obj.xG*obj.m*obj.wz;
                (obj.m+obj.m*obj.m11)*obj.wz 0 0;
                obj.xG*obj.m*obj.wz 0 0];
            obj.V=[obj.vx;obj.vy;obj.wz];
            obj.P=[obj.ForceX+obj.m*(1+obj.m22)*obj.vy*obj.wz+obj.xG*obj.m*obj.wz^2;
                obj.ForceY-obj.m*(1+obj.m11)*obj.vx*obj.wz;
                obj.MomentN-obj.xG*obj.m*(obj.ay+obj.vx*obj.wz)];
            obj.Acc = obj.M*obj.P;
            obj.ax=obj.Acc(1);
            obj.ay=obj.Acc(2);
            obj.wz=obj.Acc(3);
            c = obj;
        end
        function c=calculateAccelerations2(s)
            s.ax = (s.ForceX+s.m*(1+s.m22)*s.vy*s.wz)/(s.m*(1+s.m11));
            s.ay = (s.ForceY-s.m*(1+s.m11)*s.vx*s.wz)/(s.m*(1+s.m22));
            s.ez = (s.MomentN)/(s.Izz*(1+s.m66)+s.xG^2*s.m);            
            c=s;
        end
        function c=calculateAccelerations3(s)
            %25
            s.ax=(s.ForceX+s.m*(1+s.m22)*s.vy*s.wz+s.xG*s.m*s.wz^2)/(s.m*(1+s.m11));
            %26
            s.ay=(s.xG^2*s.m^2*s.vx*s.wz-s.MomentN*s.xG*s.m+(s.ForceY-s.m*(1+s.m11)*s.vx*s.wz)*(s.Izz*(1+s.m66)+s.xG^2*s.m))/(s.m*(1+s.m22)*(s.Izz*(1+s.m66)+s.xG^2*s.m)-s.xG^2*s.m^2);            
            %27
            s.ez=(s.MomentN-s.xG*s.m*(s.ay+s.vx*s.wz))/(s.Izz*(1+s.m66)+s.xG^2*s.m);
            c=s;
        end
        %% integracja
        function c = calculateMovement(obj,timeStep, method)
           obj = obj.updateRudder(timeStep);
           if(method == -1)
               %% KINEMATIC        
               %pozycje                             
               obj.x =obj.x + obj.speed*cos(obj.heading)*timeStep;
               obj.y =obj.y + obj.speed*sin(obj.heading)*timeStep;   
           elseif(method == 0)
               %% EULER EXPLICIT           
               obj = obj.calculateDynamics();
               obj = obj.calculateAccelerations3();
               %prêdkoœci
               obj.vx=obj.vx+obj.ax*timeStep;
               obj.vy=obj.vy+obj.ay*timeStep;
               obj.wz=obj.wz+obj.ez*timeStep;
               %pozycje               
               obj.heading =obj.heading + obj.wz*timeStep;
               obj.vNS = obj.vx*cos(obj.heading)-obj.vy*sin(obj.heading);
               obj.vEW = obj.vx*sin(obj.heading)+obj.vy*cos(obj.heading);               
               obj.x =obj.x + obj.vNS*timeStep;
               obj.y =obj.y + obj.vEW*timeStep;               
           elseif method == 1
               %% EULER IMPLICIT               
               vxPrev = obj.vx;
               vyPrev = obj.vy;
               wzPrev = obj.wz;
               axPrev = obj.ax;
               ayPrev = obj.ay;
               ezPrev = obj.ez;
               obj = obj.calculateDynamics();
               obj = obj.calculateAccelerations3();
               %prêdkoœci
               obj.vx=obj.vx+obj.ax*timeStep;
               obj.vy=obj.vy+obj.ay*timeStep;
               obj.wz=obj.wz+obj.ez*timeStep;  
               %ponownie
               obj = obj.calculateDynamics();
               obj = obj.calculateAccelerations3();
               obj.vx=vxPrev+obj.ax*timeStep;
               obj.vy=vyPrev+obj.ay*timeStep;
               obj.wz=wzPrev+obj.ez*timeStep;  
               %pozycje               
               obj.heading =obj.heading+wzPrev*timeStep;
               obj.vNS = obj.vx*cos(obj.heading)-obj.vy*sin(obj.heading);
               obj.vEW = obj.vx*sin(obj.heading)+obj.vy*cos(obj.heading);               
               obj.x =obj.x +obj.vNS*timeStep;
               obj.y =obj.y +obj.vEW*timeStep; 
           elseif method == 2
               %% CRANK-NICOLSON               
               vxPrev = obj.vx;
               vyPrev = obj.vy;
               wzPrev = obj.wz;
               axPrev = obj.ax;
               ayPrev = obj.ay;
               ezPrev = obj.ez;
               obj = obj.calculateDynamics();
               obj = obj.calculateAccelerations3();
               %prêdkoœci
               obj.vx=obj.vx+0.5*(obj.ax+axPrev)*timeStep;
               obj.vy=obj.vy+0.5*(obj.ay+ayPrev)*timeStep;
               obj.wz=obj.wz+0.5*(obj.ez+ezPrev)*timeStep;
               %pozycje           
               vNSPrev = vxPrev*cos(obj.heading)-vyPrev*sin(obj.heading);
               vEWPrev = vxPrev*sin(obj.heading)+vyPrev*cos(obj.heading);    
               obj.heading =obj.heading + 0.5*(obj.wz+wzPrev)*timeStep;
               obj.vNS = obj.vx*cos(obj.heading)-obj.vy*sin(obj.heading);
               obj.vEW = obj.vx*sin(obj.heading)+obj.vy*cos(obj.heading);               
               obj.x =obj.x + 0.5*(obj.vNS + vNSPrev)*timeStep;
               obj.y =obj.y + 0.5*(obj.vEW + vEWPrev)*timeStep; 
           elseif method == 3
               %% RUNGE-KUTTA 2ND ORDER              
               vxPrev = obj.vx;
               vyPrev = obj.vy;
               wzPrev = obj.wz;
               %k1
               k1vx=timeStep*obj.ax;
               k1vy=timeStep*obj.ay;
               k1wz=timeStep*obj.ez;
               
               obj = obj.calculateDynamics();
               obj = obj.calculateAccelerations3();
               
               obj.vx=obj.vx+k1vx;
               obj.vy=obj.vy+k1vy;
               obj.wz=obj.wz+k1wz; 
               
               %k2
               k2vx=timeStep*obj.ax;
               k2vy=timeStep*obj.ay;
               k2wz=timeStep*obj.ez;
               
               %prêdkoœci
               obj.vx=obj.vx+0.5*(k1vx+k2vx);
               obj.vy=obj.vy+0.5*(k1vy+k2vy);
               obj.wz=obj.wz+0.5*(k1wz+k2wz); 
               
               %pozycje               
               vNSPrev = vxPrev*cos(obj.heading)-vyPrev*sin(obj.heading);
               vEWPrev = vxPrev*sin(obj.heading)+vyPrev*cos(obj.heading);
               obj.heading =obj.heading + 0.5*(wzPrev+obj.wz)*timeStep; 
               obj.vNS = obj.vx*cos(obj.heading)-obj.vy*sin(obj.heading);
               obj.vEW = obj.vx*sin(obj.heading)+obj.vy*cos(obj.heading);               
               obj.x =obj.x + 0.5*(obj.vNS + vNSPrev)*timeStep;
               obj.y =obj.y + 0.5*(obj.vEW + vEWPrev)*timeStep; 
           elseif method == 4
               %% RUNGE-KUTTA 4ND ORDER
               vxPrev = obj.vx;
               vyPrev = obj.vy;
               wzPrev = obj.wz;
               %k1
               k1vx=timeStep*obj.ax;
               k1vy=timeStep*obj.ay;
               k1wz=timeStep*obj.ez;
               
               obj = obj.calculateDynamics();
               obj = obj.calculateAccelerations3();
               
               obj.vx=obj.vx+k1vx;
               obj.vy=obj.vy+k1vy;
               obj.wz=obj.wz+k1wz; 
               
               %k2
               k2vx=timeStep*obj.ax;
               k2vy=timeStep*obj.ay;
               k2wz=timeStep*obj.ez;
               
               %prêdkoœci
               obj.vx=obj.vx+0.5*(k1vx+k2vx);
               obj.vy=obj.vy+0.5*(k1vy+k2vy);
               obj.wz=obj.wz+0.5*(k1wz+k2wz); 
               
               %pozycje               
               vNSPrev = vxPrev*cos(obj.heading)-vyPrev*sin(obj.heading);
               vEWPrev = vxPrev*sin(obj.heading)+vyPrev*cos(obj.heading);
               obj.heading =obj.heading + 0.5*(wzPrev+obj.wz)*timeStep; 
               obj.vNS = obj.vx*cos(obj.heading)-obj.vy*sin(obj.heading);
               obj.vEW = obj.vx*sin(obj.heading)+obj.vy*cos(obj.heading);               
               obj.x =obj.x + 0.5*(obj.vNS + vNSPrev)*timeStep;
               obj.y =obj.y + 0.5*(obj.vEW + vEWPrev)*timeStep; 
           end
           c = obj;
        end
    end
end

