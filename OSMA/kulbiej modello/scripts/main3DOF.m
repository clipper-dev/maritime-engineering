%% pocz¹tkowy wektor stanu statku
p0 = [0 0 0]; %pozycja x y z w uk³adzie odniesienia zwi¹zanym z ziemi¹
r0 = [0 0 0]; %zorientowanie statku w przestrzeni list, trim, heading
v0 = [8 0 0]; %prêdkoœci statku Vx Vy Vz w uk³adzie zwi¹zanym ze statkiem
a0 = [0 0 0]; %przyspieszenia liniowe statku wzd³u¿ osi x y z, w uk³adzie zwi¹zanym ze statkiem
w0 = [0 0 0]; %obrót statku, k¹ty wokó³ x y z, roll, pitch, yaw w uk³¹dzie zwi¹zanym ze statkiem
e0 = [0 0 0]; %przyspieszenia k¹towe statku wokó³ osi x y z, w uk³adzie zwi¹zanym ze statkiem 
%% dane symulacji
t = 3000; %sekund
dt = 1; %krok czasowy
calculusMethod = "euler";
deep = true;
RUDDER = -35;
RUDDER_ORDER = -35;
propellerRotation = 180/60;
X_0 = -0.034;
%tablica wektorów stanu statku w czasie
%% INICJACJA WEKTORA STANU STATKU I INNYCH MACIERZY
%pozycje pocz¹tkowe
X = zeros(6,1) %wektor stanu statku, czêœæ dotycz¹ca przyspieszeñ
A = zeros(6,6) %macierz mas i bezw³adnoœci <-- sta³e w czasie, zale¿ne od statku, wyznaczane raz, na pocz¹tku
B = zeros(6,1) %macierz si³ i momentów si³ <-- wyliczane na podstawie modelu matematycznego ruchu statku
wyniki = zeros(t/dt,13); %dane o trajektorii statku w³asnego w czasie
wynikiF = zeros(t/dt,40);
wynikiV = zeros(t/dt,20);
wynikiInne = zeros(t/dt,10);
wynikiBX = zeros(t/dt,12);
%% STATEK W£ASNY I JEGO TRAJEKTORIA = [X Y Z fi tau psi vx vy vz wx wy wz]
%Sta³e dotycz¹ce budowy statku
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
    aspect = 2* draught / length;
    Y_1 = 2*(3.14 * aspect * 0.5 + 1.4 * c_b * breadth / length);
    N_1 = aspect;
    N_2 = 1.5*(-0.54*aspect + aspect*aspect);
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

