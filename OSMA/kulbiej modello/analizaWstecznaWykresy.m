%% MAJSTROWANIE WYKRESÓW
% si³y X
f1 = figure('Name','Si³y X');grid on
movegui(f1,[50,800]);
hold on
plot(AWResistance);
plot(Fhull(:,1));
plot(AWPropeller);
plot(AWRudder(:,1));
legend('resistance', 'hull', 'propeller', 'rudder');
hold off

% si³y Y
f2 = figure('Name','Si³y Y');grid on
movegui(f2,[650,800]);
hold on
plot(Fhull(:,2));
plot(AWRudder(:,2));
plot(AWInertia(:,2));
plot(Fhull(:,2)+AWRudder(:,2)+AWInertia(:,2));
legend('hull', 'rudder', 'inertia','summa');
hold off

% momenty Z
f3 = figure('Name','Momenty Z');grid on
movegui(f3,[1250,800]);
hold on
plot(Fhull(:,3));
plot(AWRudder(:,3));
plot(AWInertia(:,3));
plot(Fhull(:,3)+AWRudder(:,3)+AWInertia(:,3));
legend('hull', 'rudder', 'inertia','summa');
hold off

% prêdkoœci
f4 = figure('Name','Momenty Z');grid on
movegui(f4,[1850,800]);
hold on
plot(vx);
plot(vy);
plot(wz);
legend('vx', 'vy', 'wz');
hold off
disp("Wykresy fini");