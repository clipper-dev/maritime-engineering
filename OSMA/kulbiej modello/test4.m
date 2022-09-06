%%


shipVector.isOwnSet = true;
shipVector.ownSet = set;%[0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];

%CZAS%

v1 = shipLoad3("nawigator", shipVector, steeringVector, calculusVector, initialStateVector1, environmentVector,'k');
%analizaBezwymiarowa(vessel, shipVector, steeringVector, calculusVector, initialStateVector, environmentVector);
daneC = generujTrajektorie3(v1, shipVector, steeringVector, calculusVector, initialStateVector1, environmentVector, true);
