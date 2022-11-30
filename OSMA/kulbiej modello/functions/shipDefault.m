function c = shipDefault(shipName, initialSpeed, heading, time, rudder)
steeringVector = [100 rudder];%maszyna i ster
xx2=matfile('wynikNowy.mat');
set=xx2.betterSet;
shipVector.isOwnSet = false;
shipVector.ownSet = set;%[0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
calculusVector = [time 1 1];
initialStateVector1 = [0 0 0 0 0 heading/57.3 initialSpeed 0 0 0 0 0];
environmentVector.isWeather = false;
environmentVector.weather = weather(0,0,0,0,0);
environmentVector.isShallow = false;
environmentVector.depth = 100;
c = shipLoad3(shipName, shipVector, steeringVector, calculusVector, initialStateVector1, environmentVector,'k','rect2');
end