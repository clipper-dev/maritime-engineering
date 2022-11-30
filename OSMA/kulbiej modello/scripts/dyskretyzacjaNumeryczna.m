size=100;
scale=2;
results=zeros(10,size);

%oryginalny
for i=1:size
    results(1,i)=i/scalep
%     results(2,i)=results(1,i)^3;
end
%euler explicit
for i=2:size
    results(3,i)=results(3,i-1)+fun(results(1,i-1),results(3,i-1))/scale;
end
%runge-kutta 2nd order
for i=2:size
    k1 = fun(results(1,i-1),results(5,i-1))/scale;
    k2 = fun(results(1,i-1)+1/scale,results(5,i-1)+k1)/scale;
    results(5,i)=results(5,i-1)+0.5*(k1+k2);
end
%runge-kutta 4th order
for i=2:size
    k1 = fun(results(1,i-1),results(6,i-1))/scale;
    k2 = fun(results(1,i-1)+0.5/scale,results(6,i-1)+k1)/scale;
    k3 = fun(results(1,i-1)+0.5/scale,results(6,i-1)+k2)/scale;
    k4 = fun(results(1,i-1)+1/scale,results(6,i-1)+k3)/scale;
    results(6,i)=results(6,i-1)+(k1+2*k2+2*k3+k4)/6;
end
%plotting
figure;grid on; hold on
plot(results(1,:),results(3,:));
plot(results(1,:),results(5,:));
plot(results(1,:),results(6,:));
results(3,size)
results(5,size)
results(6,size)
legend('euler ex','runge-kutta 2nd order','runge-kutta 4th order');

function f=fun(x,y)
    f=0.2*x+sqrt(y);
end
