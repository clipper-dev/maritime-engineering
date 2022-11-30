function c = cpaOutline(ship1, ship2,timeStep)
    x1=ship1.x;
    y1=ship1.y;
    x2=ship2.x;
    y2=ship2.y;
    previousDistance=distanceOutline(x1,y1,ship1.heading,x2,y2,ship2.heading,ship1,ship2);
    while true
       %przesuń statki
       x1=x1+ship1.vx*timeStep*cos(ship1.heading)+ship1.vy*timeStep*sin(ship1.heading);
       y1=y1+ship1.vx*timeStep*sin(ship1.heading)+ship1.vy*timeStep*cos(ship1.heading);
       
       x2=x2+ship2.vx*timeStep*cos(ship2.heading)+ship2.vy*timeStep*sin(ship2.heading);
       y2=y2+ship2.vx*timeStep*sin(ship2.heading)+ship2.vy*timeStep*cos(ship2.heading);
       
       d=distanceOutline(x1,y1,ship1.heading,x2,y2,ship2.heading,ship1,ship2);
       if d>previousDistance
           c=previousDistance;
           break;
       else
           previousDistance=d;
       end
    end
end