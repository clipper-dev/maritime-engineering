clear;close all;clc
scenario=3;
xx2=matfile('kolizjaWyniki4.mat');
[a,b]=navigationalSituation(scenario);
wyniki=xx2.wyniki2;

%% trajektorie
f1=figure;hold on;axis equal;grid on;
% title("Zderzenie statków, statek własny manewruje, obcy pozostaje bierny");
xlabel('Y [m]');
ylabel('X [m]');
for rudderNumber=1:15
    
    
    h2Y=wyniki(scenario,rudderNumber,:,7);
    isNZ=(~h2Y==0);
    duration=length(h2Y(isNZ));
    [nnn,zzz]=min(wyniki(scenario,rudderNumber,1:duration,13));
    zzz=zzz;
    
    h1=plot(squeeze(wyniki(scenario,rudderNumber,1:duration,3)),squeeze(wyniki(scenario,rudderNumber,1:duration,2)),'Color','#A2142F');
    h2=plot(squeeze(wyniki(scenario,rudderNumber,1:duration,8)),squeeze(wyniki(scenario,rudderNumber,1:duration,7)),'Color','#0072BD');
    %
    [dist,results]=distanceOutline(...
        wyniki(scenario,rudderNumber,zzz,2),...
        wyniki(scenario,rudderNumber,zzz,3),...
        wyniki(scenario,rudderNumber,zzz,14),...
        wyniki(scenario,rudderNumber,zzz,7),...
        wyniki(scenario,rudderNumber,zzz,8),...
        wyniki(scenario,rudderNumber,zzz,15),a,b);
    outlineA=drawOutline(wyniki(scenario,rudderNumber,zzz,2),...
        wyniki(scenario,rudderNumber,zzz,3),...
        wyniki(scenario,rudderNumber,zzz,14),a,1);
    outlineB=drawOutline(wyniki(scenario,rudderNumber,zzz,7),...
        wyniki(scenario,rudderNumber,zzz,8),...
        wyniki(scenario,rudderNumber,zzz,15),b,1);
    % % sylwetki w momencie najwiekszego zblizenia
    plot(outlineA(:,1),outlineA(:,2),a.colour);
    plot(outlineB(:,1),outlineB(:,2),b.colour);
    plot(results(:,2),results(:,1),'kp');
end

%% wykres energii
for rudderNumber=1:15
    wyniki2(rudderNumber,1)=35-(rudderNumber-1)*5;
    %% plot trajektorii oraz KPBU/PBU
    % figura i ustawienia
    % trajektorie do momentu wyjscia
    h2Y=wyniki(scenario,rudderNumber,:,7);
    isNZ=(~h2Y==0);
    duration=length(h2Y(isNZ));
    
    [nnn,zzz]=min(wyniki(scenario,rudderNumber,1:duration,13));
    
    %% energia zderzenia
    % ustawienie statkow
    
    a=a.updateShip([...
        wyniki(scenario,rudderNumber,zzz,2) wyniki(scenario,rudderNumber,zzz,3) 0 ...
        0 0 wyniki(scenario,rudderNumber,zzz,14)...
        wyniki(scenario,rudderNumber,zzz,4) wyniki(scenario,rudderNumber,zzz,5) 0 ...
        0 0 0]);
    b=b.updateShip([...
        wyniki(scenario,rudderNumber,zzz,7) wyniki(scenario,rudderNumber,zzz,8) 0 ...
        0 0 wyniki(scenario,rudderNumber,zzz,15)...
        wyniki(scenario,rudderNumber,zzz,9) wyniki(scenario,rudderNumber,zzz,10) 0 ...
        0 0 0]);
    % plot(results(:,2),results(:,1),'k');
    % (shipA, shipB, xAC, yAC, xBC, yBC, alpha, beta, e,u0)
    dx=results(1,1)-results(2,1);
    dy=results(1,2)-results(2,2);
    alpha = pi-atan(dx/dy)-wyniki(scenario,rudderNumber,zzz,14);
    beta = wyniki(scenario,rudderNumber,zzz,15)-wyniki(scenario,rudderNumber,zzz,14);
    gamma = beta - alpha;
    wyniki2(rudderNumber,2)=alpha;
    wyniki2(rudderNumber,3)=beta;
    wyniki2(rudderNumber,4)=gamma;
    wyniki2(rudderNumber,5)=energy(a,b,results(1,1),results(1,2),results(2,1),results(2,2),alpha,beta,0,0.6);
    %energie kinetyczne obu statków
    wyniki2(rudderNumber,6)=0.5*(wyniki(scenario,rudderNumber,zzz,4)^2+wyniki(scenario,rudderNumber,zzz,5)^2)*a.m+0.5*a.Izz*wyniki(scenario,rudderNumber,zzz,6)^2;
    wyniki2(rudderNumber,7)=0.5*(wyniki(scenario,rudderNumber,zzz,9)^2+wyniki(scenario,rudderNumber,zzz,10)^2)*b.m+0.5*b.Izz*wyniki(scenario,rudderNumber,zzz,11)^2;
    wyniki2(rudderNumber,8)=tcpa(a,b);
    wyniki2(rudderNumber,9)=zzz;
    wyniki2(rudderNumber,10)=0.5*(wyniki(scenario,rudderNumber,1,4)^2+wyniki(scenario,rudderNumber,1,5)^2)*a.m+0.5*a.Izz*wyniki(scenario,rudderNumber,1,6)^2;
    wyniki2(rudderNumber,11)=0.5*(wyniki(scenario,rudderNumber,1,9)^2+wyniki(scenario,rudderNumber,1,10)^2)*b.m+0.5*b.Izz*wyniki(scenario,rudderNumber,1,11)^2;
    
