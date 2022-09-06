clc;clear
% SADane = [...
%     35 2.0 -0.5 0.54;...
%     30 2.2 -0.5 0.46;...
%     25 2.4 -0.54 0.44;...
%     20 2.8 -0.64 0.36;...
%     15 3.3 -0.7 0.35;...
%     10 3.8 -0.62 0.33];
SADane = [...
    35 2.0 -0.5 0.54;...
    30 2.2 -0.5 0.44;...
    25 2.4 -0.5 0.44;...
    20 2.8 -0.5 0.36;...
    15 3.3 -0.5 0.35;...
    10 3.8 -0.5 0.33];
Yhulls = zeros(6,1);
Nhulls = zeros(6,1);
V = zeros(6,6);
Yhydro = zeros(6,1);
Nhydro = zeros(6,1);
for i=1:6
    u = sqrt(SADane(i,2)^2 + SADane(i,3)^2);
    wz = SADane(i,4)*5.911/60.2;
    vynd = SADane(i,3)/SADane(i,2);
    vynd = SADane(i,3)/u;
    nawigator = shipLoad2("nawigator",SADane(i,1),1,0,0,0,SADane(i,2),SADane(i,3),wz,0,0);
    nawigator = nawigator.calculateDynamics();nawigator = nawigator.calculateAccelerations();
    %Y
    YhullCoeff = 0.5*nawigator.waterDensity*nawigator.length*nawigator.draught*u^2;
    Yhulls(i) = -(nawigator.Yrudder + nawigator.B(2))/YhullCoeff;
    V(i,:) = [vynd SADane(i,4) vynd^3 SADane(i,4)^3 vynd*SADane(i,4)^2 SADane(i,4)*vynd^2];
    %N
    NhullCoeff = 0.5*nawigator.waterDensity*nawigator.length*nawigator.length*nawigator.draught*u^2;
    Nhulls(i) = -(nawigator.Nrudder)/NhullCoeff;
end
V2 = inv(V);
Yhydro = V2*Yhulls;
Nhydro = V2*Nhulls;
result = zeros(12,1);
result(5:10,1) = Yhydro;
result(11:16,1) = Nhydro;
