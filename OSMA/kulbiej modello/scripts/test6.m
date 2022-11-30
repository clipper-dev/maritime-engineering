figure
surf(cpaData-cpaDataOutline,'EdgeColor','None','facecolor', 'interp');
view(2);   
title('V_O = 11.3kt, V_E = 11.3kt');
xlabel(['Względny kurs statku przeciwnego [' char(176) ']']);
ylabel(['Względny początkowy namiar [' char(176) ']']);
axis equal tight 
cb=colorbar;
ylabel(cb,'różnica D_C_P_A[m]');
caxis([0, 100]);
disp("Fini");