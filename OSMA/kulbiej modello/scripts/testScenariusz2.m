clc;clear all;close all
%% SCENARIUSZ
[a,b]=navigationalSituation(19);
exit=false;
immediately=false;
enemyRudder=-35;
waitSeconds=0;
cpaWanted = 0.5*(a.breadth+b.breadth);
rudderOwn=35;
timeStep=1;
iMax=150/timeStep;
%% KROK 1 - wyznaczenie trajektorii do najwiekszego zblizenia
% zmienne pomocnicze
i=0;
lock=true;
elapsedWait=0;
prevDistance=distanceOutline(a.x,a.y,a.heading,b.x,b.y,b.heading,a,b);
if immediately
    a=a.setRudderOrder(rudderOwn/57.3);
    b=b.setRudderOrder(enemyRudder/57.3);
end
% petla wyliczen
while true
    i=i+1;
    if lock && elapsedWait > waitSeconds
        lock=false;
        a=a.setRudderOrder(rudderOwn/57.3);
        b=b.setRudderOrder(enemyRudder/57.3);
        a.x
        a.y
        distance(a,b)
        distanceOutline(a.x,a.y,a.heading,b.x,b.y,b.heading,a,b)
    else
        elapsedWait=elapsedWait+timeStep;
    end
    if distanceOutline(a.x,a.y,a.heading,b.x,b.y,b.heading,a,b)<cpa(a,b)
        break;
    else
        a=a.calculateMovement(timeStep,1);
        b=b.calculateMovement(timeStep,1);
        
        wyniki(i,1)=a.x;
        wyniki(i,2)=a.y;
        
        wyniki(i,3)=b.x;
        wyniki(i,4)=b.y;
        wyniki(i,5)=distance(a,b);
        wyniki(i,6)=distanceOutline(a.x,a.y,a.heading,b.x,b.y,b.heading,a,b);
        wyniki(i,7)=a.heading;
        wyniki(i,8)=b.heading;
        c=cpaOutline(a,b,timeStep);
        if c>cpaWanted || (wyniki(i,6)>prevDistance && exit)
            a=a.setRudderOrder(0);
            break;
        elseif wyniki(i,6)>prevDistance
            break;
        end
        prevDistance=wyniki(i,6);
    end
end
% rysowanie wykresu
% narysowanie statków i odległości dla podglądu
[dist,results]=distanceOutline(a.x,a.y,a.heading,b.x,b.y,b.heading,a,b);
outlineA=drawOutline(a.x,a.y,a.heading,a,1);
outlineB=drawOutline(b.x,b.y,b.heading,b,1);
% figura i ustawienia
figure;hold on;axis equal;grid on;
xlabel('Y [m]');
ylabel('X [m]');
% sylwetki w momencie wyjscia
% plot(outlineA(:,1),outlineA(:,2),a.colour);
% plot(outlineB(:,1),outlineB(:,2),b.colour);
% trajektorie do momentu wyjscia
plot(wyniki(:,2),wyniki(:,1));
plot(wyniki(:,4),wyniki(:,3));
plot(wyniki(:,2),wyniki(:,1));
plot(wyniki(:,4),wyniki(:,3));
%% KROK 2 - wykreslenie trajektorii po wyjsciu
% petla wyliczen
while i<iMax
    i=i+1;
    if distance(a,b)<cpa(a,b)
        break;
    else
        a=a.calculateMovement(timeStep,1);
        b=b.calculateMovement(timeStep,1);
        
        wyniki(i,1)=a.x;
        wyniki(i,2)=a.y;
        
        wyniki(i,3)=b.x;
        wyniki(i,4)=b.y;
        wyniki(i,5)=distance(a,b);
        wyniki(i,6)=distanceOutline(a.x,a.y,a.heading,b.x,b.y,b.heading,a,b);
        wyniki(i,7)=a.heading;
        wyniki(i,8)=b.heading;
    end
end

% narysowanie statków i odległości dla podglądu
outlineA=drawOutline(a.x,a.y,a.heading,a,1);
outlineB=drawOutline(b.x,b.y,b.heading,b,1);
% sylwetki w momecie zakonczenia zabawy
plot(outlineA(:,1),outlineA(:,2),a.colour);
plot(outlineB(:,1),outlineB(:,2),b.colour);
h1=plot(wyniki(:,2),wyniki(:,1));
h2=plot(wyniki(:,4),wyniki(:,3));
% %plot distance
% distanceLine=[a.x b.y;b.x a.y];
% plot([a.y b.y],[a.x b.x],'k');
%% KROK 3 - wyznaczenie sylwetek i linii dla faktycznego najwiekszego zblizenia
[nnn,zzz]=min(wyniki(:,6));
if nnn > cpaWanted
    disp(['Spełnione, osiągnięta odległość to ' num2str(nnn) ' m, wymagano ' num2str(cpaWanted) ' m, odleglość między punktami to ' num2str(wyniki(zzz,5)) ' m']);
else
    disp(['Niespełnione, zbliżono na ' num2str(nnn) ' m, oczekiwano ' num2str(cpaWanted) ' m, odleglość między punktami to ' num2str(wyniki(zzz,5)) ' m']);
end
[dist,results]=distanceOutline(wyniki(zzz,1),wyniki(zzz,2),wyniki(zzz,7),...
    wyniki(zzz,3),wyniki(zzz,4),wyniki(zzz,8),a,b);
outlineA=drawOutline(wyniki(zzz,1),wyniki(zzz,2),wyniki(zzz,7),a,1);
outlineB=drawOutline(wyniki(zzz,3),wyniki(zzz,4),wyniki(zzz,8),b,1);
% sylwetki w momencie najwiekszego zblizenia
plot(outlineA(:,1),outlineA(:,2),a.colour);
plot(outlineB(:,1),outlineB(:,2),b.colour);
plot(results(:,2),results(:,1),'k');
plot([wyniki(zzz,2) wyniki(zzz,4)],[wyniki(zzz,1) wyniki(zzz,3)]);

legend([h1(1), h2(1)], 'trajektoria statku własnego','trajektoria statku obcego');