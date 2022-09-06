% tu beda liczne wspolczynniki ktore pozniej beda podstawione do rownan
function[z]= wyniki(statek,ts,dt)
% odwolania do pliku war_pocz (definicja parametrow stanu statku i sta³e biorace udzia³ w rownaniach)
global  f  ro_a W v_a gamma_r V  L  m moment opory RY_k RY_p RX_p RY_r RZ_p RZ_k RZ_r  RX_k RX_r RX_a RY_a RZ_a  
L=statek.L;
B=statek.B;
D=statek.D;  %zanurzeie
H=statek.H;
C_B=statek.C_B;
%C_M=statek.C_M;
%W=statek.W;
%V=statek.V;
ro_w=statek.ro_w;
ro_a=statek.ro_a;
dryf=statek.dryf;
gamma=statek.gamma;
n=statek.n;
m=statek.m;
v_a=statek.v_a;
srednica=statek.srednica;
%a0=statek.a(1);
%a1=statek.a(2);
%a2=statek.a(3);
wys_steru=statek.wys_steru;
%a_ster=statek.a_ster;
%b_ster=statek.b_ster;
przysp_katowe=statek.przysp_katowe;
moment=statek.moment;
x=statek.x;
y=statek.y;
kurs=statek.kurs;
pr_wzdl=statek.pr_wzdl;
pr_pop=statek.pr_pop;
przysp_wzdl=statek.przysp_wzdl;
przysp_pop=statek.przysp_pop;

wych_steru=statek.wych_steru;
nast_steru=statek.nast_steru;

przysp_katowe_r=przysp_katowe*pi/(180*60*60);
kurs_r=kurs*pi/180;
gamma_r=gamma*pi/180;
pk_r=statek.pk*pi/(180*60);
dryf_r=dryf*pi/180;
wych_steru_r=wych_steru*pi/180;
nast_steru_r=nast_steru*pi/180;

% do wzorów na opor kadluba
m_x=0.5*ro_w*C_B*B*D*D;
m_y=0.5*ro_w*pi*L*D*D*(1+0.16*C_B*B/D -5.1*B*B/(L^2));
i_zz=0.5*ro_w*pi*L^3*D*D*(1/12+0.017*C_B*B/D-0.33*B/L);
k=2*D/L;
C_D=1.1+0.045*L/D-0.27*B/D+0.016*B*B/(D^2);
X_uu=-0.0334;
X_vr=(1.11*C_B -0.07)*m_y/( 0.5*ro_w*L*D);
X_vv=0.4*D*B^2/(L^2) -0.006;
X_rr=-0.0003;
Y_vu=-(D/L)*(pi/2*k+1.4*C_B*B/L);
Y_ru=0.25*pi*k*D/L;
Y_vv=-C_D*D/L;
Y_rr=0.01*C_D*D/L;
Y_vr=-0.32*C_D*D/L;
Y_rv=0.2*C_D*D/L;
N_vu=-k*D/L;
N_vv=0.1*Y_vv;
N_ru=(-0.54*k+k^2)*D/L;
N_rr=-0.05*C_D*D/L;
N_vr=0.1*Y_vr;
N_rv=-0.01*C_D*D/L;


%skladowe od kadluba 
RX_k=-m_x*przysp_wzdl+0.5*ro_w*L*D*(X_uu*pr_wzdl*abs(pr_wzdl)+X_vr*pr_pop*pk_r+X_vv*pr_pop^2+L^2*X_rr*pk_r*pk_r);
RY_k=-m_y*przysp_pop-m_x*pk_r*pr_wzdl+0.5*ro_w*L^2*(Y_vu*pr_pop*abs(pr_wzdl)+Y_vv*pr_pop*abs(pr_pop)+L*Y_ru*pk_r*abs(pr_wzdl)+L*L*Y_rr*pk_r*abs(pk_r)+L*Y_vr*pr_pop*abs(pk_r)+L*Y_rv*pk_r*abs(pr_pop));
RZ_k=-i_zz*przysp_katowe_r+0.5*ro_w*L^3*(N_vu*pr_pop*abs(pr_wzdl)+N_vv*pr_pop*abs(pr_pop)+L*N_ru*pk_r*abs(pr_wzdl)+L*L*N_rr*pk_r*abs(pk_r)+L*N_vr*pr_pop*abs(pk_r)+L*N_rv*pk_r*abs(pr_pop));
%skladowe  wiatru 
u_wr=-pr_wzdl-v_a*cos(gamma_r-kurs_r); 
v_wr= pr_pop- v_a*sin(gamma_r-kurs_r);
beta_ra= atan(v_wr/u_wr); % kierunek wiatru pozornego
V_wr=sqrt(u_wr^2+v_wr^2);
pow_dziob= 2.82;%*24*24;
pow_boczna= 8.46;%*24*24;
RX_a=0.5*ro_a*V_wr*V_wr*pow_dziob*(-0.7*cos(beta_ra)-0.1);
RY_a=0.5*ro_a*V_wr*V_wr*pow_boczna*(-0.7*sin(beta_ra));
RZ_a=0.5*ro_a*V_wr*V_wr*pow_boczna*L*sign(beta_ra)*(-0.00000018834* (abs(beta_ra))^3+0.00000039325* (beta_ra)^2- 0.00091425*abs(beta_ra));
%skladowe od sruby

