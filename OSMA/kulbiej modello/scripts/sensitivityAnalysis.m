%% STATYCZNE
clc; close all; clear
% statek i zestaw hydro
xx2=matfile('ym.mat');
set=xx2.finalSet;
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
indices=generowanieWskaznikow(set,s);
% KONIEC STATYCZNYCH
sensitivity=zeros(16,6);
%% DYNAMICZNE
tic
for hydro=1:16
    newSet = set; %przywracanie do wyjsciowego
    newSet(hydro)=set(hydro)*1.2;
    newIndices=generowanieWskaznikow(newSet,s);
    error=porownanieBledu(newIndices,indices,true);
    index = set(hydro)/(newSet(hydro)-set(hydro));
    for j=1:6
        sensitivity(hydro,j)=error(j)/100;
    end
end
toc
captions={'%u_s_t_a_b_l_e','%v_s_t_a_b_l_e','%r_s_t_a_b_l_e','%Ad','%Td','%D_s_t_a_b_l_e'};
hydros = categorical({'X_v_v','X_v_r','X_r_r','X_v_v_v_v','Y_v','Y_r','Y_v_v_v','Y_r_r_r','Y_v_r_r','Y_v_v_r','N_v','N_r','N_v_v_v','N_r_r_r','N_v_v_r','N_v_r_r'});
hydros = reordercats(hydros,{'X_v_v','X_v_r','X_r_r','X_v_v_v_v','Y_v','Y_r','Y_v_v_v','Y_r_r_r','Y_v_r_r','Y_v_v_r','N_v','N_r','N_v_v_v','N_r_r_r','N_v_v_r','N_v_r_r'});
choice=6;
b=bar(hydros,sensitivity(:,choice),0.1);
legend(captions(choice));
xlabel("Hydrodynamic derivative");
ylabel("Sensitivity [-]");
disp("Fini");
