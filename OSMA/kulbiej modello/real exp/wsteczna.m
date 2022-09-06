clc; close all; clear
%% wczytanie pliku
rudder=35;
xx=matfile(""+rudder+'.mat');
daneA=xx.dane;
xx2=matfile('ym.mat');
xx3=matfile('wynikNowy.mat');
set=xx3.betterSet;
%% wykres trajektorii z badania
shipVector.isOwnSet = true;
shipVector.ownSet = set;%[-0.061 0.09 -0.0008 0.41 -0.31 0.062 -0.577 -0.051 -0.719 -0.75 -0.105 -0.0457 -0.253 -0.0302 -0.6 -0.274];
steeringVector = [100 rudder];%maszyna i ster
calculusVector = [150 1 1];
initialStateVector1 = [0 0 0 0 0 0 5.81 0 0 0 0 0];
environmentVector.isWeather = false;
environmentVector.weather = weather(0,0,0,0,0);
environmentVector.isShallow = false;
environmentVector.depth = 100;
s = shipLoad3("nawigator", shipVector, steeringVector, calculusVector, initialStateVector1, environmentVector,'k');
s = s.updateSet(set);
%% wygenerowanie parametrów metod¹ in¿ynierii wstecznej

size=size(daneA);
time=size(1);
daneB = zeros(time, 20);
%predkosci
for t=1:time
    daneB(t,1)=daneA(t,8);
    daneB(t,2)=daneA(t,9);
    if t>1
        daneB(t,3)=(daneA(t,5)-daneA(t-1,5))/57.3;
        if daneB(t,3)<-4.14
           daneB(t,3)=daneB(t,3)+6.28; 
        end
    else
        daneB(t,3)=(daneA(t+1,5)-daneA(t,5))/57.3/57.3;
        if daneB(t,3)<-3.14
           daneB(t,3)=daneB(t,3)+6.28; 
        end
    end
end

%wyg³adzenie prêdkoœci
for t=1:size(1)
    if t==1
        daneB(t,4)=0.5*(daneB(t,1)+2*daneB(t+1,1)-daneB(t+2,1));
        daneB(t,5)=0.5*(daneB(t,2)+2*daneB(t+1,2)-daneB(t+2,2));
        daneB(t,6)=0.5*(daneB(t,3)+2*daneB(t+1,3)-daneB(t+2,3));
    elseif t==2
        daneB(t,4)=0.5*(daneB(t-1,1)+daneB(t,1)+daneB(t+1,1)-daneB(t+2,1));
        daneB(t,5)=0.5*(daneB(t-1,2)+daneB(t,2)+daneB(t+1,2)-daneB(t+2,2));
        daneB(t,6)=0.5*(daneB(t-1,3)+daneB(t,3)+daneB(t+1,3)-daneB(t+2,3));
    elseif t==size(1)-1
        daneB(t,4)=0.5*(daneB(t+1,1)+daneB(t,1)+daneB(t-1,1)-daneB(t-2,1));
        daneB(t,5)=0.5*(daneB(t+1,2)+daneB(t,2)+daneB(t-1,2)-daneB(t-2,2));
        daneB(t,6)=0.5*(daneB(t+1,3)+daneB(t,3)+daneB(t-1,3)-daneB(t-2,3));
    elseif t==size(1)
        daneB(t,4)=0.5*(daneB(t,1)+2*daneB(t-1,1)-daneB(t-2,1));
        daneB(t,5)=0.5*(daneB(t,2)+2*daneB(t-1,2)-daneB(t-2,2));
        daneB(t,6)=0.5*(daneB(t,3)+2*daneB(t-1,3)-daneB(t-2,3));
    else
        %normalne
        daneB(t,4)=0.2*(daneB(t-2,1)+daneB(t-1,1)+daneB(t,1)+daneB(t+1,1)+daneB(t+2,1));
        daneB(t,5)=0.2*(daneB(t-2,2)+daneB(t-1,2)+daneB(t,2)+daneB(t+1,2)+daneB(t+2,2));
        daneB(t,6)=0.2*(daneB(t-2,3)+daneB(t-1,3)+daneB(t,3)+daneB(t+1,3)+daneB(t+2,3));
    end
