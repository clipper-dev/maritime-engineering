function t = tcpa(ship1, ship2)
    x = ship1.x - ship2.x;
    y = ship1.y - ship2.y;
    vy = ship1.speed*sin(ship1.heading)-ship2.speed*sin(ship2.heading);
    vx = ship1.speed*cos(ship1.heading)-ship2.speed*cos(ship2.heading);
    v = sqrt(vx^2 + vy^2);
    t = -(x*vx + y*vy)/v^2;
end

