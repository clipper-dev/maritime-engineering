for q=1
%SHIP Wektor stanu statku
%midship definiowany jest w po³owie d³ugoœci
% STA£E I PRZELICZNIKI
pi = 3.1415;
water_Density = 1025;
air_Density = 50;
% PODSTAWOWE DANE GEOMETRYCZNE / GENERAL PARTICULARS
length = 320;
breadth = 58;
draught = 20.8;
c_b = 0.8098; %wspó³czynnik pe³notliwoœci podwodzia
s_W = 27194; %powierzchnia zwil¿ona kad³uba
xG = 11.136; %wspó³rzêdna œrodka ciê¿koœci od midshipu
zG = draught * 0.5; %wspó³rzena œrodka ciê¿koœci od p³aszczyzny podstawowej
GM = 5.71; %pocz¹tkowa wysokoœæ metacentryczna
GML0 = 0;
GMT0 = GM;
KG = 18.56; %wzniesienie punktu metacentrycznego
rXX = 23.2; %ramienia momentów bezw³adoœci masy wokó³ osi x y z
rYY = 80;
rZZ = 80;
A_WP = 0; %waterplane area
deltaZ = 0; %TODO
% DANE PÊDNIKA / PROPELLER DETAILS
propellerDiameter = 9.86; %œrednica
p_d = 0.721; %
Ae_A0 = 0.431; %
Z = 4; %liczba ostrzy
Np = 1; %liczba œrub
xp = -153.5; %wspó³rzêdna po³o¿enia œruby od midshipu
kT0 = 0.2943; %wspó³rzêdne wielomianu drugiego stopnia którym aproksymuje siê krzyw¹ charakterystyki œruby
kT1 = -0.272;
kT2 = -0.148;
wakeFraction = 0.35;
% DANE STERU / RUDDER SPECIFICATION
S_R = 273.3;
A_R = 136.7;
A_Rmov = 112.5;
delta_R = 1.826;
xRudder = 161.5;
zRudder = 6.5;
RUDDER_ROTATION = 2.34;
% WSPÓ£CZYNNIKI HYDRODYNAMICZNE / HYDRODYNAMIC COEFFICIENTS
if deep == true
    X_vv = -0.003;
    X_vr = 0;
    X_rr =0.001;
    X_vvvv=0.053;
    Y_v =-0.02;
    Y_r =0.005;
    Y_vvv =-0.103;
    Y_rrr = 0;
    Y_vrr =-0.025;
    Y_vvr =0.024;
    N_v =-0.009;
    N_r =-0.003;
    N_vvv =-0.002;
    N_rrr = -0.001;
    N_vrr =0.004;
    N_vvr =-0.019;
else
    X_vv = -0.145;
    X_vr =0.002;
    X_rr =0;
    X_vvvv0;
    Y_v =-0.093;
    Y_r =0.004;
    Y_vvv =-2.012;
    Y_rrr = 0.02;
    Y_vrr =-0.129;
    Y_vvr =0.082;
    N_v =-0.034;
    N_r =-0.003;
    N_vvv =-0.034;
    N_rrr = -0.01;
    N_vrr =-0.013;
    N_vvr =0.014;
end
% MASA, MASY DODANE, MOMENTY BEZW£ADNOŒCI I MOMENTY BEZW£ADNOŒCI DODANE
m = length * breadth * draught * c_b * water_Density;
Ixx = m * rXX * rXX;
Iyy = m * rYY * rYY;
Izz = m * rZZ * rZZ;
X_0 = -0.022;
if deep == true
    X_u1 = m / (pi * sqrt((length*length)/(breadth*draught*c_b))-14);
    Y_v1 = 0.5*water_Density*length*length*length*(-3.14*((draught/length)/(draught/length))*(1+0.16*(c_b*breadth/draught)-5.1*((breadth/length)/(breadth/length))));
    Y_p1 = Y_v1*(KG - 0.5*draught);
    Y_r1 = 0.5*water_Density*length*length*length*length*-3.14*(((draught/length)/(draught/length))*(0.67*(breadth/length)-0.0033*((breadth/draught)/(breadth/draught))));
    Z_w1 = -1.08*m;
    Z_q1 = -0.9*Iyy/length;
    K_v1 = Y_p1;
    K_p1 = -0.2*Ixx;
    K_r1 = -0.0085*Iyy;
    M_q1 = length*Z_q1;
    N_v1 = Y_r1;
    N_r1 = 0.5*water_Density*length*length*length*(-3.14*((draught/length)/(draught/length))*(0.0833+0.017*(c_b*breadth/draught)-0.0033*(breadth/length)));
else
    
 end
% A = [1.05*m 0 0 0 0 0;
%     0 2*m 0 0 0 0;
%     0 0 0 0 0 0;
%     0 0 0 0 0 0;
%     0 0 0 0 0 0;
%     0 0 0 0 0 2*Izz]
% 
A = [m-X_u1 0 0 0 m*zG-0.5*X_u1*draught 0;
    0 m-Y_v1 0 -m*zG-Y_p1 0 m*xG-Y_r1;
    0 0 m-Z_w1 0 -m*xG-Z_q1 0;
    0 -m*zG-K_v1 0 Ixx-K_p1 0 m*xG*zG-K_r1;
    m*zG-0.5*X_u1*draught 0 -m*xG-Z_q1 0 Iyy-M_q1 0;
    0 m*xG-N_v1 0 -m*xG*zG+K_r1 0 Izz-N_r1]
A = inv(A)
end
