clc;clear all;close all
%% SCENARIUSZ
naviScenario=25;
coop=false;
rudderA=35;
rudderB=0;
timeStep=1;

%% dane sterujące
if ~coop
    rudderB=0;
end
[a,b]=navigationalSituation(naviScenario);
[aaa,bbb]=navigationalSituation(naviScenario);
[aaa2,bbb2]=navigationalSituation(naviScenario);
requiredCPA = 0.5*(a.breadth+b.breadth);
elapsedTime=0;
exit=true;
simulationEndTime=50;
maxElapsedTime=500;

%% pętla
koniec=false;
collision = false;
simulationEnd = false;
j=0;
while ~collision  && ~simulationEnd
    %check
    a=aaa;
    b=bbb;
    a=a.setRudderOrder(rudderA/57.3);
    b=b.setRudderOrder(rudderB/57.3);
    further=false;
    tAdd=0;
    while true
        [distanceO,results]=distanceOutline(a.x,a.y,a.heading,b.x,b.y,b.heading,a,b);
        cpaO=cpaOutline(a,b,timeStep);
        %jeśli doszło do zderzenia to znaczy że poprzedni to był ostatni
        %skuteczny
        if distanceO<requiredCPA
            collision=true;
            break;
        else
            if cpaO<requiredCPA
                a=a.calculateMovement(timeStep,1);
                b=b.calculateMovement(timeStep,1);
                if elapsedTime/timeStep==67
                    j=j+1;
                    if j==21
                        k1=a;
                    end
                    wyniki2(j,1)=a.x;
                    wyniki2(j,2)=a.y;
                    wyniki2(j,3)=b.x;
                    wyniki2(j,4)=b.y;
                    wyniki2(j,5)=distance(a,b);
                    wyniki2(j,6)=distanceOutline(a.x,a.y,a.heading,b.x,b.y,b.heading,a,b);
                    wyniki2(j,7)=a.heading;
                    wyniki2(j,8)=b.heading;
                    wyniki2(j,7)=a.rudderAngle;
                    wyniki2(j,8)=b.rudderAngle;
                end
            else
                if ~further
                    if exit
                        
                        a=a.setRudderOrder(0);
                        b=b.setRudderOrder(0);
                    end
                    further=true;
                end
                
                if tAdd < simulationEndTime && further
                    tAdd=tAdd+timeStep;
                    a=a.calculateMovement(timeStep,1);
                    b=b.calculateMovement(timeStep,1);
                    
                    if elapsedTime/timeStep==67
                        j=j+1;
                        if j==21
                            k1=a;
                        end
                        wyniki2(j,1)=a.x;
                        wyniki2(j,2)=a.y;
                        wyniki2(j,3)=b.x;
                        wyniki2(j,4)=b.y;
                        wyniki2(j,5)=distance(a,b);
                        wyniki2(j,6)=distanceOutline(a.x,a.y,a.heading,b.x,b.y,b.heading,a,b);
                        wyniki2(j,7)=a.heading;
                        wyniki2(j,8)=b.heading;
                        wyniki2(j,7)=a.rudderAngle;
                        wyniki2(j,8)=b.rudderAngle;
                    end
                else
                    break;
                end
                
            end
        end
        
    end
    if collision
        elapsedTime=elapsedTime-timeStep;
        break;
    else
        if elapsedTime>maxElapsedTime
            break;
        else
            %timeStep
            elapsedTime=elapsedTime+timeStep;
            %simulate
            aaa2=aaa;
            bbb2=bbb;
            aaa=aaa.calculateMovement(timeStep,1);
            bbb=bbb.calculateMovement(timeStep,1);
        end
    end
end
disp("Fini");

%% ostatnia symulacja

[a,b]=navigationalSituation(naviScenario);
for i=1:elapsedTime/timeStep
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
    wyniki(i,9)=a.rudderAngle;
    wyniki(i,10)=b.rudderAngle;
    wyniki(i,11)=i;
    wyniki(i,12)=cpa(a,b);
    wyniki(i,13)=cpaOutline(a,b,timeStep);
    
end
if elapsedTime<=timeStep
    i=0;
end
pbu=i;
a=a.setRudderOrder(rudderA/57.3);
b=b.setRudderOrder(rudderB/57.3);
[distanceO,results]=distanceOutline(a.x,a.y,a.heading,b.x,b.y,b.heading,a,b);
prevDistanceO=distanceO;
exitRudder=1;
while true
    i=i+1;
    a=a.calculateMovement(timeStep,1);
    b=b.calculateMovement(timeStep,1);
    [distanceO,results]=distanceOutline(a.x,a.y,a.heading,b.x,b.y,b.heading,a,b);
    cpaO=cpaOutline(a,b,timeStep);
    %jeśli doszło do zderzenia to znaczy że poprzedni to był ostatni
    %skuteczny
    if cpaO>requiredCPA && pbu~=0
        if exit
            a=a.setRudderOrder(0);
            b=b.setRudderOrder(0);
