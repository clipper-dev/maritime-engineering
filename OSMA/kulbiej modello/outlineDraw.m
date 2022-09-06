clc;clear all;close all
a=shipDefault3('kvlcc2','k','true');
b=shipDefault3('kvlcc2','k','true');


figure;hold on;axis equal;grid on;hold on;
xlabel('Y [m]');
ylabel('X [m]');
%narysowanie statków i odległości dla podglądu
outlineA=drawOutline(a.x,a.y,a.heading,a,1);
plot(outlineA(:,1),outlineA(:,2),a.colour);

disp("Fini");