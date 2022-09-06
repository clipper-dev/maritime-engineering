%% STATYCZNE
clc; close all; clear
indices=[1.88 -0.43 0.048 148 120 83];
% statek i zestaw hydro
xx2=matfile('ym.mat');
set=xx2.finalSet;
xx3=matfile('tuneData.mat');
tuneMatrix=xx3.tuneMatrix;
shipVector.isOwnSet = true;
shipVector.ownSet = set;%[-0.061 0.09 -0.0008 0.41 -0.31 0.062 -0.577 -0.051 -0.719 -0.75 -0.105 -0.0457 -0.253 -0.0302 -0.6 -0.274];
steeringVector = [100 35];%maszyna i ster
calculusVector = [1 1 1];
initialStateVector1 = [0 0 0 0 0 0 5.81 0 0 0 0 0];
environmentVector.isWeather = false;
environmentVector.weather = weather(0,0,0,0,0);
environmentVector.isShallow = false;
environmentVector.depth = 100;
s = shipLoad3("nawigator", shipVector, steeringVector, calculusVector, initialStateVector1, environmentVector,'k');
% KONIEC STATYCZNYCH
sensitivity=zeros(16,6);
indicesYM=generowanieWskaznikow(set,s);
%% DYNAMICZNE
total = 11;
multiplier = 0.1;
error0=porownanieBledu2(indicesYM,indices,true);
betterSet = set;
err=error0;
for k=1:6
   for hydro=1:16
       if tuneMatrix(hydro,k)==1
          newSet = set; %przywracanie do wyjsciowego
          
          for i=1:total
              %iterowanie po zmianie konkretnego wskaznika od -X proc do +X proc
              newSet(hydro)=set(hydro)*(2-multiplier*2*(i-1)/(total));
              newIndices=generowanieWskaznikow(newSet,s);
              error=porownanieBledu2(newIndices,indices,true);
              if err > error
                 %lepszy zestaw
                 err = error;
                 betterSet = newSet;
              end
          end
       end
   end
end 
save('finalSet.mat','betterSet');

disp("Fini");
