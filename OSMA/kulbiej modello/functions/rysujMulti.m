function c = rysujMulti(ships, data, trajektorie,sylwetki, coIle)

n = length(ships);
time = length(data(:,1));
if trajektorie == true
    f1 = figure('Name',"Trajektorie statków");grid on
    movegui(f1,[50,800]);
    hold on
    for i = 1:n
        podpisy(i) = ""+ships(i).name;
        plot(data(:,2+10*(i-1)),data(:,3+10*(i-1)));
    end
    for i = 1:n
    axis equal;
        if sylwetki == true
           
            for t=1:time
                if mod(t,coIle)==0
                   outline = zeros(6,2);
                   angle = (360 - data(t,4+10*(i-1)))/57.3;
                   %P1
                   outline(1,1)=data(t,2+10*(i-1))...
                       -0.4*ships(i).length*sin(angle)-0.5*ships(i).breadth*cos(angle);
                   outline(1,2)=data(t,3+10*(i-1))...
                       +0.4*ships(i).length*cos(angle)-0.5*ships(i).breadth*sin(angle);
                   %P2 - dziób
                   outline(2,1)=data(t,2+10*(i-1))-0.5*ships(i).length*sin(angle);
                   outline(2,2)=data(t,3+10*(i-1))+0.5*ships(i).length*cos(angle);
                   %P3
                   outline(3,1)=data(t,2+10*(i-1))...
                       -0.4*ships(i).length*sin(angle)+0.5*ships(i).breadth*cos(angle);
                   outline(3,2)=data(t,3+10*(i-1))...
                       +0.4*ships(i).length*cos(angle)+0.5*ships(i).breadth*sin(angle);
                   %P4
                   outline(4,1)=data(t,2+10*(i-1))...
                       +0.4*ships(i).length*sin(angle)+0.5*ships(i).breadth*cos(angle);
                   outline(4,2)=data(t,3+10*(i-1))...
                       -0.4*ships(i).length*cos(angle)+0.5*ships(i).breadth*sin(angle);
                   %P5
                   outline(5,1)=data(t,2+10*(i-1))...
                       +0.4*ships(i).length*sin(angle)-0.5*ships(i).breadth*cos(angle);
                   outline(5,2)=data(t,3+10*(i-1))...
                       -0.4*ships(i).length*cos(angle)-0.5*ships(i).breadth*sin(angle);
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
c = true;
end