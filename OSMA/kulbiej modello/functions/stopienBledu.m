function toErrIsHumane = stopienBledu(dataSet1, dataSet2)
SBlength = min(length(dataSet1),length(dataSet2));
toErrIsHumane = 0;
for i = 1:SBlength
   error = dataSet1(i) - dataSet2(i);
   error = error^2;
   toErrIsHumane = toErrIsHumane+error;
end
end