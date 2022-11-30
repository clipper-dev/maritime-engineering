clc;clear;number=1;
v=shipDefault("kcs",666,0,100,35);
%% settings
set=v.hydroSet;
surfaceX=zeros(101,101);
surfaceY=zeros(101,101);
surfaceN=zeros(101,101);
xV=zeros(201,1);
yR=zeros(201,1);
for i=1:101
    xV(i)=(i-51)/100;
    yR(i)=(i-51)/100;
end
for vv=1:101
    v=(vv-51)/100;
    for rr=1:101
        r=(rr-51)/100;
        surfaceX(vv,rr)=set(1)*v^2 + set(2)*v*r+set(3)*r*r+set(4)*v^4;
        surfaceY(vv,rr)=set(5)*v+set(6)*r+set(7)*v*v*v+set(8)*r*r*r+...
            set(9)*v*r*r+set(10)*v*v*r;
        surfaceN(vv,rr)=set(11)*v+set(12)*r+set(13)*v*v*v+set(14)*r*r*r+...
            set(15)*v*r*r+set(16)*v*v*r;
    end
end
%% surface plot

f1=figure;
movegui(f1,[100+600*0,number*600+100]);
[X,Y] = meshgrid(-0.5:0.01:0.5,-0.5:0.01:0.5);
s=surf(X,Y,surfaceX);
s.EdgeColor = 'none';
colorbar
xlabel("r' [-]")
ylabel("v' [-]")
zlabel("X'_H_U_L_L")
view([130 30])

f2=figure;
movegui(f2,[100+600*1,number*600+100]);
[X,Y] = meshgrid(-0.5:0.01:0.5,-0.5:0.01:0.5);
s=surf(X,Y,surfaceY);
s.EdgeColor = 'none';
colorbar
xlabel("r' [-]")
ylabel("v' [-]")
zlabel("Y'_H_U_L_L")
view([130 30])

f3=figure;
movegui(f3,[100+600*2,number*600+100]);
[X,Y] = meshgrid(-0.5:0.01:0.5,-0.5:0.01:0.5);
s=surf(X,Y,surfaceN);
s.EdgeColor = 'none';
colorbar
xlabel("r' [-]")
ylabel("v' [-]")
zlabel("N'_H_U_L_L")
view([130 30])
%% 