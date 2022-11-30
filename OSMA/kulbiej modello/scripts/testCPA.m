close all; clear; clc
xx3=matfile('n7.mat');
betterSet=xx3.betterSet;
shipVector.isOwnSet = true;
shipVector.ownSet = betterSet;
steeringVector = [100 35];%maszyna i ster
calculusVector = [1 1 1];
initialStateVector1 = [0 0 0 0 0 0 5.81 0 0 0 0 0];
initialStateVector2 = [0 0 0 0 0 0 5.81 0 0 0 0 0];
environmentVector.isWeather = false;
environmentVector.weather = weather(0,0,0,0,0);
environmentVector.isShallow = false;
environmentVector.depth = 100;
a = shipLoad3("nawigator", shipVector, steeringVector, calculusVector, initialStateVector1, environmentVector,'k','rect2');
b = shipLoad3("nawigator", shipVector, steeringVector, calculusVector, initialStateVector2, environmentVector,'k','rect2');

distance = 1000;
bearing = 0;
course = 0;
precision=10;
cpaData = zeros(360/precision,360/precision);
cpaDataOutline = zeros(360/precision,360/precision);
cpaDiff = zeros(360/precision,360/precision);
for i=1:360/precision
    bearing=i*precision;
    for j=1:360/precision
       course=j*precision; 
       b=b.updateShip([distance*sin(bearing/57.3) distance*cos(bearing/57.3) 0 0 0 course/57.3 5.81*0.8 0 0 0 0 0]);
       cpaData(i,j)=cpaIteration(a,b,1);
       cpaDataOutline(i,j)=cpaOutline(a,b,1);
       cpaDiff(i,j)=cpaData(i,j)-cpaDataOutline(i,j);
    end
end
%surf(cpaData)
figure
surf(cpaData,'EdgeColor','None','facecolor', 'interp');
view(2);   
title('V_O = 11.3kt, V_E = 9.04kt');
xlabel(['Wzglêdny kurs statku przeciwnego [' char(176) ']']);
ylabel(['Wzglêdny pocz¹tkowy namiar [' char(176) ']']);
axis equal tight 
cb=colorbar;
ylabel(cb,'D_C_P_A [m]');

figure
surf(cpaDataOutline,'EdgeColor','None','facecolor', 'interp');
view(2);   
title('V_O = 11.3kt, V_E = 9.04kt');
xlabel(['Wzglêdny kurs statku przeciwnego [' char(176) ']']);
ylabel(['Wzglêdny pocz¹tkowy namiar [' char(176) ']']);
axis equal tight 
cb=colorbar;
ylabel(cb,'D_C_P_A outline[m]');

figure
surf(cpaDiff,'EdgeColor','None','facecolor', 'interp');
view(2);   
title('V_O = 11.3kt, V_E = 9.04kt');
xlabel(['Wzglêdny kurs statku przeciwnego [' char(176) ']']);
ylabel(['Wzglêdny pocz¹tkowy namiar [' char(176) ']']);
axis equal tight 
cb=colorbar;
ylabel(cb,'D_C_P_A ró¿nica[m]');
disp("Fini");