function bledy = porownanieBledu(setInitial, setNew, relative)
    %relative = true, absolute = false
   l = min(length(setInitial),length(setNew));
   for i=1:l
      if relative
         bledy(i)=100*(setNew(i)-setInitial(i))/setInitial(i);
      else
         bledy(i)=setNew(i)-setInitial(i);
      end
   end
end