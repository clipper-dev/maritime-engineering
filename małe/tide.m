%13.10.2021 00:00
%14.10.2021 23:59
for i=1:2858
   t(i)= datetime(2021,10,13,00,00,00) + calendarDuration(0,0,0,0,i,0);
end
figure
hold on;
grid on;
plot(t(:),tideData(:,1),'-','LineWidth',1);
plot(t(:),tideData(:,2),'--','LineWidth',1);
plot(t(:),tideData(:,3),'-','LineWidth',1);
legend('Estymacja','Predykcja','Wezbranie')
xlabel('Czas obserwacji')
ylabel('Wysokoœæ p³ywu i wezbrania [m]')