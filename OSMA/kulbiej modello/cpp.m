clc;clear all
file=matfile('nawigatorCPP.mat');
c=file.dane;
wyniki=zeros(10,150);
for i=1:150
    s=(i-1)/100;
   for j=1:8
       if s*s*c(j,2)+s*c(j,3)+c(j,4) >= 0
      wyniki(j,i)= s*s*c(j,2)+s*c(j,3)+c(j,4);
       else
           wyniki(j,i)=0;
       end
   end
   wyniki(9,i)=s;
end
%wykres
figure; hold on; grid on;
for k=1:8
   plot(wyniki(9,:),wyniki(k,:));
end