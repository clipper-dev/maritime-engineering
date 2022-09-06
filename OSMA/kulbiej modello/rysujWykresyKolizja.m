clear;close all;clc
scenario=2;
xx2=matfile('kolizjaWyniki2.mat');
[a,b]=navigationalSituation(scenario);
rudderOwn=30;
wyniki=xx2.wyniki2;
timeStep=1;
%35-5*(rudder-1)
rudderNumber=8-rudderOwn/5;
wynikiNowe=squeeze(wyniki(scenario,rudderNumber,:,:));


%% plot trajektorii oraz KPBU/PBU
% tytuły wykresów
% wyniki(rudder,i,1)=i;
% wyniki(rudder,i,2)=a.x;
% wyniki(rudder,i,3)=a.y;
% wyniki(rudder,i,4)=a.vx;
% wyniki(rudder,i,5)=a.vy;
% wyniki(rudder,i,6)=a.wz;
% wyniki(rudder,i,7)=b.x;
% wyniki(rudder,i,8)=b.y;
% wyniki(rudder,i,9)=b.vx;
% wyniki(rudder,i,10)=b.vy;
% wyniki(rudder,i,11)=b.wz;
% wyniki(rudder,i,12)=distance(a,b);
% wyniki(rudder,i,13)=distanceO;
% wyniki(rudder,i,14)=a.heading;
% wyniki(rudder,i,15)=b.heading;
% wyniki(rudder,i,16)=a.rudderAngle;
% wyniki(rudder,i,17)=b.rudderAngle;
% wyniki(rudder,i,18)=cpa(a,b);

% figura i ustawienia
        % addressing logical array of nonzero elements
%plot(x(isNZ),y(isNZ)) 
f1=figure;hold on;axis equal;grid on;
xlabel('Y [m]');
ylabel('X [m]');
% trajektorie do momentu wyjscia
h1X=wynikiNowe(:,3);
h1Y=wynikiNowe(:,2);
h2X=wynikiNowe(:,8);
h2Y=wynikiNowe(:,7);
isNZ=(~h2Y==0);
duration=length(h2Y(isNZ));
[nnn,zzz]=min(wynikiNowe(1:duration,13));
zzz=zzz-1;
h1=plot(h1X(1:zzz),h1Y(1:zzz),'Color','#A2142F');
h2=plot(h2X(1:zzz),h2Y(1:zzz),'Color','#0072BD');



[dist,results]=distanceOutline(wynikiNowe(zzz,2),wynikiNowe(zzz,3),wynikiNowe(zzz,14),...
   wynikiNowe(zzz,7),wynikiNowe(zzz,8),wynikiNowe(zzz,15),a,b);
outlineA=drawOutline(wynikiNowe(zzz,2),wynikiNowe(zzz,3),wynikiNowe(zzz,14),a,1);
outlineB=drawOutline(wynikiNowe(zzz,7),wynikiNowe(zzz,8),wynikiNowe(zzz,15),b,1);
% % sylwetki w momencie najwiekszego zblizenia
plot(outlineA(:,1),outlineA(:,2),a.colour);
plot(outlineB(:,1),outlineB(:,2),b.colour);
plot(results(:,2),results(:,1),'k');
% plot([wyniki(scenario,rudderNumber,zzz,2) wyniki(scenario,rudderNumber,zzz,4)],[wyniki(scenario,rudderNumber,zzz,1) wyniki(scenario,rudderNumber,zzz,3)]);
% kooperacyjne punktu bez ucieczki




%% plot CPA i odległości
% 
% f2=figure;hold on;grid on;
% p1=plot(wynikiNowe(:,11)*timeStep,wynikiNowe(:,5));
% p2=plot(wynikiNowe(:,11)*timeStep,wynikiNowe(:,6));
% p3=plot(wynikiNowe(:,11)*timeStep,wynikiNowe(:,12));
% p4=plot(wynikiNowe(:,11)*timeStep,wynikiNowe(:,13));
% 
% legend([p1(1), p2(1), p3(1), p4(1)], ...
%     'odległość punkty','odległość obrysy',...
%     'CPA punkty','CPA obrysy');
% xlabel('czas [s]');
% ylabel('odległość chwilowa/minięcia [m]');