end

f4=figure;hold on;grid on;
plot(wyniki2(:,1),wyniki2(:,5)/1E6,'-ko');
plot(wyniki2(:,1),wyniki2(:,6)/1E6,'-r+');
plot(wyniki2(:,1),wyniki2(:,7)/1E6,'-b^');
plot(wyniki2(:,1),(wyniki2(:,6)+wyniki2(:,7))/1E6,'-mv');
legend('energia kolizji','energia kinetyczna statku własnego','energia kinetyczna statku obcego','energia układu statków');
ylabel('energia [MJ]');
xlabel('wychylenie steru manewru [°]');

% wyniki(1,rudder,i,16)=a.rudderAngle;

[nnn,rudderNumber]=min(wyniki2(:,5));
timeStep=0.01;
for i=1:500/timeStep
    if wyniki(scenario,rudderNumber,i,16)~=0
        kkk=i;
        break;
    end
end
timeElapsed=(wyniki2(rudderNumber,9)-kkk)*timeStep;

[a,b]=navigationalSituation(scenario);
a=a.updateShip([...
    wyniki(scenario,rudderNumber,kkk,2) wyniki(scenario,rudderNumber,kkk,3) 0 ...
    0 0 wyniki(scenario,rudderNumber,kkk,14)...
    wyniki(scenario,rudderNumber,kkk,4) wyniki(scenario,rudderNumber,kkk,5) 0 ...
    0 0 0]);
b=b.updateShip([...
    wyniki(scenario,rudderNumber,kkk,7) wyniki(scenario,rudderNumber,kkk,8) 0 ...
    0 0 wyniki(scenario,rudderNumber,kkk,15)...
    wyniki(scenario,rudderNumber,kkk,9) wyniki(scenario,rudderNumber,kkk,10) 0 ...
    0 0 0]);
tcpaPunkty=tcpa(a,b);

disp(['Najmniejsza energia zderzenia wynosi ' num2str(wyniki2(rudderNumber,5)/1E6) ' MJ, osiągnięta przy wychylenia steru statku własnego o ' num2str(wyniki2(rudderNumber,1)) '°.' ...
    ' Symulowany manewr został rozpoczęty w momencie, kiedy TCPA między punktami wynosiło ' num2str(tcpaPunkty) ' s, natomiast między obrysami ' num2str(timeElapsed)...
    ' s. Kąt zderzenia wynosi ' num2str(wyniki2(rudderNumber,2)*57.3) '°, natomiast aspekt  ' num2str(min(wyniki2(rudderNumber,3)*57.3,360-wyniki2(rudderNumber,3)*57.3)) '°.']);

