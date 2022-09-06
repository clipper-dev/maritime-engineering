%% MAJSTROWANIE WYKRES�W
% pr�dko�� vx
f1 = figure('Name','Pr�dko�� post�powa');grid on
movegui(f1,[50,800]);
hold on
plot(dataModel(:,8));
plot(dataExp(:,8));
legend('u_m_o_d_e_l', 'u_e_x_p');
hold off

% k�t dryfu
f2 = figure('Name','Pr�dko�� wzd�u�na');grid on
movegui(f2,[650,800]);
hold on
plot(dataModel(:,9));
plot(dataExp(:,9));
legend('v_m_o_d_e_l', 'v_e_x_p');
hold off

% pr�dko�� wznd
f3 = figure('Name','Pr�dko�� k�towa');grid on
movegui(f3,[1250,800]);
hold on
plot(dataModel(:,5));
plot(dataExp(:,5));
legend('wznd_m_o_d_e_l', 'wznd_e_x_p');
hold off
% trajektorie
f4 = figure('Name','Pr�dko�� k�towa');grid on
movegui(f4,[1850,800]);
hold on
plot(dataModel(:,2),dataModel(:,3));
plot(dataExp(:,2),dataExp(:,3));
legend('traj_m_o_d_e_l', 'traj_e_x_p');
hold off
disp("Wykresy fini");