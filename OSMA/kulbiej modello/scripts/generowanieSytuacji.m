clc;clear;close all;

a=shipDefault2('nawigator','r');
b=shipDefault2('nawigator','b');
dist=300;
bearing=300;
course=50;

bearingNew=(90-bearing)*pi/180;
b=b.updateShip([dist*sin(bearingNew) dist*cos(bearingNew) 0 0 0 course*pi/180 666 0 0 0 0 0]);

cpaObrys=cpaOutline(a,b,1);
disp(['Pozycja A to P=(' num2str(a.y) ',' num2str(a.x) ').']);
disp(['Pozycja B to P=(' num2str(b.y) ',' num2str(b.x) ').']);
[dist,results]=distanceOutline(a.x,a.y,a.heading,b.x,b.y,b.heading,a,b);
outlineA=drawOutline(a.x,a.y,a.heading,a,1);
outlineB=drawOutline(b.x,b.y,b.heading,b,1);

text = sprintf('Odległość początkowa między punktami = %.1fm,\n odległość początkowa między obrysami = %.1fm,\n odległość minięcia między punktami = %.1fm,\n odległość minięcia między obrysami %.1fm.'...
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


%% do scenariuszy
if a.name=='nawigator'
    wynik(1)=1;
elseif a.name=='kcs'
    wynik(1)=2;    
elseif a.name=='kvlcc2'
    wynik(1)=3;
end
wynik(2)=a.y;
wynik(3)=a.x;
wynik(4)=a.heading*57.3;
wynik(5)=666;
if b.name=='nawigator'
    wynik(6)=1;
elseif b.name=='kcs'
    wynik(6)=2;    
elseif b.name=='kvlcc2'
    wynik(6)=3;
end
wynik(7)=b.y;
wynik(8)=b.x;
wynik(9)=b.heading*57.3;
wynik(10)=666;