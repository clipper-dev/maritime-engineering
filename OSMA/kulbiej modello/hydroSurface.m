close all
forceHydroSurface;
[X,Y] = meshgrid(-0.5:0.01:0.5,-0.5:0.01:0.5);
s=surf(X,Y,surfaceN);
s.EdgeColor = 'none';
colorbar
xlabel("r' [-]")
ylabel("v' [-]")
zlabel("N'_H_U_L_L")
view([130 30])