clear; clc; close all;
%% OBRÓBKA I PRZYGOTOWANIE DANYCH
% WCZYTANIE DANYCH Z PLIKU
port = loadTide("HEYSHAM");
lll = length(port);
% PIERWSZE CZYTANIE
for i=1:lll
    if port(i,2) == ""
        port(i,2) = port(i-1,2);
    end
end
% DRUGIE CZYTANIE
for i=1:lll
    try
       if port(i,3) == "" 
          port(i,:) = []; 
       end
    end
end
% TRZECIE CZYTANIE
lll = length(port);
heights = zeros(lll,1);
times = datetime(zeros(lll,1), 0, 0); 
for i=1:lll
   date = double(split(port(i,2),'/'));
   hours = double(split(port(i,3),':'));
   heights(i) = str2double(port(i,5));
   times(i) = datetime(date(3),date(2),date(1),hours(1),hours(2),0);
end
% CZWARTE CZYTANIE
[times,sortIdx] = sort(times,'descend');
heights = heights(sortIdx);
%% WYGENEROWANIE MODELU
determiner = mean(heights);
heights2 = zeros(lll,1);
lows = [0]; highs = [0];
for i=1:lll
    if heights(i) > determiner
        % high water
        lows(end+1,1) = heights(i);
    else
        highs(end+1,1)= heights(i);
    end
end
for i=1:lll-1
   times2(i,1) = between(times(i+1),times(i));
end
%% WYŒWIETLANIE DANYCH
plot(highs)
% f = figure;
% hold on
% plot(times,heights)
% plot(times,heights2)
% hold off
% legend('data','model');
%% EXODUS
display('Fini.');