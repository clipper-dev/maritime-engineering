function distData = odlegloscGranicyDokladnosci(a, b)
%odległość granicy dokładności, dość długo mieli

margin = 0.1;

initialDist = 50;
bearing = 0;
course = 0;
precision=1;
distPrecision=10;
limit=10000;
d1=initialDist;
distData=zeros(360/precision,360/precision);
for i=1:360/precision
    bearing=i*precision;
    for j=1:360/precision
        course=j*precision;
        lock=false;
        d1=initialDist;
        for k=1:limit/precision
            b=b.updateShip([d1*sin(bearing/57.3) d1*cos(bearing/57.3) 0 0 0 course/57.3 5.81 0 0 0 0 0]);
            dd=distance(a,b);
            [dist,results]=distanceOutline(a.x,a.y,a.heading,b.x,b.y,b.heading,a,b);
            newDistance=(dd-dist)/dd;
            d1=initialDist+k*distPrecision;
            if newDistance<margin || d1>limit
                distData(i,j)=d1/a.length;
                break;
            end
        end
    end
end

end