exitRudder=i;
        end
        i=i-1;
        break;
    elseif cpaO>requiredCPA && pbu==0
        
        i=i-1;
        break;
    else
        prevDistanceO=distanceO;
        wyniki(i,1)=a.x;
        wyniki(i,2)=a.y;
        wyniki(i,3)=b.x;
        wyniki(i,4)=b.y;
        wyniki(i,5)=distance(a,b);
        wyniki(i,6)=distanceOutline(a.x,a.y,a.heading,b.x,b.y,b.heading,a,b);
        wyniki(i,7)=a.heading;
        wyniki(i,8)=b.heading;
        wyniki(i,9)=a.rudderAngle;
        wyniki(i,10)=b.rudderAngle;
        wyniki(i,11)=i;
        wyniki(i,12)=cpa(a,b);
        wyniki(i,13)=cpaOutline(a,b,timeStep);
    end
end
t=0;
while t<simulationEndTime
    t=t+timeStep;
    i=i+1;
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
    wyniki(i,9)=a.rudderAngle;
    wyniki(i,10)=b.rudderAngle;
    wyniki(i,11)=i;
    wyniki(i,12)=cpa(a,b);
    wyniki(i,13)=cpaOutline(a,b,timeStep);
end

%% plot trajektorii oraz KPBU/PBU
% tytuły wykresów
if rudderB==0
    obcySter='obcy bezczynny';
    if rudderA==35
        manewr='wyłącznie własny w prawo';
    else
        manewr='wyłącznie własny w lewo';
    end
elseif rudderB==35
    obcySter='obcy w prawo';
    if rudderA==35
        manewr='oba w prawo';
    else
        manewr='oba od siebie';
    end
elseif rudderB==-35
    obcySter='obcy w lewo';
    if rudderA==35
        manewr='oba do siebie';
    else
        manewr='oba w lewo';
    end
end

if rudderA==0
    wlasnySter='własny bezczynny, ';
elseif rudderA==35
    wlasnySter='własny w prawo, ';
elseif rudderA==-35
    wlasnySter='własny w lewo, ';
end

trajektoriaTytul=['Trajektorie manewru ucieczkowego, ' wlasnySter obcySter];
wynikiTytul=['Wyniki manewru ucieczkowego, ' wlasnySter obcySter];

[dist,results]=distanceOutline(a.x,a.y,a.heading,b.x,b.y,b.heading,a,b);
outlineA=drawOutline(a.x,a.y,a.heading,a,1);
outlineB=drawOutline(b.x,b.y,b.heading,b,1);
% figura i ustawienia
f1=figure;hold on;axis equal;grid on;
title(trajektoriaTytul);
xlabel('Y [m]');
ylabel('X [m]');
% trajektorie do momentu wyjscia
h1=plot(wyniki(:,2),wyniki(:,1),'Color','#A2142F');
h2=plot(wyniki(:,4),wyniki(:,3),'Color','#0072BD');

[nnn,zzz]=min(wyniki(:,6));
[distPBU1,results]=distanceOutline(aaa2.x,aaa2.y,aaa2.heading,bbb2.x,bbb2.y,bbb2.heading,aaa2,bbb2);
distPBU2=distance(aaa2,bbb2);
if nnn > requiredCPA
    disp(['Zasymulowany manewr ostatniej chwili w wariancie ' ...
        manewr ' jest skuteczny, osiągnięta odległość minięcia między obrysami to ' num2str(nnn)...
' m, wymagano ' num2str(requiredCPA) ' m, odległość minięcia między punktami to ' num2str(wyniki(zzz,5)) ' m. '...
'Czas do osiągnięcia punktu bez ucieczki dla statku własnego: ' num2str(elapsedTime) ' s. '...
'Odległość między statkami w momencie rozpoczęcia wyznaczonego manewru ostatniej chwili '...
'pomiędzy punktami to ' num2str(distPBU2) ' m, natomiast między obrysami to ' num2str(distPBU1) ' m. '...
'Pozycja punktu bez ucieczki dla statku własnego to P = (' num2str(aaa2.x) ' m,' num2str(aaa2.y) ' m)'...
'Statek własny rozpoczął wychodzenie z manewru poprzez manewr środek ster będąc w pozycji  P = (' num2str(wyniki(exitRudder,2)) ' m, ' num2str(wyniki(exitRudder,1)) ' m).']);

else
    disp(['Niespełnione, zbliżono na ' num2str(nnn) ' m, oczekiwano ' num2str(requiredCPA) ' m, odleglość między punktami to ' num2str(wyniki(zzz,5)) ' m. ']);
    disp(['Czas do przeczekany: ' num2str(elapsedTime) ' s.']);
    
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
% kooperacyjne punktu bez ucieczki
if pbu~=0
    h3=plot(wyniki(pbu,2),wyniki(pbu,1),'o');
    legend([h1(1), h2(1), h3(1)], ...
        'trajektoria statku własnego','trajektoria statku obcego',...
        'PBU statku własnego');
datatip(h1,wyniki(pbu,2),wyniki(pbu,1));
else
    legend([h1(1), h2(1)], ...
        'trajektoria statku własnego','trajektoria statku obcego');
end



%% plot CPA i odległości

f2=figure;hold on;grid on;
title(wynikiTytul);
p1=plot(wyniki(:,11)*timeStep,wyniki(:,5));
p2=plot(wyniki(:,11)*timeStep,wyniki(:,6));
p3=plot(wyniki(:,11)*timeStep,wyniki(:,12));
p4=plot(wyniki(:,11)*timeStep,wyniki(:,13));

legend([p1(1), p2(1), p3(1), p4(1)], ...
    'odległość punkty','odległość obrysy',...
    'CPA punkty','CPA obrysy');
xlabel('czas [s]');
ylabel('odległość chwilowa/minięcia [m]');