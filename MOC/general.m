% wczytanie pliku tekstowego
load scenBd.txt
what = "d";
%what = "t";
% za³adowanie pliku tekstowego do tablic z danymi, mega proste
% iterowanie
value = scenBd(:,1);
rudder = scenBd(:,2);
time = scenBd(:,3);
step = 71;
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
if what == "d"
    %title('Odleg³oœæ miêdzy statkami w momencie OSM w funkcji zak³adanej odleg³oœci miniêcia');
    legend('100 m','300 m','500 m','700 m','900 m');
    xlabel('odleg³oœæ [m]')
    ylabel('k¹t wychylenia steru [°]')
    ylim([-35 35])
    xlim([1000 5000])
elseif what == "t"
    %title('Czas do momentu rozpoczêcia manewru OSM w funkcji zak³adanej odleg³oœci miniêcia');
    legend('100 m','300 m','500 m','700 m','900 m');
    xlabel('czas [s]')
    ylabel('k¹t wychylenia steru [°]')
    ylim([-35 35])
    xlim([0 260])
    
end
