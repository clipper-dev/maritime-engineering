function tabela = tabelaManewr(shipName,duration,initialSpeed,hydroSet,length, predkoscWaga, odlegloscWaga)
tabela = zeros(7,7);
for i=1:7
    rudder = 35 - (i-1)*5;
    dataModel = generujTrajektorie(shipName, 100,rudder, duration, initialSpeed, true, hydroSet, 0, 0);
    tabela(i,:)= ocenaTrajektoriiND(rudder,dataModel,duration,length,initialSpeed,predkoscWaga, odlegloscWaga);
end
end