%% SYMULACJA
%pêtla wyliczeñ symulacji
%wyliczanie nowego wektora stanu statku poprzez numeryczne ca³kowanie
%przyspieszeñ i prêdkosci
for i = 1:dt:t+1
    %Sterowanie statku
    if RUDDER > RUDDER_ORDER + RUDDER_ROTATION
        RUDDER = RUDDER- RUDDER_ROTATION;
    elseif RUDDER > RUDDER_ORDER - RUDDER_ROTATION
           RUDDER = RUDDER_ORDER;
    else
        RUDDER =RUDDER+ RUDDER_ROTATION;
    end
    %Globalne wartoœci dla statku
    U = sqrt(v0(1)*v0(1)+v0(2)*v0(2));
    v_nd = v0(2) / U;
    r_nd = length * w0(3) / U;
    %Wyliczanie aktualnych si³ i momentów dzia³aj¹cych na statek
    for q=1
        %X
        for q=1
            Xhull_nd = X_vv*v_nd*v_nd + X_vr * v_nd * r_nd + X_rr * r_nd*r_nd + X_vvvv*r_nd*r_nd*r_nd*r_nd;
            
            Xhull = 0*Xhull_nd * 0.5*water_Density*length*length*U*U;
            Xres = X_0*0.5*water_Density*draught*length*v0(1)*v0(1);
            propellerJ = ((1-wakeFraction)*v0(1))/(propellerDiameter);
            propellerKT = kT0 + kT1 * propellerJ + kT2*propellerJ*propellerJ;
            Xprop = 0.7*water_Density * propellerRotation * propellerRotation * propellerDiameter* propellerDiameter* propellerDiameter* propellerDiameter * propellerKT;
            %rudder, ster
            cThrust = (2.546 * propellerKT) / (propellerJ * propellerJ);
            coefficient = (-0.0204 * cThrust +1.078);
            VRudder = v0(1)*(1-wakeFraction)*sqrt(1+cThrust);
            VYRudder = v0(2) - w0(3)*0.5*length;
            beta = 57.3*atan(-VYRudder/VRudder);
            alpha = RUDDER + beta; %w stopniach
            F_Rudder = 0.5 * water_Density * A_R * coefficient * VRudder *VRudder * sin(alpha/57.3);
            Xrud = -F_Rudder * sin(RUDDER/57.3);
            Xwind = 0;
            XSW = 0;
            Xgeneral = 2*m*v0(2)*w0(3);
            B(1) = Xgeneral + Xhull+Xres+Xrud+Xprop+Xwind+XSW;
        end
        %Y
        for q=1
            Yhull_nd = Y_v*v_nd + Y_r*r_nd+Y_vvv*v_nd*v_nd*v_nd+Y_vvr*v_nd*v_nd*r_nd+Y_vrr*v_nd*r_nd*r_nd+Y_rrr*r_nd*r_nd*r_nd;
            Yhull_nd = Y_1 * beta/57.3;
            Yhull = Yhull_nd * 0.5*water_Density*draught*length*U*U;
            Yprop = 0;
            Yrud = 1.5*F_Rudder * cos(RUDDER/57.3);
            Ywind = 0;
            YSW = 0;
            Ygeneral = -1.05*m*v0(1)*w0(3);
            B(2) =  Ygeneral + Yhull + Yprop + Yrud + Ywind + YSW;
        end
        %Z
        for q=1
            B(3) = 0;
        end
        %K
        for q=1
            Khull = -Yhull * 0.5 * draught;
            B(4) = 0;
        end
        %M
        for q=1
            B(5) = 0;
        end
        %N
        for q=1
            Nhull_nd = N_v*v_nd + N_r*r_nd+N_vvv*v_nd*v_nd*v_nd+N_vvr*v_nd*v_nd*r_nd+N_vrr*v_nd*r_nd*r_nd+N_rrr*r_nd*r_nd*r_nd;
            Nhull_nd = N_1 * beta/57.3 + N_2*r_nd;
            Nhull = Nhull_nd * 0.5*water_Density*length*draught*length*U*U;
            Nprop = 0;
            Nrud = -Yrud*0.5*length;
            Nwind = 0;
            NSW = 0;
            Ngeneral = 0;
            B(6) = Ngeneral + Nhull +Nprop +Nrud +Nwind +NSW;
        end
    end
    %Wyznaczanie nowego wektora stanu przyspieszeñ poprzez przemno¿enie macierzy
    for q=1
        X(1) = (B(1))/(1.05*m);
        X(2) = (B(2))/(2*m);
        X(6) = B(6) / (2*Izz);
    end
    %Numeryczne ca³kowanie wektora stanu w celu wyznaczenia prêdkoœci i pozycji
    for q=1
        if calculusMethod == "euler"
        %prêdkoœci
        v0(1) = v0(1) + X(1)*dt;
        v0(2) = v0(2) + X(2)*dt;
        v0(3) = v0(3);% + X(3)*dt;
        w0(1) = w0(1);% + X(4)*dt;
        w0(2) = w0(2);% + X(5)*dt;
        w0(3) = w0(3) + X(6)*dt;
        U = sqrt(v0(1)*v0(1)+v0(2)*v0(2));
        %pozycje i k¹ty
        p0(1) = p0(1) + v0(1)*sin(r0(3)/57.3)*dt+v0(2)*cos(r0(3)/57.3)*dt;
        p0(2) = p0(2) + v0(1)*cos(r0(3)/57.3)*dt+v0(2)*sin(r0(3)/57.3)*dt;
        p0(3) = p0(3) + v0(3)*dt;
        r0(1) = r0(1) + 57.3*w0(1)*dt;
        r0(2) = r0(2) + 57.3*w0(2)*dt;
        r0(3) = r0(3) + 57.3*w0(3)*dt;
        end
    end
    %Zapisanie wyników
    for q=1
        %wektor stanu
       wyniki(i,1) = p0(1);%x
       wyniki(i,2) = p0(2);%y
       wyniki(i,3) = U/8;
       wyniki(i,4) = v0(1);%vx
       wyniki(i,5) = v0(2);%vy
       wyniki(i,6) = v0(3);%vz
       wyniki(i,7) = r0(1);%przechy³
       wyniki(i,8) = r0(2);%przeg³êbienie
       wyniki(i,9) = r0(3);%kurs
       wyniki(i,10) = w0(1)*57.3;%prêdkoœæ k¹towa wokó³ OX
       wyniki(i,11) = w0(2)*57.3;%prêdkoœæ k¹towa wokó³ OY
       wyniki(i,12) = w0(3)*57.3;%prêdkoœæ k¹towa wokó³ OZ
       wyniki(i,13) = i; %czas
       %si³y i momenty si³
       wynikiF(i,1) = Xgeneral;
       wynikiF(i,2) = Xhull;
       wynikiF(i,3) = Xres;
       wynikiF(i,4) = Xprop;
       wynikiF(i,5) = Xrud;
       wynikiF(i,6) = Xwind;
       wynikiF(i,7) = XSW;
       wynikiF(i,8) = Xhull_nd;
       wynikiF(i,10) = Yhull;
       wynikiF(i,11) = Yrud;
       wynikiF(i,12) = Ygeneral;
       wynikiF(i,13) = Yhull_nd;
       
       wynikiF(i,21) = Nhull;
       wynikiF(i,22)= Nrud;
       wynikiF(i,23)= Ngeneral;
       
       wynikiV(i,1) = v_nd;
       wynikiV(i,2) = r_nd;
       wynikiV(i,3) = beta;
       wynikiBX(i,1) = B(1);
       wynikiBX(i,2) = B(2);
       wynikiBX(i,3) = B(3);
       wynikiBX(i,4) = B(4);
       wynikiBX(i,5) = B(5);
       wynikiBX(i,6) = B(6);
       wynikiBX(i,7) = X(1);
       wynikiBX(i,8) = X(2);
       wynikiBX(i,9) = X(3);
       wynikiBX(i,10) = X(4);
       wynikiBX(i,11) = X(5);
       wynikiBX(i,12) = X(6);
       
