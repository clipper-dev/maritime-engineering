%WCZYTANIE DANYCH Z PLIKU
file = matfile('fsg.mat');
fsg = file.fsg;
%INICJALIZACJA STATKÓW
v = 8;
shipLength = 142;
breadth = 25;
points = length(fsg);
mass = 5600000;
e =         0.00;
steps = 6;
energyReleased = zeros(points,steps-1);
%OBLICZANIE ENERGII
for p=1:points
    xC = fsg(p,2);
    yC = fsg(p,3);
    alpha = fsg(p,4);
    for i=1:steps-1
        beta = (180/steps)*i;
        xB = -0.5*shipLength*cos(beta/57.3) + xC;
        yB =  0.5*shipLength*sin(beta/57.3) + yC;
        aqua = ship(shipLength,mass,v,0,0.05,0.85,0.21,0,0);
        blue = ship(shipLength,mass,v,0,0.05,0.85,0.21,xB,yB);
        energyReleased(p,i) = energy(aqua,blue,xC,yC,alpha,beta,e,0.6);
    end
end

