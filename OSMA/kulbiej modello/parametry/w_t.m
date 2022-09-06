%% DANE WEJŒCIOWE
u = 5.911; %prêdkoœæ projektowa CN
l = 60; %d³ugoœæ
b = 10.5; %szerokoœæ
d = 3.15; %zanurzenie
cB = 0.59; %wsp. pe³notliwoœci podwodzia
cM = 466.5/(55.1*10.5); %wsp. pe³notliwoœci wodnicy
pD = 2.26; %œrednica œruby
%% WYLICZENIA
% wake fraction, aka wspó³czynnik strumienia nad¹¿aj¹cego
wSrednie = 1;
% wg Harvalda (1983)
a = 0.1*b/l +0.149;
b = 0.05*b/l+0449;
c = 585- 5027*b/l +11700*(b/l)^2;
w1 = a + b/(c*(0.98-cB)^2 +1);
w2 = -0.05/(100*(cB-0.7)^2+1);
w3 = -0.18+0.00756/(pD/l + 0.002);
w = w1 + w2 + w3;
wSrednie = wSrednie*w;
disp("Wake fraction (Harvald) = " + w);
% wg Papmiela
Fn = u/sqrt(9.81*l);
V = (l*b*t*cB)^(1/3);
w = 0.165*cB*sqrt(V/pD)-0.1*(Fn-0.2);
wSrednie = wSrednie * w;
disp("Wake fraction (Papmiel) = " + w);
% wg Taylora
w = 0.5*cB - 0.05;
wSrednie = wSrednie * w;
disp("Wake fraction (Taylor) = " + w);
%wg Schiffbaukalender
w = -0.24+0.75*cB;
wSrednie = wSrednie * w;
disp("Wake fraction (Schiffbaukalender) = " + w);
%wg Gilla
w = cB/1.5 - 0.15;
wSrednie = wSrednie * w;
disp("Wake fraction (Gill) = " + w);
%œrednie
wSrednie = nthroot(wSrednie,5);
disp("Wake fraction (œrednie) = " + wSrednie);

% thrust deduction, aka wspó³czynnik ssania
tAvg = 1;
% wg Harvalda (1983)
d = 0.625*b/l + 0.08;
e = 0.165 - (0.25*b/l);
f = 525 - 8060*b/l + 20300*(b/l)^2;
t1 = d + e/(f*(0.98-cB)^3+1);
t2 = 0.02;
t3 = 2*(pD/l - 0.04);
t = t1 + t2 + t3;
disp("Thrust deduction = " + t);
%wg ???
t = (1.57 - 2.3*cB/cM+1.5*cB)*wSrednie;
disp("Thrust deduction (1) = " + t);
tAvg = tAvg*t;
%wg ???
t = 0.06+0.7*wSrednie;
disp("Thrust deduction (2) = " + t);
tAvg = tAvg*t;
%wg ???
t = 0.25*wSrednie + 0.14;
disp("Thrust deduction (3) = " + t);
tAvg = tAvg*t;
%œrednie
tAvg = nthroot(tAvg,3);
disp("Thrust deduction (œrednie) = " + tAvg);
