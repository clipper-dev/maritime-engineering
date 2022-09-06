clc; clear all;
scalanie

figure; hold on; axis equal; grid on
for i=1:4
   plot(trajectoriesXY(1:130,2*i-1)/55,trajectoriesXY(1:130,2*i)/55);
end
