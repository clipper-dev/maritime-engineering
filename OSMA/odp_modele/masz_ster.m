%% inicjowanie wartosci pocz wektora stanu statku
function[y]=masz_ster(n_s, w_s,d_t)
v_steru=4*pi/(180*60);     % predkosc zmiany steru stopnie/s
max_ws=35*pi/180;
rws=(n_s-w_s);
if abs(rws)>0.001
    przyrost = min(abs(rws), v_steru*d_t);
    nws= w_s+sign(rws)*przyrost;
    if abs(nws)>max_ws
     nws=sign(nws)*35*pi/180;
    end
    w_s=nws;
end
y=w_s;