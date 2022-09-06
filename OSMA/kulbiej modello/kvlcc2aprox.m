%% INIT
close all;clear;
duration=2000;
timeFactor=0.55;
timeScale=1/timeFactor;
dane=zeros(20,duration*timeFactor);
shipVector.isOwnSet = false;
lock1 = true;
shipVector.OwnSet = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
steeringVector = [100 35];%maszyna i ster
%CZAS%
calculusVector = [500 1 0];
initialStateVector = [0 0 0 0 0 0 7.973 0 0 0 0 0];
environmentVector.isWeather = false;
environmentVector.weather = weather(0,0,0,0,0);
environmentVector.isShallow = false;
environmentVector.depth = 100;
v = shipLoad3("nowy_kvlcc2", shipVector, steeringVector, calculusVector, initialStateVector, environmentVector);
U0=initialStateVector(7);
%% SYMULACJA
for t=1:duration*timeFactor
       %% czas
    dane(1,t)=t;
    %% aproksymowane rND, beta, Und
    %rND
    if t<458
        dane(9,t)=((9.764e-05)*t^3+0.144*t^2+16.61*t+129.9)/(t^2-113*t+8651);
    else 
        dane(9,t)=0.284;
    end
    %beta
    if t<1021
        dane(10,t)=(20.7*t-0.07042)/(t+20.12);
    else
        dane(10,t)=20.2998977831566;
    end
    %UND
    if t<478
        dane(11,t)=(0.4933*t^2-204.4*t+9.843e+04)/(t^2+59.78*t+9.853e+04);
    else
        dane(11,t)=0.319;
    end
    %% prêdkoœæ U,u,v,w
    dane(5,t)=U0*(dane(11,t));%U
    dane(6,t)=(dane(5,t))*cos(dane(10,t)/57.3);%u, vx
    dane(7,t)=(dane(5,t))*sin(dane(10,t)/57.3);%v, vy
    dane(8,t)=(dane(9,t))*U0/v.length;%r
    
    %% pozycja x,y,kurs
    if t>1
        dane(4,t)=dane(4,t-1)+timeScale*dane(8,t);  %kurs
        dane(2,t)=dane(2,t-1)+timeScale*dane(5,t)*cos(dane(4,t)+dane(10,t)/57.3);
        dane(3,t)=dane(3,t-1)+timeScale*dane(5,t)*sin(dane(4,t)+dane(10,t)/57.3); 
        
        
        dane(14,t)=dane(14,t-1)+timeScale*dane(8,t-1);  %kurs
        dane(12,t)=dane(12,t-1)+timeScale*dane(5,t-1)*cos(dane(14,t-1)+dane(10,t-1)/57.3);
        dane(13,t)=dane(13,t-1)+timeScale*dane(5,t-1)*sin(dane(14,t-1)+dane(10,t-1)/57.3); 
        
        
        %parametry
        if dane(2,t)>dane(2,t-1)
            advance = dane(2,t)/v.length;
        end
        if dane(3,t)>dane(3,t-1)
            tacticalDiameter = dane(3,t)/v.length;
        end
        if 57.3*dane(4,t)+dane(10,t)>90 && lock1==true
            transfer = dane(3,t)/v.length;
            lock1 = false;
        end
    end 
    
end
figure
hold on
plot(dane(1,:),dane(5,:));
plot(dane(1,:),dane(6,:));
plot(dane(1,:),dane(7,:));


figure
hold on
plot(dane(3,:)/v.length,dane(2,:)/v.length);
plot(dane(13,:)/v.length,dane(12,:)/v.length);

axis equal
legend('trajektoria f(t)','trajektoria f(t-1)');
xlabel('Y/L [-]');
ylabel('X/L [-]');


diameter=2*dane(5,t)/(dane(8,t)*v.length)
advance
transfer
tacticalDiameter