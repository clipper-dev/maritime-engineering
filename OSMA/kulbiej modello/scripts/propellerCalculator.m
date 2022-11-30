%propeller thrust force 
%T = (1 - thrustCoeff)*waterDensity*propellerRotation^2 * propellerDiameter^4 * kT
%kT = kT0 + kT1*J + kT2*J^2
%J = (speed - speed*wakeCoeff) / (propellerRotation*propellerDiameter)
%propeller resistance calm water force
%R = 0.5 * waterDensity*length*draft*resistanceCoeff*speed^2
%% INITIAL
resistanceCoeff = 0.0046;
thrustCoeff = 0.4;
wakeCoeff = 0.3;
waterDensity = 1025;
length = 56.8;
draft = 10.5;
propellerRotation = 3.7;
propellerDiameter = 2.26;
%propeller equation
kT0 = 0.323;
kT1 = -0.232;
kT2 = -0.22;
%% CALCULATION
pc = zeros([300,10]);
for i=1:300
    speed = 0.514*i/20;
    J = (speed - speed*wakeCoeff) / (propellerRotation*propellerDiameter);
    kT = kT0 + kT1*J + kT2*J^2;
    T = (1 - thrustCoeff)*waterDensity*propellerRotation^2 * propellerDiameter^4 * kT;
    R = 0.5 * waterDensity*length*draft*resistanceCoeff*speed^2;
    %save results
    pc(i,1) = speed;
    pc(i,2) = J;
    pc(i,3) = kT;
    pc(i,4) = T;
    pc(i,5) = R;
    pc(i,6) = T - R;
end