end
f1=figure;grid on;hold on;
plot(daneA(:,1),daneB(:,1));
plot(daneA(:,1),daneB(:,4));
plot(daneA(:,1),daneB(:,2));
plot(daneA(:,1),daneB(:,5));
xlabel("time [s]");ylabel("velocity [m/s]");
legend('u','u_s_m_o_o_t_h_e_d','v','v_s_m_o_o_t_h_e_d');hold off
%wyg³adzenie pozycji1
for t=1:size(1)
    if t>1
        daneB(t,7)=daneB(t-1,7)+0.5*(daneB(t,1)*cos(daneA(t,5)/57.3)-daneB(t,2)*sin(daneA(t,5)/57.3)+...
            daneB(t-1,1)*cos(daneA(t-1,5)/57.3)-daneB(t-1,2)*sin(daneA(t-1,5)/57.3));
        daneB(t,8)=daneB(t-1,8)+0.5*(daneB(t,1)*sin(daneA(t,5)/57.3)+daneB(t,2)*cos(daneA(t,5)/57.3)+...
            daneB(t-1,1)*sin(daneA(t-1,5)/57.3)+daneB(t-1,2)*cos(daneA(t-1,5)/57.3));
    else
        daneB(t,7)=0;
        daneB(t,8)=0;
    end
end
%wyg³adzenie pozycji2
for t=1:size(1)
    if t>1
        daneB(t,9)=daneB(t-1,9)+0.5*(daneB(t-1,4)*cos(daneA(t-1,5)/57.3)-daneB(t-1,5)*sin(daneA(t-1,5)/57.3)+...
            daneB(t,4)*cos(daneA(t,5)/57.3)-daneB(t,5)*sin(daneA(t,5)/57.3));
        daneB(t,10)=daneB(t-1,10)+0.5*(daneB(t-1,4)*sin(daneA(t-1,5)/57.3)+daneB(t-1,5)*cos(daneA(t-1,5)/57.3)+...
            daneB(t,4)*sin(daneA(t,5)/57.3)+daneB(t,5)*cos(daneA(t,5)/57.3));
    else
        daneB(t,9)=0;
        daneB(t,10)=0;
    end
end

%przyspieszenia
for t=1:size(1)
    if t<size(1)
       daneB(t,11)= daneB(t+1,4)-daneB(t,4);
       daneB(t,12)= daneB(t+1,5)-daneB(t,5);
       daneB(t,13)= daneB(t+1,6)-daneB(t,6);
    end
end
%sumy si³
for t=1:size(1)
    daneB(t,14)= daneB(t,11)*s.m*(s.m11+1)-s.m*(1+s.m22)*daneB(t,6)*daneB(t,5);
    daneB(t,15)= daneB(t,12)*s.m*(s.m22+1)+s.m*(1+s.m11)*daneB(t,6)*daneB(t,4);
    daneB(t,16)= daneB(t,13)*s.Izz*(1+s.m66);
end
%si³y od kad³uba
for t=1:size(1)
    s.vx = daneB(t,4);
    s.vy = daneB(t,5);
    s.wz = daneB(t,6);
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
            Xhull=0.5*s.waterDensity*s.length*s.draught*s.speed*s.speed*(-s.R_0);
            %16
            s.Xrudder=-(1-s.tR)*FN*sin(s.rudderAngle);
            %17
            s.Xpropeller=(1-s.thrustDeduction)*s.waterDensity*s.propellerKT*s.propellerRotation^2*s.propellerDiameter^4;
            %19
            s.Yrudder=-(1+s.aH)*FN*cos(s.rudderAngle);            
            %21
            s.Nrudder=-(s.xR+s.aH*s.xH)*s.length*FN*cos(s.rudderAngle);
            
       daneB(t,17)= daneB(t,14)-s.Xrudder-Xhull-s.Xpropeller;
       daneB(t,18)= daneB(t,15)-s.Yrudder;
       daneB(t,19)= -(daneB(t,16)-s.Nrudder);
       
       daneB(t,20)=0.5*s.waterDensity*s.length*s.draught*s.speed*s.speed*...
                (s.X_vv*s.vynd*s.vynd + ...
                s.X_vr*s.vynd*s.wznd + ...
                s.X_rr*s.wznd*s.wznd + ...
                s.X_vvvv*s.vynd*s.vynd*s.vynd*s.vynd);
       daneB(t,21)=0.5*s.waterDensity*s.length*s.draught*s.speed*s.speed*(...
                s.Y_v*s.vynd + ...
                s.Y_r*s.wznd + ...
                s.Y_vvv*s.vynd*s.vynd*s.vynd + ...
                s.Y_vvr*s.vynd*s.vynd*s.wznd + ...
                s.Y_vrr*s.vynd*s.wznd*s.wznd + ...
                s.Y_rrr*s.wznd*s.wznd*s.wznd);
       daneB(t,22)=0.5*s.waterDensity*s.length*s.length*s.draught*s.speed*s.speed*(...
                s.N_v*s.vynd + ...
                s.N_r*s.wznd + ...
                s.N_vvv*s.vynd*s.vynd*s.vynd + ...
                s.N_vvr*s.vynd*s.vynd*s.wznd + ...
                s.N_vrr*s.vynd*s.wznd*s.wznd + ...
                s.N_rrr*s.wznd*s.wznd*s.wznd);
