function c = shipDefault3(shipName, colour, outline)
steeringVector = [100 0];%maszyna i ster
xx2=matfile('wynikNowy.mat');
set=xx2.betterSet;
shipVector.isOwnSet = false;
shipVector.ownSet = set;%[0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
calculusVector = [100 1 1];
initialStateVector1 = [0 0 0 0 0 0/57.3 666 0 0 0 0 0];
environmentVector.isWeather = false;
environmentVector.weather = weather(0,0,0,0,0);
environmentVector.isShallow = false;
environmentVector.depth = 100;
c = shipLoad3(shipName, shipVector, steeringVector, calculusVector, initialStateVector1, environmentVector,colour,outline);
end