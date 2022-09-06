%% DANE WEJŒCIOWE
ro = 1.025; %gêstoœæ wody, wszystko w kN!!!
u = 5.911; %prêdkoœæ projektowa CN
l = 60.2; %d³ugoœæ
b = 10.5; %szerokoœæ
d = 3.15; %zanurzenie
cB = 0.59; %wsp. pe³notliwoœci podwodzia
cM = 466.5/(55.1*10.5); %wsp. pe³notliwoœci wodnicy
pD = 2.26; %œrednica œruby
n = 222/60; %obroty œruby
R_0 = 0.014; %wsp. oporu kad³uba w p³yniêciu prosto
w = 0.24; %wsp. strumienia nad¹¿aj¹cego
t = 0.2;  %wsp. ssania
%% WYLICZENIA
rf = 0.5*ro*l*d*R_0; %RezistanceFactor
tf = (1-t)*ro*n^2 * pD^4; %ThrustyFactor
k_T = u^2 * rf/tf;
J = u*(1-w)/(n*pD);
disp("kT = " + k_T + ", J = " + J + ", dla V = " + u/0.514 + "w.");