%        cThrust = (2.546 * propellerKT) / (propellerJ * propellerJ);
%             coefficient = 1.4 *(-0.0204 * cThrust +1.078);
%             VRudder = v0(1)*(1-wakeFraction)*sqrt(1+cThrust);
%             VYRudder = v0(2) - w0(3)*0.5*length;
%             alpha = RUDDER + 57.3*atan(-VYRudder/VRudder); %w stopniach
%             F_Rudder
       wynikiInne(i,1) = cThrust;
       wynikiInne(i,2) = coefficient;
       wynikiInne(i,3) = VRudder;
       wynikiInne(i,4) = VYRudder;
       wynikiInne(i,5) = alpha;
       wynikiInne(i,6) = F_Rudder;
       
    end
end
%% PREZENTACJA WYNIKÓW
close all
%trajektoria
x = wyniki(:,1);
y = wyniki(:,2);
figure;plot(x,y,'LineWidth',2)
axis equal
% %kurs
% figure;
% hold on;
% plot(wyniki(:,13),wyniki(:,9));
% legend('Kurs');
%prêdkoœæ k¹towa
% figure;
% hold on;
% plot(wyniki(:,13),wyniki(:,12),'LineWidth',2);
% legend('rot_Z');
%spradek prêdkoœci na cyrkulacji
figure;
hold on;
plot(wyniki(:,13),wyniki(:,3),'LineWidth',2)
legend('U/U_0');
hold off;
% figure;
% hold on;
% plot(wyniki(:,13),wyniki(:,4),'LineWidth',2)
% plot(wyniki(:,13),wyniki(:,5),'LineWidth',2)
% plot(wyniki(:,13),wynikiInne(:,4),'LineWidth',2)
% legend('Vx','Vy','Vy_R');
% hold off;
%przyspieszenia
% figure;
% hold on;
% plot(wyniki(:,13),wynikiBX(:,7),'LineWidth',2)
% plot(wyniki(:,13),wynikiBX(:,8),'LineWidth',2)
% plot(wyniki(:,13),wynikiBX(:,12),'LineWidth',2)
% legend('a_x','a_y','E_z');
% hold off;
% %sumy si³ i momentów
% 
% figure;
% hold on;
% plot(wyniki(:,13),wynikiBX(:,7))
% plot(wyniki(:,13),wynikiBX(:,8))
% plot(wyniki(:,13),wynikiBX(:,12))
% legend('X_T_O_T_A_L','Y_T_O_T_A_L','N_T_O_T_A_L');
% hold off;
% %k¹t dryfu
% figure;
% hold on;
% plot(wyniki(:,13),wynikiV(:,3))
% legend('k¹t dryfu');
% hold off;

