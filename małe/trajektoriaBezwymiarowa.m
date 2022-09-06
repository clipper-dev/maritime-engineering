close all; clc; clear
w0=0.6;
beta=25/57.3;
t0=2;tw=2;
timeScale = .1;
x=zeros(20/timeScale,1);
y=zeros(20/timeScale,1);
funX = @(p) cos(w0*p-w0*tw+w0*tw*exp(-p/tw)-beta*(1-exp(-p/t0)));
funY = @(p) sin(w0*p-w0*tw+w0*tw*exp(-p/tw)-beta*(1-exp(-p/t0)));
for i=1:20/timeScale
    t=(i-1)*timeScale;
    x(i)=integral(funX,0,t);
    y(i)=integral(funY,0,t);
end
figure
plot(y,x);
legend('trajektoria statku')
xlabel('Y/L');
ylabel('X/L');
axis equal; grid on;