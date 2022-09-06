
function dy=rigid(t,f) %,RY_k, ro_a,W,v_a,gamma_r,V,RY_r,RZ_k,L,RZ_r,sr_ciezk,RX_k,RX_r,m,moment)
global RY_k RY_p  RX_p RY_r RZ_k RZ_r RZ_p RX_k RX_r RX_a RY_a RZ_a m moment % ro_a W v_a gamma_r V L

dy=zeros(6,1); % wektor tych 6 
dy(1)=f(5)*cos(f(3))-f(6)*sin(f(3));
dy(2)=f(5)*sin(f(3))+f(6)*cos(f(3));
dy(3)= f(4);

dy(4)=((RX_k+RX_a+RX_r+RX_p)/m)+f(5)*f(6);
dy(5)=((RY_k+RY_a+RY_r+RY_p)/m)-f(4)*f(6);
dy(6)=(RZ_k+RZ_a+RZ_r+RZ_p)/moment;



end

