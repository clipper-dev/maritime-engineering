function c = rysujWykresyWiele(bezWymiarowo, data, ships, outlines, offset)
n=length(ships)
time = length(data(1,:,1))
f1 = figure('Name',"Trajektorie statków");grid on; hold on; axis equal;
if bezWymiarowo==true
   xlabel('X/L [-]') 
   ylabel('Y/L [-]') 
else    
   xlabel('X [m]') 
   ylabel('Y [m]') 
end
for s=1:n
   %%iteracja po statkach
   if bezWymiarowo==true
        scale=ships(s).length; 
    else
        scale=1;
   end    
   plot(data(s,:,3)/scale,data(s,:,2)/scale,ships(s).colour);
   legendInfo{s}=[ships(s).name];
   
end
for s=1:n
    if bezWymiarowo==true
        scale=ships(s).length; 
    else
        scale=1;
   end 
   if outlines == 1           
        for i=1:time
           if mod(i,offset)==0               
               outline=drawOutline(data(s,i,3),data(s,i,2),data(s,i,4),ships(s).length,ships(s).breadth,scale);
               plot(outline(:,1),outline(:,2),ships(s).colour);
               plot(data(s,i,3)/scale,data(s,i,2)/scale,'+','LineWidth',2,'MarkerSize',10,'MarkerEdgeColor',ships(s).colour);
           end
        end
        elseif outlines == 2
           done = 0;
           offset=offset/57.3;
           for i=1:time
               check = (data(s,i,4) - offset*done) > (offset);
               if check == true
                   done = done + 1;
               outline=drawOutline(data(s,i,3),data(s,i,2),data(s,i,4),ships(s).length,ships(s).breadth,scale);
               plot(outline(:,1),outline(:,2),ships(s).colour);
               plot(data(s,i-1,3)/scale,data(s,i-1,2)/scale,'+','LineWidth',2,'MarkerSize',10,'MarkerEdgeColor',ships(s).colour);
           end
        end 
    end 
end
legend(legendInfo);hold off
end