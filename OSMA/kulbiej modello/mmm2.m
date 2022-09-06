%% STATYCZNE
indices35=[1.9 -0.43 0.048 2.7 1.3 2.1 2.2 1.2];
indices25=[2.4 -0.60 0.047 3.1 1.6 2.3 2.7 1.8];
indices15=[3.2 -0.70 0.035 3.9 1.8 2.8 3.7 3.3];
% statek i zestaw hydro
xx2=matfile('wynikNowy.mat');
set=xx2.betterSet;
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

%% DYNAMICZNE
zestaw=[1 2 3 4;
    5 6 11 12;
    5 6 7 8;
    5 6 9 10;
    5 11 7 13;
    6 12 8 14;
    11 12 13 14;
    7 8 9 10;
    13 14 15 16;
    11 12 13 16;
    11 12 13 15;
    5 6 7 9;
    5 6 8 10;
    5 6 15 16;
    9 10 11 12];
pos=randi([1 length(zestaw)]);
l1=false;
l2=false;
l3=false;
newSet = betterSet;
for a=1:total
    newSet(zestaw(pos,1))=set(zestaw(pos,1))*(1+modifier*(2*a-total)/(total-1));
   for b=1:total
       newSet(zestaw(pos,2))=set(zestaw(pos,2))*(1+modifier*(2*b-total)/(total-1));
      for c=1:total
          newSet(zestaw(pos,3))=set(zestaw(pos,3))*(1+modifier*(2*c-total)/(total-1));
          
         for d=1:total
             newSet(zestaw(pos,4))=set(zestaw(pos,4))*(1+modifier*(2*d-total)/(total-1));
              
              newIndices35=generowanieWskaznikow(newSet,s,35);
              newIndices25=generowanieWskaznikow(newSet,s,25);
              newIndices15=generowanieWskaznikow(newSet,s,15);
              previousError=error;
              error=3*porownanieBledu2(newIndices35,indices35,wskaznikBezwzgledny)+...
                  2*porownanieBledu2(newIndices25,indices25,wskaznikBezwzgledny)+...
                  porownanieBledu2(newIndices15,indices15,wskaznikBezwzgledny);
              if err > error
                 %lepszy zestaw
                 clc;
                 err = error
                 l1=false;l2=false;l3=false;
                 betterSet = newSet;
                 save('wynikNowy.mat','betterSet');
              elseif prevError < error
                  break;
              end 
         end
      end
   end
end
newSet = betterSet;


disp("Fini");