u_p=pr_wzdl*(1-0.3);
wspolczynnik=0.23-1.03 * (u_p/(0.7*pi*n*srednica))*pi/180; % dla pierwszej cwiartki
T_prop=0.5*ro_w*(u_p^2 + (0.7*pi*n*srednica)^2)*0.25*pi*srednica^2* wspolczynnik ;% wspolczynnik jest funkcja 
u_al=8*T_prop/(ro_w*n*srednica^2* pi);
t=0.5*C_B-0.12;
RX_p=(1-t)*T_prop; 
RY_p =0.04*RX_p;
%RY_p=0;
RZ_p= 0.49 *L* RY_p;
%RZ_p=0;
%skladowe od steru , od rodzaju statku tylko wspolczynniki a i b
if wych_steru_r > 10*pi/180
k_rudx= 1.5*cot(wych_steru_r-6.5*pi/180)-1.7; %% w zaleznosci od kata wychylenia steru: do i od 10stopni, czy plus czy minus %% tu dla wiecej ni¿ 10stopni
else
    if wych_steru_r > -10*pi/180
k_rudx=-40.55*abs(wych_steru_r) +30.43;
    else
k_rudx= 1.5*cot(wych_steru_r-6.5*pi/180)-1.2;
    end
end 
k_rudy= 0.6;
k_rudn= 1.4;
h_rud= wys_steru; % wysokosc steru
c_rud= 0.3; % ciêciwa steru na oko
u_rud=sqrt(0.77*(u_p+0.7*u_al)^2 +0.23^u_p*u_p);
v_rud= pr_pop-0.5*pk_r*L;
beta_rud=-atan(v_rud/u_rud);
pow_steru=0.127;%116.8; % wielkosc na 1,75*L*T
F_rud=0.5* ro_w * pow_steru *u_rud^2*(6.13 *h_rud/ c_rud)/(h_rud/ c_rud+ 2.25)*sin(wych_steru_r);
a_H=0.176;
poprawka=0.12373*(pk_r)^7+0.00214*(pk_r)^6-1.6099*(pk_r)^5-0.021*(pk_r)^4+7.6595*(pk_r)^3+0.41024*(pk_r)^2-12.763*pk_r; % delta'' str 229
%delta_ef= wych_steru_r+0.8*beta_rud;
delta_ef= wych_steru_r+0.8*beta_rud+poprawka;
%delta_ef= wych_steru_r+0.8*beta_rud-poprawka;
RX_r=-k_rudx* F_rud * sin(delta_ef);
%RX_r=-k_rudx* F_rud * sin(wych_steru_r);
RY_r= k_rudy*(1+a_H)*F_rud*cos(delta_ef);
%RY_r= k_rudy*(1+a_H)*F_rud*cos(wych_steru_r);
%RY_r=0;
RZ_r= -k_rudn*0.5*L*RY_r;
opory=[opory; RX_k RY_k RZ_k RX_a RY_a RZ_a RX_p RX_r RY_r RZ_r];  % 1-3 kadlub, 4-6 wiatr, 7-sruba, 8-10 ster
 
f=zeros(6,1);
f(1)=x; f(2)=y; f(3)=kurs_r;  f(4)=pr_wzdl; f(5)=pr_pop;f(6)=pk_r;
% w kolejnosci: 1-x,2-y 3-kurs w radianach, 4-pr_katowa,5- pr_wzdluzna, 6- pr_poprzeczna

options=odeset('RelTol',0.0001,'AbsTol', [ 0.0001 0.0001 0.0001 0.0001 0.0001 0.0001]);
 
war_pocz= [f(1) f(2) f(3) f(4) f(5) f(6)];
[t,f]=ode45('rigid', [ts ts+dt], war_pocz, options);% warunek poczatkowy zmienic
[lw lk]=size(f);    
x=f(lw,1); % tu przypisaæ x do ostatniego z obliczonego z ode45
y=f(lw,2);
kurs_r= f(lw,3);

pr_wzdl=f(lw,4);
pr_pop=f(lw,5);
pk_r=f(lw,6);

V=sqrt(pr_wzdl^2+pr_pop^2);
wych_steru_r=masz_ster(nast_steru_r, wych_steru_r,dt);


statek.x=x;
statek.y=y;
statek.kurs=kurs_r*180/pi;
statek.pk=pk_r*180*60/pi;
statek.przysp_katowe=przysp_katowe_r*180*60*60/pi;
statek.pr_wzdl=pr_wzdl;
statek.pr_pop=pr_pop;


statek.wych_steru=wych_steru_r*180/pi;
statek.nast_steru=nast_steru_r*180/pi;
statek.V=V;

statek.dryf=dryf_r*180/pi;
statek.gamma=gamma_r*180/pi;

z=statek;