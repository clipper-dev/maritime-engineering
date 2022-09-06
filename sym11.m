% symulacja
function [z]=sym11

%wy³¹czenie warningów
warning('off','all')

global  ts  opory

t_pocz=0;dt=10;t_konc=5000;

statek1=def_st;
dane_sym=inicj_danych(statek1,t_pocz);
opory=zeros(1,10);

for ts=t_pocz:dt:t_konc  
  statek1=wyniki(statek1,ts,dt); 
  %% pr_wzdluz='f';
  dane_sym=rej_danych(dane_sym,statek1,ts);
  
end 
opory(1,:)=[];
save wyniki dane_sym opory
z=1;