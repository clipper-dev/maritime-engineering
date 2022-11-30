function ocena = ocenaTrajektorii(rudder,OTData, wzndCoeff)
time = length(OTData(:,1));
vx = OTData(time,8);
vy = OTData(time,9);
wz= OTData(time,10)*wzndCoeff;
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
ocena = [rudder vx vy wz advance transfer tacticalDiameter];
end