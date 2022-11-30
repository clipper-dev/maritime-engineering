function [collision,finish,aX, aY, bX, bY] = simulateLmm(shipA, shipB, rudderA, rudderB, timeStep, cpaRequired, outlines)
a=shipA;b=shipB;
a=a.setRudderOrder(rudderA/57.3);
b=b.setRudderOrder(rudderB/57.3);
collision = false;
finish = false;

while ~collision && ~finish
    % sprawdzanie statusu LMM:
    % 0 - w trakcie: cpa_aktualne < cpa_wymagane ORAZ odległość_aktualna >
    % cpa_wymagane
    % 1 - minięcie: cpa_aktualne > cpa_wymagane ORAZ odległość_aktualna >
    % cpa_wymagane
    % 2 - kolizja: cpa_aktualne < cpa_wymagane ORAZ odległość_aktualna <
    % cpa_wymagane
    if outlines
        [distanceO,results]=distanceOutline(a.x,a.y,a.heading,b.x,b.y,b.heading,a,b);
        cpaO=cpaOutline(a,b,timeStep);
    else
        distanceO = distance(a,b);
        cpaO=cpa(a,b);
    end
    if distanceO < cpaRequired
        %kolizja
        collision = true;
        break;
    else
        if cpaO > cpaRequired
            %koniec
            finish = true;
            break;
        elseif cpaO < cpaRequired
            %dalej
            
        end
    end
    %symulowanie kolejnego kroku
    a=a.calculateMovement(timeStep,1);
    b=b.calculateMovement(timeStep,1);
    
end
aX=shipA.x;
aY=shipA.y;
bX=shipB.x;
bY=shipB.y;
end

