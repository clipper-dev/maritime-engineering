function c = hdgChange(ship1,ship2,cpaSet,precision,outlines)
%COURSECHANGE Return the course change required to reach reaquired CPA
%   Return the course change required to reach reaquired CPA, true if no change and false if no solution
d = distance(ship1,ship2);

if outlines == true
    cpa0 = cpaOutline(ship1,ship2,1);
else
    cpa0 = cpa(ship1,ship2);
end
if cpa0 > cpaSet 
    c = true;
    return
end
if d < cpaSet
    c = false;
    return
end
initialCourse = ship1.heading;
cpaFound = false;
currentPrecision = 180/57.3;
course = initialCourse;
while abs(currentPrecision) > precision
    course = course + currentPrecision;
    ship1 = ship1.setHeading(course);
    if outlines == true
        cpa1 = cpaOutline(ship1,ship2,1);
    else
        cpa1 = cpa(ship1,ship2);
    end
    if cpa1 > cpaSet
        cpaFound = true;
        c = course;
        currentPrecision = -abs(currentPrecision/2);
    else
        currentPrecision = abs(currentPrecision/2);
    end   
end
end

