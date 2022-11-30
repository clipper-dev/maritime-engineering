figure
surf(cpaDiff,'EdgeColor','None','facecolor', 'interp');
view(2);   
title('V_O = 11.3kt, V_E = 11.3kt');
xlabel(['Względny kurs statku przeciwnego [' char(176) ']']);
ylabel(['Względny początkowy namiar [' char(176) ']']);
axis equal tight 
cb=colorbar;
ylabel(cb,'D_C_P_A różnica[m]');
disp("Fini");