function error = porownanieBledu3(set1, set2, rudder)
   l=min(length(set1),length(set2)); 
   error = 0;
    for i=1:l
        dif=(set1(i)-set2(i))/set2(i);
        error=error+dif^2;
    end
end