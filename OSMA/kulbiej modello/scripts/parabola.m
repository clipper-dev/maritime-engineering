clc
%generowanie parboli z trzech punktów
x=[0.0485 0.5 0.8];
y=[0.51 0.279 0.127];

Y=[y(1); y(2); y(3)];
X=[x(1)^2 x(1) 1;x(2)^2 x(2) 1;x(3)^2 x(3) 1];
X2=inv(X);
wyniki=X2*Y