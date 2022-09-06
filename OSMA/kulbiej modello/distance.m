function d = distance(ship1, ship2)
    dx = ship1.x - ship2.x;
    dy = ship1.y - ship2.y;
    d = sqrt(dx^2 + dy^2);
end