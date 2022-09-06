clc;clear;close all;

[a,b]=navigationalSituation(25);

cpaObrys=cpaOutline(a,b,1);
disp(['Pozycja A to P=(' num2str(a.x) ',' num2str(a.y) ').']);
disp(['Pozycja B to P=(' num2str(b.x) ',' num2str(b.y) ').']);
[dist,results]=distanceOutline(a.x,a.y,a.heading,b.x,b.y,b.heading,a,b);
outlineA=drawOutline(a.x,a.y,a.heading,a,1);
outlineB=drawOutline(b.x,b.y,b.heading,b,1);

text = sprintf('Odległość początkowa między punktami = %.1fm, odległość początkowa między obrysami = %.1fm, odległość minięcia między punktami = %.1fm, odległość minięcia między obrysami %.1fm'...
    , distance(a,b),dist,cpa(a,b),cpaObrys);
disp(text);
% figura i ustawienia
figure;hold on;axis equal;grid on;
xlabel('Y [m]');
ylabel('X [m]');
% sylwetki w momencie najwiekszego zblizenia
h1=plot(outlineA(:,1),outlineA(:,2),a.colour);
h2=plot(outlineB(:,1),outlineB(:,2),b.colour);
plot(results(:,2),results(:,1),'k');

x = [0.5 0.25];
y = [0.2 0.15];
text = sprintf('V = %.2fm/s, kurs = 00%.1f°', a.speed,a.heading*57.3);
annotation('textarrow',x,y,'String',text);

x = [0.6 0.75];
y = [0.9 0.92];
text = sprintf('V = %.2fm/s, kurs = %.1f°', b.speed,b.heading*57.3);
annotation('textarrow',x,y,'String',text);

x = [0.4 0.45];
y = [0.6 0.5];
text = sprintf('d_o_b_r_y_s = %.1fm, CPA_o_b_r_y_s = %.1fm', dist,cpaObrys);
annotation('textarrow',x,y,'String',text);

legend([h1(1), h2(1)], 'statek własny','statek obcy');