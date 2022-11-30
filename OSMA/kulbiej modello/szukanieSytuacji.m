%% Wczytywanie danych
clc;clear all; close all;
cpa0 = 50;
xMax = 5000;
yMax = 5000;
xStep = 100;
yStep = 100;
gridX = xMax / xStep;
gridY = yMax / yStep;
headingStep = 1;
velocityStep = 0.1;
[a,b]=navigationalSituation(38);
situations = zeros(10);

for x=-gridX:gridX
    for y=-gridY:gridY
        % nawigator
        b = shipDefault3('nawigator','b',2);
        for v=6:12
            s = 5.9*v/10;
            for h=0:360
                b=b.updateShip([x*xStep y*yStep 0 0 0 h/57.3 s 0 0 0 0 0]);
                % check CPA
                if cpaOutline(a,b,1) < cpa0
                    % dopisujemy sytuacje do listy
                    situations = [situations; [1 x*xStep y*yStep h/57.3 s 0 0 0 0 0]];
                end
                h = h + headingStep;
            end
            v = v + velocityStep;
        end
        % kcs
        b = shipDefault3('kcs','b',2);
        for v=6:12
            s = 12.3*v/10;
            for h=0:360
                b=b.updateShip([x*xStep y*yStep 0 0 0 h/57.3 s 0 0 0 0 0]);
                % check CPA
                if cpaOutline(a,b,1) < cpa0
                    % dopisujemy sytuacje do listy
                    situations = [situations; [2 x*xStep y*yStep h/57.3 s 0 0 0 0 0]];
                end
                h = h + headingStep;
            end
            v = v + velocityStep;
        end
        % kvlcc2
        b = shipDefault3('kvlcc2','b',2);
        for v=6:12
            s = 8.1*v/10;
            for h=0:360
                b=b.updateShip([x*xStep y*yStep 0 0 0 h/57.3 s 0 0 0 0 0]);
                % check CPA
                if cpaOutline(a,b,1) < cpa0
                    % dopisujemy sytuacje do listy
                    situations = [situations; [3 x*xStep y*yStep h/57.3 s 0 0 0 0 0]];
                end
            end
            v = v + velocityStep;
        end
        y = y + xStep;
    end
    x = x + yStep;
end