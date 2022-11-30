function c = cpa(ship1, ship2)
x = ship1.x - ship2.x;
y = ship1.y - ship2.y;
if tcpa(ship1, ship2) > 0
    vy = -ship1.speed*sin(ship1.heading)+ship2.speed*sin(ship2.heading);
    vx = -ship1.speed*cos(ship1.heading)+ship2.speed*cos(ship2.heading);
    v = sqrt(vx^2 + vy^2);
    if v == 0
        c = 0;
        return;
    end
    c = abs((y*vx - x*vy)/v);
else
    c=sqrt(x^2 + y^2);
end
end