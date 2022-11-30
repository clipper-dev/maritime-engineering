function ocena = ocenaTrajektoriiND(rudder,OTData, time, length, speed,predkoscWaga, odlegloscWaga)
%function ocena = ocenaTrajektoriiND(rudder,OTData, time, length, speed,predkoscWaga, odlegloscWaga)
%time = length(OTData(:,1));
vx = OTData(time,8);
vy = OTData(time,9);
wznd= OTData(time,5);
transfer = 9999;
advance = 9999;
tacticalDiameter = 9999;
for i=1:time
   if OTData(i,4) > 90
       transfer = OTData(i,2);
       advance = OTData(i,3);
       break;
   end
end

for i=1:time
   if OTData(i,4) > 180
       tacticalDiameter = OTData(i,2);
       break;
   end
end
ocena = [rudder predkoscWaga*vx/speed predkoscWaga*vy/speed predkoscWaga*wznd odlegloscWaga*advance/length odlegloscWaga*transfer/length odlegloscWaga*tacticalDiameter/length];
end