function c = rysujWykresyMulti(podpisy, tablica, shipA, trajektoria, sylwetki, coIle, predkosci, ...
    silyY, momentyN, rudder)

time = length(tablica(1,:,1));
d = length(tablica(:,1,1));
if trajektoria == true
    f1 = figure('Name',"Trajektoria statku " + shipA.name);grid on
    movegui(f1,[50,800]);
    hold on
    for l = 1:d
       plot(tablica(l,:,2),tablica(l,:,3));
    end
    
    for l = 1:d
    axis equal;
        if sylwetki == 1
           
        for i=1:time
           if mod(i,coIle)==0
               outline = zeros(6,2);
               angle = (360 - tablica(l,i,4))/57.3;% + atan(dejDane(i,9)/dejDane(i,8));
               %P1
               outline(1,1)=tablica(l,i,2)...
                   -0.4*shipA.length*sin(angle)-0.5*shipA.breadth*cos(angle);
               outline(1,2)=tablica(l,i,3)...
                   +0.4*shipA.length*cos(angle)-0.5*shipA.breadth*sin(angle);
               %P2 - dziób
               outline(2,1)=tablica(l,i,2)-0.5*shipA.length*sin(angle);
               outline(2,2)=tablica(l,i,3)+0.5*shipA.length*cos(angle);
               %P3
               outline(3,1)=tablica(l,i,2)...
                   -0.4*shipA.length*sin(angle)+0.5*shipA.breadth*cos(angle);
               outline(3,2)=tablica(l,i,3)...
                   +0.4*shipA.length*cos(angle)+0.5*shipA.breadth*sin(angle);
               %P4
               outline(4,1)=tablica(l,i,2)...
                   +0.4*shipA.length*sin(angle)+0.5*shipA.breadth*cos(angle);
               outline(4,2)=tablica(l,i,3)...
                   -0.4*shipA.length*cos(angle)+0.5*shipA.breadth*sin(angle);
               %P5
               outline(5,1)=tablica(l,i,2)...
                   +0.4*shipA.length*sin(angle)-0.5*shipA.breadth*cos(angle);
               outline(5,2)=tablica(l,i,3)...
                   -0.4*shipA.length*cos(angle)-0.5*shipA.breadth*sin(angle);
               %P1 jeszcze raz ¿eby zamkn¹æ krzyw¹
               outline(6,1)=outline(1,1);
               outline(6,2)=outline(1,2);
               plot(outline(:,1),outline(:,2));
           
           end
        end
        elseif sylwetki == 2
           done = 0;    
           for i=1:time
               
               check = (tablica(l,i,4) - coIle*done) > (coIle - 0.5);
           if check == true
               tablica(l,i,4) - coIle*done;
            done = done + 1;
               outline = zeros(6,2);
               angle = (360 - tablica(l,i,4))/57.3;
               %P1
               outline(1,1)=tablica(l,i,2)...
                   -0.4*shipA.length*sin(angle)-0.5*shipA.breadth*cos(angle);
               outline(1,2)=tablica(l,i,3)...
                   +0.4*shipA.length*cos(angle)-0.5*shipA.breadth*sin(angle);
               %P2 - dziób
               outline(2,1)=tablica(l,i,2)-0.5*shipA.length*sin(angle);
               outline(2,2)=tablica(l,i,3)+0.5*shipA.length*cos(angle);
               %P3
               outline(3,1)=tablica(l,i,2)...
                   -0.4*shipA.length*sin(angle)+0.5*shipA.breadth*cos(angle);
               outline(3,2)=tablica(l,i,3)...
                   +0.4*shipA.length*cos(angle)+0.5*shipA.breadth*sin(angle);
               %P4
               outline(4,1)=tablica(l,i,2)...
                   +0.4*shipA.length*sin(angle)+0.5*shipA.breadth*cos(angle);
               outline(4,2)=tablica(l,i,3)...
                   -0.4*shipA.length*cos(angle)+0.5*shipA.breadth*sin(angle);
               %P5
               outline(5,1)=tablica(l,i,2)...
                   +0.4*shipA.length*sin(angle)-0.5*shipA.breadth*cos(angle);
               outline(5,2)=tablica(l,i,3)...
                   -0.4*shipA.length*cos(angle)-0.5*shipA.breadth*sin(angle);
               %P1 jeszcze raz ¿eby zamkn¹æ krzyw¹
               outline(6,1)=outline(1,1);
               outline(6,2)=outline(1,2);
               plot(outline(:,1),outline(:,2));
           end
            end 
        end
     
    end
    
    legend(podpisy);
    hold off
end
if predkosci == true
    f2 = figure('Name','Prêdkoœci');grid on
    movegui(f2,[650,800]);
    hold on
    for l=1:d
        plot(tablica(l,:,7)); 
    end
    legend(podpisy);
    hold off
end

c = true;
end