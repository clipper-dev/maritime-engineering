function AWData = analizaWsteczna(shipToLoad,duration, constantOffset)

rudderCorrection = 3;
shipToLoad = "nawigator";
shipLoad;
%% VARS
for i=1:1
    AWData = zeros(duration,30);
    vx = zeros(1,duration).';
    vy = zeros(1,duration).'; 
    wz= zeros(1,duration).';
    U = zeros(1,duration).';
    wznd = zeros(1,duration).';
    vynd = zeros(1,duration).';
    acc = zeros(duration,3);
    Fhull = zeros(duration,3);
    AWInertia = zeros(duration,3);
    % pomocnicze do przechowywania przebiegów sk³adowych zmiennych
    AWRudder = zeros(duration,3);
    AWPropeller = zeros(1,duration).';
    AWResistance = zeros(1,duration).';
    vesselResistanceCoef = vessel.X_0*0.5*vessel.waterDensity*vessel.length*vessel.draught;
    vesselPropellerCoef = (1 - vessel.thrustDeduction)*vessel.waterDensity*vessel.propellerRotation^2 * vessel.propellerDiameter^4;
    vesselAdvanceCoef = (1 - vessel.wakeFraction) / (vessel.propellerRotation * vessel.propellerDiameter);
    vesselRudderCoef = 0.5 *vessel.waterDensity*vessel.rudderArea*1.4;
end
%% ANALIZA
% wype³nienie tablicy znanymi przebiegami
offSet=0;
for time=1:duration
    if time < constantOffset
        vx(time+offSet)=5.6808351061933635e+0 * time^0 +...
            4.5939346629968042e-002 * time^1 +...
            -1.1430150414743051e-002 * time^2 +...
            3.3914512591186254e-004 * time^3 +...
            -4.2977041489057278e-006 * time^4 +...
            2.5433983193198553e-008 * time^5 +...
           -5.7709560613495114e-011 * time^6;
        vy(time+offSet)=-2.8801450828217889e-001 * time^0 +...
            -1.3657256596581299e-001* time^1 +...
           6.4314817733016347e-003 * time^2 +...
            -1.2231117548490691e-004 * time^3 +...
            1.1478186959800362e-006 * time^4 +...
             -5.2924534579001755e-009 * time^5 +...
           9.5789603064620189e-012 * time^6;
        wznd(time+offSet)= -1.9830251175222476e-002 * time^0+...
         +  1.0519042822233636e-001 * time^1+ ...
         + -4.7944618442433209e-003 * time^2+...
         +  9.4980144412250836e-005 * time^3+...
         + -9.4080140275189618e-007 * time^4+...
         +  4.5784079023114825e-009 * time^5+...
         + -8.7126672192652641e-012 * time^6;
        wz(time+offSet) = wznd(time+offSet)*5.911/60;
    else
        vx(time) = vx(time-1);
        vy(time) = vy(time-1);
        wz(time) = wz(time-1);
        wznd(time) = wz(time)*60/5.911;
    end
end
%korekty z rêki
vx(1) = 5.735;
vy(56)=-0.5825;
% wyliczenie pozosta³ych wartoœci WEKTORA STANU w oparciu o znane przebiegi
for i=1:duration
    U(i) = sqrt(vx(i)^2 + vy(i)^2);
    if i < constantOffset + 2
    acc(i,1) = vx(i+1)-vx(i); %przyspieszenie X
    acc(i,2) = vy(i+1)-vy(i); %przyspieszenie Y
    acc(i,3) = wz(i+1)-wz(i); %przyspieszenie WZ
    else 
    acc(i,1) = 0;%acc(i-1,1); %przyspieszenie X
    acc(i,2) = 0;%acc(i-1,2); %przyspieszenie Y
    acc(i,3) = 0;%acc(i-1,3); %przyspieszenie WZ    
    end
end
% obliczanie propeller i rudder
for i=1:duration
    AWResistance(i) = vesselResistanceCoef*vx(i)^2;
    J = vesselAdvanceCoef * vx(i);
    kT = vessel.kT0 + vessel.kT1*J + vessel.kT2*J^2;
    AWPropeller(i) = vesselPropellerCoef * kT;
    cTh = 2.546*kT/(J^2);
    cThDrop = -0.0204*cTh + 1.078;
    vR = vx(i)*(1-vessel.wakeFraction)*sqrt(1+cTh);
    vyR = vy(i) - wz(i)*0.5*vessel.length;
    alfa = vessel.rudderAngle + atan(-vyR/vR)*57.3;
    RudderNormal = vesselRudderCoef*cThDrop*vR^2 * sin(alfa/57.3)*rudderCorrection;
    AWRudder(i,1) = -RudderNormal*sin(vessel.rudderAngle/57.3);
    AWRudder(i,2) = 1.4*RudderNormal*cos(vessel.rudderAngle/57.3);
    AWRudder(i,3) = -AWRudder(i,2)*0.5*vessel.length;
end
% wyznaczenie sk³adowych szukanego wektora si³ oporu kad³uba
for i=1:duration
    % wyznaczanie sk³adowych inercyjnych
    AWInertia(i,1) = vy(i)*wz(i)*(vessel.m+vessel.my);
    AWInertia(i,2) = -vx(i)*wz(i)*(vessel.m+vessel.mx);
    % wyznaczenie si³
    Fhull(i,1) = acc(i,1)*(vessel.m+vessel.mx)      - AWRudder(i,1) -AWPropeller(i) -AWResistance(i)   -AWInertia(i,1);
    Fhull(i,2) = acc(i,2)*(vessel.m+vessel.my)      - AWRudder(i,2)                                     -AWInertia(i,2);
    Fhull(i,3) = acc(i,3)*(vessel.jzz+vessel.Izz)   - AWRudder(i,3);
end
%% kompletowanie
%AWData(:,1) = ; 
%AWData(:,2) = ;
%AWData(:,3) = ;
%AWData(:,4) = ;
AWData(:,5) = wznd;
%AWData(:,6) = ;
AWData(:,7) = U;
AWData(:,8) = vx;
AWData(:,9) = vy;
AWData(:,10) = wz;
%AWData(:,11) = acc(:,1);
%AWData(:,12) = acc(:,2);
%AWData(:,13) = acc(:,3);
%AWData(:,14) = wznd;
%AWData(:,15) = wznd;
%AWData(:,16) = wznd;
%disp("Wyliczenia fini");
end