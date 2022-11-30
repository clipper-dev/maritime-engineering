function hydroSet = hydroSetYM(ship)
s=ship.length/ship.breadth;
k=2*ship.draught/ship.length;
hydroSet(1)=ship.cB*1.15/s-0.18;
hydroSet(2)=-1.91*ship.cB/s+0.08;
hydroSet(3)=-0.085*ship.cB/s+0.008;
hydroSet(4)=-6.68*ship.cB/s+1.1;
hydroSet(5)=0.5*3.14*k+1.4*ship.cB/s; %Yv
hydroSet(6)=0.5*ship.cB/s; %Yr
hydroSet(7)=0.185*s+0.48; %Yvvv
hydroSet(8)=-0.051; %Yrrr
hydroSet(9)=0.26*(1-ship.cB)/s+0.11; %Yvrr
hydroSet(10)=-0.75; %Yvvr
hydroSet(11)=k; %Nv
hydroSet(12)=-0.54*k+k^2; %Nr
hydroSet(13)=-0.69*ship.cB+0.66; %Nvvv
hydroSet(14)=0.25*ship.cB/s-0.056; %Nrrr
hydroSet(15)=1.55*ship.cB/s-0.76; %Nvvr
hydroSet(16)=-0.075*(1-ship.cB)*s-0.098; %Nvrr
end

