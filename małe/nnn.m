close all;clear;
duration=1500;
dane=zeros(20,duration);
vessel = shipLoad3("nowy_kvlcc2L3", shipVector, steeringVector, calculusVector, initialStateVector, environmentVector);
for t=1:duration
    %% czas
    dane(1,t)=t;
    %% pozycja x,y,kurs
    
    %% prêdkoœæ U,u,v,w
    
    
    
    %% aproksymowane wND, beta, Und
    %wND
    if t<600
        dane(9,t)=((9.764e-05)*t^3+0.144*t^2+16.61*t+129.9)/(t^2-113*t+8651);
    else 
        dane(9,t)=0.275970962370077;
    end
    %beta
    if t<1021
        dane(10,t)=(20.7*t-0.07042)/(t+20.12);
    else
        dane(10,t)=20.2998977831566;
    end
    if t<780
        dane(11,t)=(0.3966*t^2-52.65*t+3.12e+04)/(t^2+2.067*t+3.121e+04);
    else
        dane(11,t)=0.360911425626428;
    end                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
end