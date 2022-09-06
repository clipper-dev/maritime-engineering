clc;clear all;close all
%% statki
n7=shipDefault("nawigator",666,0,1,0);
kcs=shipDefault("kcs",666,0,1,0);
kvlcc2=shipDefault("kvlcc2",666,0,1,0);

armada=[n7 n7;n7 kcs;n7 kvlcc2;
    kcs n7;kcs kcs;kcs kvlcc2;
    kvlcc2 n7; kvlcc2 kcs;kvlcc2 kvlcc2];

%% operacja
n=9
tic
wyniki = zeros(n,360,360);
parfor i = 1:n
    wyniki(i,:,:)=odlegloscGranicyDokladnosci(armada(1,1),armada(1,2));
end
toc
