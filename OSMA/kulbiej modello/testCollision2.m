clc;clear;close all

[a,b]=navigationalSituation(2);
a=a.updateShip([...
    0 0 0 ...
    0 0 0/57.3...
    5.8 0 0 ...
    0 0 0]);
b=b.updateShip([...
    0 -25 0 ...
    0 0 45/57.3...
    5.8 0 0 ...
    0 0 0]);

[dist,results]=distanceOutline(a.x,a.y,a.heading,b.x,b.y,b.heading,a,b);
outlineA=drawOutline(a.x,a.y,a.heading,a,1);
outlineB=drawOutline(b.x,b.y,b.heading,b,1);
% % sylwetki w momencie najwiekszego zblizenia
figure;hold on;axis equal;
plot(outlineA(:,1),outlineA(:,2),a.colour);
plot(outlineB(:,1),outlineB(:,2),b.colour);
plot(results(:,2),results(:,1),'k');

% plot(results(:,2),results(:,1),'k');
% (shipA, shipB, xAC, yAC, xBC, yBC, alpha, beta, e,u0)
dx=results(1,1)-results(2,1);
dy=results(1,2)-results(2,2);
alpha = pi-atan(dx/dy)-a.heading;
beta = b.heading - a.heading;
gamma = beta - alpha;
% if beta>pi
%     beta=2*pi-beta;
% end
alpha*57.3
beta*57.3
gamma*57.3

energiaZderzenia=energy(a,b,results(1,1),results(1,2),results(2,1),results(2,2),alpha,beta,0,0.6)

