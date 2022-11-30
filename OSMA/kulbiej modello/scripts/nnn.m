%% Wczytywanie danych
clc;clear all; close all;
english = true;
dane90 = matfile('studies\001 - dynamic domain\bearing -35 270\90deg.mat');
lmm90=dane90.lmmData;
dane45 = matfile('studies\001 - dynamic domain\bearing -35 270\45deg.mat');
lmm45=dane45.lmmData;
dane30 = matfile('studies\001 - dynamic domain\bearing -35 270\30deg.mat');
lmm30=dane30.lmmData;
dane10 = matfile('studies\001 - dynamic domain\bearing -35 270\10deg.mat');
lmm10=dane10.lmmData;
dane1 = matfile('studies\001 - dynamic domain\bearing -35 270\1deg.mat');
lmm1=dane1.lmmData;
dane1 = matfile('studies\001 - dynamic domain\bearing precision versus\1deg.mat');
lmm1a=dane1.lmmData;
%% Rysowanie domeny dynamicznej


% konfigurowanie figury
f1 = figure; hold on; axis equal; grid on;
% nazywanie tego co trzeba
if english
    trajektoriaTytul="LMM dynamic domain for own ship in function of rudder";
else
    trajektoriaTytul="Domena dynamiczna LMM dla statku w³asnego w funkcji precyzji namiaru";
end
title(trajektoriaTytul);
xlabel('Y [m]');
ylabel('X [m]');
% rysowanie krzywej
% plot(lmm90(:,2),lmm90(:,1));
% plot(lmm45(:,2),lmm45(:,1));
% plot(lmm30(:,2),lmm30(:,1));
% plot(lmm10(:,2),lmm10(:,1));
plot(lmm1(:,2),lmm1(:,1));
plot(lmm1a(:,2),lmm1a(:,1));
% naniesienie statku w³asnego
[a,b]=navigationalSituation(25);
outlineA=drawOutline(a.x,a.y,a.heading,a,1);
plot(outlineA(:,1),outlineA(:,2),a.colour);
if english
    %legend('bearing precision 90°','bearing precision 45°','bearing precision 30°','bearing precision 10°','bearing precision 1°', 'outline of own ship');
    legend('dynamic domain LMM to starboard', 'dynamic domain LMM to port', 'own ship');
else
    legend('domena dynamiczna LMM', 'sylwetka statku w³asnego');
end