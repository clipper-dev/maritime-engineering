
function[y]=def_st
%% dynamika - parametry
tm=48.5; km=0.1232;
%a3=0; 
a2=-0.18571;
a1=-0.20514; 
a0=0.34226;
V_w=12;

def_statku.V=V_w*1852/3600;     % m/s
def_statku.pr_wzdl=def_statku.V;
def_statku.pr_pop=0;
def_statku.x=0;                 % m    
def_statku.y=0;                 % m
def_statku.kurs=0; % stopnie
def_statku.kurs_r=0;  % radiany
def_statku.pk=0;                % stopnie/min - predkosc katowa (r)
def_statku.przysp_katowe=0;     %stopnie /min^2
def_statku.przysp_wzdl=0;
def_statku.przysp_pop=0;

def_statku.a=[a0 a1 a2];     % stale do wielomiaru od sruby
def_statku.tm=tm   ;           % stala
def_statku.km=km    ;           % stala
def_statku.wych_steru=0;       % stopnie
def_statku.nast_steru=0;        % stopnie
def_statku.dryf= 0   ;          %dryf w stopniach


% parametry statk3u
 

def_statku.L=330.65;              %dlugosc w metrach
def_statku.B=57         ;       %szerokosc w metrach
def_statku.D=20.6         ;      %zanurzenie w metrach
def_statku.W= 176600000     ;       %wypornosc w kg (nosnosc++masa pustego)

def_statku.H=28.437 ; % wysokosc nad woda* wposlczynnik do powierzcni nawiewu

%sta?e wielkosci potrzebne do obliczen
 def_statku.ro_a=1.168 ;% gestosc powietrza w kg/m3 w warunkach 25st i cisnienie 1013
 def_statku.ro_w= 1000 ;% gestosc wody
 
 
 def_statku.gamma=0; %kierunek geograficzny wiatru
 def_statku.v_a= 0; % predkosc wiatru w m/s
 def_statku.C_B= 0.83; % wspolczynnik pelnotliwosci podwodzia
 def_statku.C_M = 0.98; % wspolczynnik pelnotliwosci owr?za
 def_statku.srednica=4.55; % srednica sruby w metrach
 def_statku.n= 2.6; % ilosc obrotow sruby nba sekunde
 def_statku.wys_steru=1.695; % wysokosc steru srednia dla typu statku - tu masowiec
 
 def_statku.a_ster=4.252; % wspolczynniki a i b od steru w zaleznosci od rodzaju statku masowiec
 def_statku.b_ster=0.262;
 L=def_statku.L;
 B=def_statku.B;

 
 def_statku.m= def_statku.ro_w*def_statku.C_B*L*B*def_statku.D; %masa netto w kg

 def_statku.moment=1.4*(0.055*def_statku.C_B+0.029)*L*L*def_statku.m;
 
 def_statku.f=[ 0 0 0 def_statku.V 0  0];
 
 y=def_statku;