
function dy=rigid(t,f) %,RY_k, ro_a,W,v_a,gamma_r,V,RY_r,RZ_k,L,RZ_r,sr_ciezk,RX_k,RX_r,m,moment)
global RY_k RY_p  RX_p RY_r RZ_k RZ_r RZ_p RX_k RX_r RX_a RY_a RZ_a m moment %ro_w D ro_a W v_a gamma_r V L m_x X_uu X_vr X_rr X_vv 

dy=zeros(6,1); % wektor tych 6 
dy(1)=f(4)*cos(f(3))-f(5)*sin(f(3));
dy(2)=f(4)*sin(f(3))+f(5)*cos(f(3));
dy(3)= f(6);


%dy(4)=(0.5*ro_w*L*D*(X_uu*f(4)*abs(f(4))+X_vr*f(5)*f(6)+X_vv*(f(5))^2+L^2*X_rr*f(6)*f(6))+ RX_a+RX_r+RX_p +m*f(5)*f(6))/(m+m_x);

dy(4)=((RX_k+RX_a+RX_r+RX_p)/m)+f(5)*f(6);
dy(5)=((RY_k+RY_a+RY_r+RY_p)/m)-f(4)*f(6);
dy(6)=(RZ_k+RZ_a+RZ_r+RZ_p)/moment;

%if t>10
%    pause
%end

end

