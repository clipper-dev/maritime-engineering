close all;clc
n = zeros(120,1);
kQ = zeros(120,1);
kT = zeros(120,1);
j=zeros(120,1);
for i=1:120
    j(i)=i/100;
   kT(i)=0.4-0.2*(i/100)-0.15*(i/100)^2;
   kQ(i)=0.5-0.2*(i/100)-0.2*(i/100)^2;
   n(i)=0.0-0.1*(i/100)+5*(i/100)^2-4.5*(i/100)^3; 
end
figure
ylim([0 1])
grid on;
hold on;
plot(j,kT, 'LineWidth',1)
plot(j,kQ,'LineWidth',1)
plot(j,n,'LineWidth',1)
xlabel('J')
ylabel('K_T, 10*K_Q, \eta')
legend('K_T','K_Q','\eta')