end
f3=figure;grid on;hold on;
plot(daneA(:,1),daneB(:,17));
plot(daneA(:,1),daneB(:,20));
plot(daneA(:,1),daneB(:,18));
plot(daneA(:,1),daneB(:,21));
xlabel("time [s]");ylabel("force [m/s]");
legend('X_h_u_l_l','X_h_u_l_l_0','Y_h_u_l_l','Y_h_u_l_l_0');hold off

f3=figure;grid on;hold on;
plot(daneA(:,1),daneB(:,19));
plot(daneA(:,1),daneB(:,22));
xlabel("time [s]");ylabel("moment [m^2/s]");
legend('N_h_u_l_l','N_h_u_l_l_0');hold off

%% porównanie wykresów


xx2=matfile('ym.mat');
setYM=xx2.finalSet;
shipVector.ownSet = setYM;%[-0.061 0.09 -0.0008 0.41 -0.31 0.062 -0.577 -0.051 -0.719 -0.75 -0.105 -0.0457 -0.253 -0.0302 -0.6 -0.274];
v1 = shipLoad3("nawigator", shipVector, steeringVector, calculusVector, initialStateVector1, environmentVector,'k');
%analizaBezwymiarowa(vessel, shipVector, steeringVector, calculusVector, initialStateVector, environmentVector);
daneC= generujTrajektorie3(v1, shipVector, steeringVector, calculusVector, initialStateVector1, environmentVector, true);

set=xx3.betterSet;
shipVector.isOwnSet = true;
shipVector.ownSet = set;%[-0.061 0.09 -0.0008 0.41 -0.31 0.062 -0.577 -0.051 -0.719 -0.75 -0.105 -0.0457 -0.253 -0.0302 -0.6 -0.274];
steeringVector = [100 rudder];%maszyna i ster
calculusVector = [300 1 1];
initialStateVector1 = [0 0 0 0 0 0 5.81 0 0 0 0 0];
environmentVector.isWeather = false;
environmentVector.weather = weather(0,0,0,0,0);
environmentVector.isShallow = false;
environmentVector.depth = 100;
shipVector.ownSet = set;%[-0.061 0.09 -0.0008 0.41 -0.31 0.062 -0.577 -0.051 -0.719 -0.75 -0.105 -0.0457 -0.253 -0.0302 -0.6 -0.274];
v2 = shipLoad3("nawigator", shipVector, steeringVector, calculusVector, initialStateVector1, environmentVector,'k');
%analizaBezwymiarowa(vessel, shipVector, steeringVector, calculusVector, initialStateVector, environmentVector);
daneD= generujTrajektorie3(v2, shipVector, steeringVector, calculusVector, initialStateVector1, environmentVector, true);

delta=25;
f2=figure;axis equal;grid on;hold on;
if rudder == 35
   plot((daneB(:,10))/55,(daneB(:,9)+delta)/55,'--');
else 
    plot((daneB(:,9))/55,(-daneB(:,10))/55,'--');
end
plot((daneC(:,3))/55,daneC(:,2)/55,'k:');
plot((daneD(:,3))/55,daneD(:,2)/55);  
xlabel("Y/L_B_P [-]");ylabel("X/L_B_P [-]");
legend('trajectory EXP', 'trajectory Y&M','trajectory OWN');hold off

%%
indices35=[1.9 -0.43 0.048 2.7 1.3 2.1 2.2 1.2];
indices25=[2.4 -0.60 0.047 3.1 1.6 2.3 2.7 1.8];
indices15=[3.2 -0.70 0.035 3.9 1.8 2.8 3.7 3.3];

set=xx3.betterSet;
shipVector.isOwnSet = true;
shipVector.ownSet = set;%[0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
steeringVector = [100 35];%maszyna i ster
%CZAS%
czas=150;
calculusVector = [czas 1 1];
initialStateVector1 = [0 0 0 0 0 0 5.81 0 0 0 0 0];
environmentVector.isWeather = false;
environmentVector.weather = weather(0,0,0,0,0);
environmentVector.isShallow = false;
environmentVector.depth = 100;
v1 = shipLoad3("nawigator", shipVector, steeringVector, calculusVector, initialStateVector1, environmentVector,'k');
%analizaBezwymiarowa(vessel, shipVector, steeringVector, calculusVector, initialStateVector, environmentVector);
data= generujTrajektorie3(v1, shipVector, steeringVector, calculusVector, initialStateVector1, environmentVector, true);
rysujWykresy(true,false,data,v1,0,1,2,90,1,0,0,0,0,0,0);


newIndices35=generowanieWskaznikow(set,v1,35)
newIndices25=generowanieWskaznikow(set,v1,25)
newIndices15=generowanieWskaznikow(set,v1,15)
error=porownanieBledu2(newIndices35,indices35,true)+...
    porownanieBledu2(newIndices25,indices25,true)+...
    porownanieBledu2(newIndices15,indices15,true)