% %ster
% figure;
% hold on;
% plot(wyniki(:,13),wynikiInne(:,1))
% legend('cThrust');
% hold off;
% 
% figure;
% hold on;
% plot(wyniki(:,13),wynikiInne(:,2))
% legend('coefficient');
% hold off;
% 
% figure;
% hold on;
% plot(wyniki(:,13),wynikiInne(:,3))
% legend('VRudder');
% hold off;
% 
% figure;
% hold on;
% plot(wyniki(:,13),wynikiInne(:,4))
% legend('VYRudder');
% hold off;
% 
% figure;
% hold on;
% plot(wyniki(:,13),wynikiInne(:,5))
% legend('alpha');
% hold off;
% 
% figure;
% hold on;
% plot(wyniki(:,13),wynikiInne(:,6))
% legend('F_Rudder');
% hold off;
%si³y X
figure;
hold on;
plot(wyniki(:,13),wynikiF(:,2),'LineWidth',2)
plot(wyniki(:,13),wynikiF(:,3),'LineWidth',2)
plot(wyniki(:,13),wynikiF(:,4),'LineWidth',2)
plot(wyniki(:,13),wynikiF(:,5),'LineWidth',2)
plot(wyniki(:,13),wynikiF(:,1),'LineWidth',2)
plot(wyniki(:,13),wynikiBX(:,1),'LineWidth',2)
lgd = legend('Xhull','Xres','Xprop','Xrudder', 'Xgeneral','Xtotal');
lgd.FontSize = 14;
hold off;
%si³y Y
figure;
hold on;
plot(wyniki(:,13),wynikiF(:,10),'LineWidth',2)
plot(wyniki(:,13),wynikiF(:,11),'LineWidth',2)
plot(wyniki(:,13),wynikiF(:,12),'LineWidth',2)
plot(wyniki(:,13),wynikiBX(:,2),'LineWidth',2)
legend('Yhull','Yrudder', 'Ygeneral','Ytotal');
hold off;
% %momenty N
% figure;
% hold on;
% plot(wyniki(:,13),wynikiF(:,21),'LineWidth',2)
% plot(wyniki(:,13),wynikiF(:,22),'LineWidth',2)
% plot(wyniki(:,13),wynikiF(:,23),'LineWidth',2)
% plot(wyniki(:,13),wynikiBX(:,6),'LineWidth',2)
% legend('Nhull','Nrudder','Ngeneral','Ntotal');
% hold off;
% %prêdkoœci non dimentionalized
% figure;
% hold on;
% plot(wyniki(:,13),wynikiV(:,1))
% plot(wyniki(:,13),wynikiV(:,2))
% legend('Vx_n_d','rot_n_d');
% hold off;
% %si³y non dimentionalized
% figure;
% hold on;
% plot(wyniki(:,13),wynikiF(:,8))
% plot(wyniki(:,13),wynikiF(:,20))
% legend('Xhull_n_d','Yhull_n_d');
% hold off;