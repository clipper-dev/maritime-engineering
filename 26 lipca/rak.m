% symulacja
function [z]=rak

%wy³¹czenie warningów
warning('off','all')

t_pocz=0;dt=1;t_konc=100;
sk=0;
skk=0;
rk=0;
rkk=0;
wk=0'
wkk=0;
s=0.005;
r=0.003;
w=0;

for ts=t_pocz:dt:t_konc  

sk=skk+s-sk*s;
skk=sk;
rk=rkk+r-rk*r;
rkk=rk;
wk=rk+sk-rk*sk;
wkk=wk;

end 
disp(wkk);
z=1;