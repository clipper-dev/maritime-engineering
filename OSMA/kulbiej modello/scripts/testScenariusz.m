clc;clear all;close all
a=shipDefault("nawigator",666,0,1,35);
b=shipDefault("nawigator",666,0,1,0);
dist = 700;
bearing = 45;
course = 270;
i=0;
iMax=100;
cpaWanted = 5*a.length;
b=b.updateShip([dist*sin(bearing/57.3) dist*cos(bearing/57.3) 0 0 0 course/57.3 666 0 0 0 0 0]);
%% jezus upada po raz pierwszy
while true
    i=i+1;
    if distance(a,b)<cpa(a,b)
        break;
    else
        a=a.calculateMovement(1,1);
        b=b.calculateMovement(1,1);
        
        wyniki(i,1)=a.x;
        wyniki(i,2)=a.y;
        
        wyniki(i,3)=b.x;
        wyniki(i,4)=b.y;
        wyniki(i,5)=distance(a,b);
        wyniki(i,6)=cpa(a,b);
        wyniki(i,7)=a.heading;
        wyniki(i,8)=b.heading;
        if cpa(a,b)>cpaWanted
            a=a.setRudderOrder(0);
            break;
        end
    end
end

distance(a,b);
[dist,results]=distanceOutline(a.x,a.y,a.heading,b.x,b.y,b.heading,a,b);
dist;
distanceOutlineLineX=[results(1,2) results(2,2)];
distanceOutlineLineY=[results(1,1) results(2,1)];
%narysowanie statków i odległości dla podglądu
outlineA=drawOutline(a.y,a.x,a.heading,a,1);
outlineB=drawOutline(b.y,b.x,b.heading,b,1);
figure;hold on;axis equal;grid on;
plot(outlineA(:,1),outlineA(:,2),a.colour);
plot(outlineB(:,1),outlineB(:,2),b.colour);
plot(wyniki(:,2),wyniki(:,1));
plot(wyniki(:,4),wyniki(:,3));
%plot distance
distanceLine=[a.x b.x;b.y a.y];
%plot([a.y b.y],[a.x b.x],'k');%linia odleglosci punktow
%plot([results(1,2) results(2,2)],[results(1,1) results(2,1)],'k');%linia ogleglosci obrysow
%plot([x(1) x(2)],[y(1) y(2)]);
xlabel('Y [m]');
ylabel('X [m]');
%plot distance outline
%% po raz drugi
while i<iMax
    i=i+1;
    if distance(a,b)<cpa(a,b)
        break;
    else
        a=a.calculateMovement(1,1);
        b=b.calculateMovement(1,1);
        
        wyniki(i,1)=a.x;
        wyniki(i,2)=a.y;
        
        wyniki(i,3)=b.x;
        wyniki(i,4)=b.y;
        wyniki(i,5)=distance(a,b);
        wyniki(i,7)=a.heading;
        wyniki(i,8)=b.heading;
    end
end
distance(a,b);
[dist,results]=distanceOutline(a.x,a.y,a.heading,b.x,b.y,b.heading,a,b);
dist;
distanceOutlineLineX=[results(1,2) results(2,2)];
distanceOutlineLineY=[results(1,1) results(2,1)];
%narysowanie statków i odległości dla podglądu
outlineA=drawOutline(a.y,a.x,a.heading,a,1);
outlineB=drawOutline(b.y,b.x,b.heading,b,1);
plot(outlineA(:,1),outlineA(:,2),a.colour);
plot(outlineB(:,1),outlineB(:,2),b.colour);
h1=plot(wyniki(:,2),wyniki(:,1));
h2=plot(wyniki(:,4),wyniki(:,3));
%plot distance
distanceLine=[a.x b.x;b.y a.y];
%plot([a.y b.y],[a.x b.x],'k');%linia odleglosci punktow
%plot([results(1,2) results(2,2)],[results(1,1) results(2,1)],'k');%linia ogleglosci obrysow
%plot([x(1) x(2)],[y(1) y(2)]);
xlabel('Y [m]');
ylabel('X [m]');
disp("Fini");
%% po raz trzeci
[nnn,zzz]=min(wyniki(:,5));
if nnn > cpaWanted
disp(['Spełnione, osiągnięta odległość to ' num2str(nnn)]);
else
disp(['Niespełnione, zbliżono na ' num2str(nnn)]);
end
distance(a,b);
[dist,results]=distanceOutline(a.x,a.y,a.heading,b.x,b.y,b.heading,a,b);
distanceOutlineLineX=[results(1,2) results(2,2)];
distanceOutlineLineY=[results(1,1) results(2,1)];
%narysowanie statków i odległości dla podglądu
outlineA=drawOutline(wyniki(zzz,2),wyniki(zzz,1),wyniki(zzz,7),a,1);
outlineB=drawOutline(wyniki(zzz,4),wyniki(zzz,3),wyniki(zzz,8),b,1);
plot(outlineA(:,1),outlineA(:,2),a.colour);
plot(outlineB(:,1),outlineB(:,2),b.colour);
%plot distance
plot([wyniki(zzz,2) wyniki(zzz,4)],[wyniki(zzz,1) wyniki(zzz,3)],'k');%linia odleglosci punktow
plot([results(1,2) results(2,2)],[results(1,1) results(2,1)],'k');%linia ogleglosci obrysow
%plot([x(1) x(2)],[y(1) y(2)]);
xlabel('Y [m]');
ylabel('X [m]');
legend([h1(1), h2(1)], 'trajektoria statku własnego','trajektoria statku obcego');