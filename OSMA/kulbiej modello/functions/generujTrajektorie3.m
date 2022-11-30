function [GTData, vessel] = generujTrajektorie3(vessel,calculusVector)
%generujTrajektorie(
%shipVector[isOwnSet - true or false, ownSet - matrix of hydrodynamic coefficients], 
%steeringVector[engineSetting - in percent from -100 to 100; rudder from %-35 to 35]
%calculusVector[duration - in seconds; timeStep -  >=1, defines how many iterations per second, calculusType - 0=eulerImplicit, 1=eulerExplicit, 2=rungeKutta]
%initialStateVecor[x0, y0, z0, roll, pitch, psi0, vx0; vy0; vz0; wx0; wy0; wz0] //accelerations defined to %be zero
%environmentVector[isWeather - true/false, weather - wx data object, isShallow - T/F, depth - value used for calculations]
%% G£ÓWNA SYMULACJA I DANE STERUJ¥CE
time = calculusVector(1);GTData = zeros(time,40);timeStep=1/calculusVector(2);numericalIntegration = calculusVector(3);
%% G£ÓWNE WYLICZENIA
for i=1:time
    %wyliczenia 
    for t=1:calculusVector(2)
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
   
end