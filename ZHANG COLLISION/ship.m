classdef ship
    %SHIP Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        l
        m
        i
        vx
        vy
        mx
        my
        iz
        x
        y
    end
    
    methods
        function s = ship(length, mass, velocityX, velocityY, addedMassX, addedMassY, addedInertiaZ,x,y)
            %SHIP Construct an instance of this class
            %   Detailed explanation goes here
            s.l = length;
            s.m = mass;
            s.i = 0.0625*s.m*s.l*s.l;
            s.vx = velocityX;
            s.vy = velocityY;
            s.mx = addedMassX;
            s.my = addedMassY;
            s.iz = addedInertiaZ;
            s.x = x;
            s.y = y;
        end
        
    end
end

