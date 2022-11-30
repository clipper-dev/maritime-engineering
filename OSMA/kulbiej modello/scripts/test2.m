% wczytanie z pliku
clc;
%% wczytanie
sv = matfile("wyniki/"+"liniowe.mat");
sv2 = matfile('wzorzecND.mat');
sv3 = matfile("wyniki/"+"ym.mat");
w = sv3.finalSet;

%% strojenie rêczne
close all
duration = 1000;
aData = zeros(3,duration,40);
pogoda = weather(45,20,270,0.5,0.5);
vessel = shipLoad2("nawigator",100,0,0,0,0,180,6,0,0,0,0,0,pogoda);
sv = matfile("strojenieWynik.mat");
aData(1,:,:) = generujTrajektorie("nawigator",100,35,duration,5.911,true,sv.finalSet,0,pogoda);
zestawy = {'best'};
for i = 2:length(zestawy)    
    sv = matfile("wyniki/"+zestawy(i)+".mat");
    aData(i,:,:) = generujTrajektorie("nawigator",100,35,duration,5.911,true,sv.finalSet,0,pogoda);
end
aData(i+1,:,:) = generujTrajektorie("nawigator",100,35,duration,5.911,true,f,0,pogoda);
rysujWykresyMulti(zestawy,aData,vessel,1,1,90,1,1,1,0);
