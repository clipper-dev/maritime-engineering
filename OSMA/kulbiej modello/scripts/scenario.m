%% cpa test
duration = 250;
isWeather = false;
pogoda = weather(225,20,90,0.8,0.5);
armada(1) = shipLoad2("nawigator",100,0,1,1000,1000,225,6,0,0,0,0,0,pogoda);
armada(2) = shipLoad2("nawigator",100,0,1,0,0,0,6,0,0,0,0,0,pogoda);

SData = generujTrajektorieMulti(armada, duration, isWeather, pogoda);
rysujMulti(armada,SData,1,1,100);
