function SData = generujTrajektorieMulti(ships, duration, isWeather, weather)
% statek w³asny to statek z indeksem 1 z wejœciowej tablicy ships
    amount = length(ships);
    SData = zeros(duration, amount*10);
    for time=1:duration
        %% iterowanie po dynamice ka¿dego statku
        for i=1:amount
            ships(i) = ships(i).calculateMovement(1,"euler");
            SData(time,10*(i-1)+1) = ships(i).speed;
            SData(time,10*(i-1)+2) = ships(i).x;
            SData(time,10*(i-1)+3) = ships(i).y;
            SData(time,10*(i-1)+4) = ships(i).heading*57.3;
            SData(time,10*(i-1)+5) = ships(i).driftAngle*57.3;
        end
        %% wyznaczanie parametrów spotkania i zbli¿enia
        for i=2:amount
            SData(time,10*(i-1)+6) = cpa(ships(1),ships(i));
            SData(time,10*(i-1)+7) = tcpa(ships(1),ships(i));
        end
    end
end