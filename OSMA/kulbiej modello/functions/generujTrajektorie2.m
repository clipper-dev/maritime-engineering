function GTData = generujTrajektorie2(shippy, duration, timeStep, method)
%generujTrajektorie(ship, duration)
%% G£ÓWNA SYMULACJA
GTData = zeros(duration,40);
if true
%% WYLICZENIA SI£
for i=1:duration
   shippy = shippy.calculateMovement(timeStep,method);
   GTData(i,1) = i;
   GTData(i,2) = shippy.x;
   GTData(i,3) = shippy.y;
   GTData(i,4) = shippy.heading*57.3;
   GTData(i,5) = shippy.wznd;
   GTData(i,6) = shippy.driftAngle;
   
   GTData(i,7) = shippy.speed;
   GTData(i,8) = shippy.vx;
   GTData(i,9) = shippy.vy;
   GTData(i,10) = shippy.wz;

   GTData(i,11) = shippy.Acc(1);
   GTData(i,12) = shippy.Acc(2);
   GTData(i,13) = shippy.Acc(3);
   GTData(i,14) = shippy.jj;
   GTData(i,15) = shippy.kt;
   
   GTData(i,16) = shippy.Xhull;
   GTData(i,17) = shippy.Xrudder;
   GTData(i,18) = shippy.Xpropeller;
   GTData(i,19) = shippy.Xair;
   GTData(i,20) = shippy.Xwave;
   GTData(i,21) = shippy.B(1);
   
   GTData(i,22) = shippy.Yhull;
   GTData(i,23) = shippy.Yrudder;
   GTData(i,24) = shippy.Yair;
   GTData(i,25) = shippy.Ywave;   
   GTData(i,26) = shippy.B(2);
   
   GTData(i,27) = shippy.Nhull;
   GTData(i,28) = shippy.Nrudder;
   GTData(i,29) = shippy.Nair;
   GTData(i,30) = shippy.Nwave;
   
%    
%    GTData(i,31) = shipA.apparentAngle;
%    GTData(i,32) = shipA.apparentSpeed;
   
   GTData(i,33) = shippy.h1;
   GTData(i,34) = shippy.h2;
   
   
end
end