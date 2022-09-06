clc, clear, close all;
m = load("kvlcc2BodyData");
scale = 320/4.97;
data = scale*m.body;

rows=length(data(:,1));
columns=length(data(1,:));
%column 1 to wysokoœæ Z
%row 1 to d³ugoœæ X
%% POJEDYNCZY PRZEKRÓJ WRÊ¯NICOWY k
k = 33;
figure; hold on
axis equal
xlabel('szerokoœæ [m]')
ylabel('wysokoœæ [m]')
   plot(-data(2:rows,k),data(2:rows,1),'black');
   plot(data(2:rows,k),data(2:rows,1),'black');
hold off
%% PRZEKRÓJ WRÊ¯NICOWY
figure; hold on
axis equal
xlabel('szerokoœæ [m]')
ylabel('wysokoœæ [m]')
xlim([-30 30])
ylim([0 30])
for section=2:20
   plot(-data(2:rows,section),data(2:rows,1),'black');
end
for section=20:columns
   plot(data(2:rows,section),data(2:rows,1),'black');
end
hold off
%% KONTUR NA WYSOKOŒCI h
h = rows;
figure; hold on
xlim([-5 320])
axis equal
xlabel('d³ugoœæ [m]')
ylabel('szerokoœæ [m]')
plot(data(1,2:columns),data(h,2:columns),'black');
plot(data(1,2:columns),-data(h,2:columns),'black');
%% 3D
figure; hold on
axis equal
grid on
xlim([-5 320])
ylim([-30 30])
zlim([0 20])
xlabel('d³ugoœæ [m]')
ylabel('szerokoœæ [m]')
zlabel('wysokoœæ [m]')

for section=2:columns
    zData=ones(rows-1);
    zData=data(1,section)*zData;
   plot3(zData,-data(2:rows,section),data(2:rows,1),'black');
   plot3(zData,data(2:rows,section),data(2:rows,1),'black');
end
view(30,15)
