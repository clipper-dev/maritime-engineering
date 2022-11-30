function error = porownanieBledu2(set1, set2, relative)
   l=min(length(set1),length(set2)); 
   error = 0;
    for i=1:l
        if relative
           dif=(set1(i)-set2(i))/set2(i); 
        else
           dif=set1(i)-set2(i);
        end
        error=error+abs(dif)^2;
    end
end