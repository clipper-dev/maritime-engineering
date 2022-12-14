%% Wczytywanie danych
% tylko rysowanie wykresow dla poczatku sytuacji 38
clc;clear all; close all;

[a,b]=navigationalSituation(38);
tcpa0 = tcpa(a,b)
dat=matfile('wyniki/zmianyKursu/38-punkty.mat');
dane = dat.res;
dat2=matfile('wyniki/zmianyKursu/38-obrysy.mat');
dane2 = dat2.res;
dat3=matfile('wyniki/zmianyKursu/38-dynamika.mat');
dane3 = dat3.res;

figure; hold on;grid on;
plot(abs(dane(1:1390,1)),dane(1:1390,5));
plot(abs(dane2(1:1385,1)),dane2(1:1385,5));
plot(abs(dane3(1:51,1)),dane3(1:51,5));
xlabel("Czas od rozpoczęcia symulacji [s]");

figure; hold on;grid on;
plot(abs(dane(1:1390,1)-tcpa0),dane(1:1390,5));
plot(abs(dane2(1:1385,1)-tcpa0),dane2(1:1385,5));
plot(abs(dane3(1:51,1)-tcpa0),dane3(1:51,5));
set(gca, 'XDir','reverse')
xlabel("TCPA [s]");

ylabel("Zmiana kursu [deg]");
legend("Model kinematyczny punktowy","Model kinematyczny obrysowy","Model dynamiczny obrysowy")