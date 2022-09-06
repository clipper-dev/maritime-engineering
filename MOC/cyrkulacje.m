% wczytanie pliku tekstowego
load cyrkulacje.txt
% za³adowanie pliku tekstowego do tablic z danymi, mega proste
% iterowanie
value = cyrkulacje(:,1);
rudder = cyrkulacje(:,2);
time = cyrkulacje(:,3);
step = 180;
maxIteration = size(value,1);
k = 1;
hold on;
while k -1< maxIteration
    x = time(k:k+step-1);
    y = rudder(k:k+step-1);
    plot(x,y);
    k = k + step;
end
hold off;
axis equal
    %title('Odleg³oœæ miêdzy statkami w momencie OSM w funkcji zak³adanej odleg³oœci miniêcia');
    legend('-35','-30','-25','-20','-15','-10','-5','0','5','10','15','20','25','30','35');
    xlabel('pozycja X [m]')
    ylabel('pozycja Y [m]')
    %ylim([-35 35])
    %xlim([0 5000])
