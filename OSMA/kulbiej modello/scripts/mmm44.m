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

newSet = betterSet;
for a=1:total
    newSet(5)=set(5)*(1+modifier*(a-total+1));
    for b=1:total
        newSet(6)=set(6)*(1+modifier*(b-total+1));
        for c=1:total
            newSet(7)=set(7)*(1+modifier*(c-total+1));
            for d=1:total
                newSet(8)=set(8)*(1+modifier*(d-total+1));
                for e=1:total
                    newSet(9)=set(9)*(1+modifier*(e-total+1));
                    for f=1:total
                        newSet(10)=set(10)*(1+modifier*(f-total+1));
                        for g=1:total
                            newSet(11)=set(11)*(1+modifier*(g-total+1));
                            for h=1:total
                                newSet(12)=set(12)*(1+modifier*(h-total+1));
                                for i=1:total
                                    newSet(13)=set(13)*(1+modifier*(i-total+1));
                                    for j=1:total
                                        newSet(14)=set(14)*(1+modifier*(j-total+1));
                                        for k=1:total
                                            newSet(15)=set(15)*(1+modifier*(k-total+1));
                                            for l=1:total
                                                newSet(16)=set(16)*(1+modifier*(l-total+1));
                                                
                                                
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
                            end
                        end
                    end
                end
            end
        end
    end
end
newSet = betterSet;


disp("Fini");
