%% DANE STATKU
l = 175;
b = 25.4;
d = 9.5;
cB = 0.5721;
k = 2*d/l;
p = d/l;
c = cB*b/l;
%% OBLICZENIA
labels = {'artyszuk','lee'};
hydro = zeros(16,10);
% arcyszuk
hydro(5,1) = 2*(3.14*k/2 + 1.4*cB*b/l);%Yv
hydro(6,1) = 0;%Yr
hydro(11,1) = k; %Nv
hydro(12,1) = 1.5*(-0.5*k+k^2); %Nr
% smitt
hydro(5,2) = -1.25*k^2;%Yv
hydro(6,2) = 0.25*k^2;%Yr
hydro(11,2) = -0.5*k^2; %Nv
hydro(12,2) = -0.001 - 0.16*k^2; %Nr
% yoshimura & masumoto
hydro(1,3) = 1.15*cB*b/l - 0.18; %Xvv
hydro(2,3) = 0.09*c + 0.08; %Xvr
hydro(3,3) = -0.085*cB*b/l + 0.008; %Xrr
hydro(4,3) = -6.68*cB*b/l + 1.1; %Xvvvv
hydro(5,3) = -(0.5*3.14*k + 1.4*c);%Yv
hydro(6,3) = 0.6*c;%Yr
hydro(7,3) = -0.185*l/b + 0.48; %Yvvv
hydro(8,3) = -0.051;
hydro(9,3) = -(0.26*(1-cB)*l/b + 0.11);
hydro(10,3) = -0.75;
hydro(11,3) = -k; %Nv
hydro(12,3) = -0.54*k +k^2; %Nr
hydro(13,3) = -(-0.69*cB + 0.66); %Nvvv
hydro(14,3) = 0.25*c - 0.056; %Nrrr
hydro(15,3) = 1.55*c - 0.76; %Nvvr
hydro(16,3) = -0.075*(1-cB)*l/b - 0.098; %Nvrr
% lee
hydro(1,4) = 0.0011 - 0.1975*(1-cB)*l/b; %Xvv
hydro(2,4) = (2*c + 0.1176*2*c*(0.5*cB))/p; %Xvr
hydro(3,4) = (-0.0027+0.0076*cB*p)/p; %Xrr
hydro(4,4) = 0; %Xvvvv
hydro(5,4) = (-0.4545*d/l + 0.065*cB*b/l)/p;%Yv
hydro(6,4) = (-0.115*cB*b/l + 0.0024)/p;%Yr
hydro(7,4) = (-0.6469*(1-cB)*d/b + 0.0027)/p; %Yvvv
hydro(8,4) = (-0.0233*cB*d/b + 0.0063)/p;
hydro(9,4) = -(0.4346*(1-cB)*d/l)/p;
hydro(10,4) = (0.1234*cB*d/b - 0.001452)/p;
hydro(11,4) = (-0.23*p + 0.0059)/p; %Nv
hydro(12,4) = (-0.003724 + 0.10446*d/l - 1.393*p^2)/p; %Nr
hydro(13,4) = (0.0348-0.5283*(1-cB)*d/b)/p; %Nvvv
hydro(14,4) = (-0.0572 + 0.03*cB*d/l)/p; %Nrrr
hydro(15,4) = (-1.722+22.997*(cB*b/l)-77.268*(cB*b/l)^2)/p; %Nvvr
hydro(16,4) = (-0.0005 + 0.00594*cB*d/b)/p; %Nvrr
%%
