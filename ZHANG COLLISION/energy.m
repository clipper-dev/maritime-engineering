function energyReleased = energy(shipA, shipB, xC, yC, alpha, beta, e,u0)
%ENERGY Summary of this function goes here
%   Detailed explanation goes here
%% PARAMETRY
%sta³e
alpha = alpha/57.3;
beta = beta/57.3;
gamma = beta - alpha;
dxa = xC - shipA.x;
dxb = xC - shipB.x;
dyb = yC - shipB.y;
%
max = 1/(1+shipA.mx);
may = 1/(1+shipA.my);
iaz = shipA.m/(shipA.i + shipA.i*shipA.iz);
mbx = 1/(1+shipB.mx);
mby = 1/(1+shipB.my);
ibz = shipB.m/(shipB.i + shipB.i*shipB.iz);
a1 = yC * sin(alpha) - dxa*cos(alpha);
a2 = yC*cos(alpha) + dxa*sin(alpha);
b1 = dyb * sin(alpha) - dxb*cos(alpha);
b2 = dyb*cos(alpha) + dxb*sin(alpha);

DAxi = max*sin(alpha)^2 + may*cos(alpha)^2 + iaz*a1*a1;
DBxi = mbx*sin(gamma)^2 + mby*cos(gamma)^2 + ibz*b1*b1;
DAeta = (max - may)*sin(alpha)*cos(alpha)+ iaz*a1*a2;
DBeta = (mbx - mby)*sin(gamma)*cos(gamma)+ ibz*b1*b2;

KAxi = (max - may)*sin(alpha)*cos(alpha) + iaz*a1*a2;
KBxi = (mbx - mby)*sin(gamma)*cos(gamma) + ibz*b1*b2;
KAeta = max*cos(alpha)^2 + may*sin(alpha)^2 + iaz*a2*a2;
KBeta = mbx*cos(gamma)^2 + mby*sin(gamma)^2 + ibz*b2*b2;

Dxi = DAxi/shipA.m + DBxi/shipB.m;
Deta = DAeta/shipA.m + DBeta/shipB.m;
Kxi = KAxi/shipA.m + KBxi/shipB.m;
Keta = KAeta/shipA.m + KBeta/shipB.m;

vxi0 = shipA.vx*sin(alpha) + shipA.vy*cos(alpha) + shipB.vx*sin(gamma) - shipB.vy*cos(gamma);
veta0 = shipA.vx*cos(alpha) - shipA.vy*sin(alpha) - shipB.vx*cos(gamma) - shipB.vy*sin(gamma);
vxiT = -e*vxi0;
vetaT = veta0 - (vxi0 - vxiT)*((Kxi+u0*Keta)/(Dxi+u0*Deta));
u1 = Dxi*veta0 - Kxi * vxi0*(1+e);
u2 = Keta*vxi0*(1+e) - Deta*veta0;
u = u1/u2;

%% XI, OŒ Y
if abs(u)>u0
Exi = 0.5*(1/(Dxi + u*Deta))*vxi0^2 * (1-e)^2;
else
Exi = 0.5*(1/(Dxi + u*Deta))*vxi0^2;
end
%% ETA, OŒ X
if abs(u)>u0
Eeta = 0.5*(1/(Kxi/u + Keta))*(veta0^2 - vetaT^2);
else
Eeta = 0.5*(1/(Kxi/u + Keta))*(veta0^2);
end
energyReleased = Exi + Eeta;
end

