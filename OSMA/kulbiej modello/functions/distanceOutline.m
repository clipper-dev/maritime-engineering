function [d, points] = distanceOutline(x1,y1,heading1,x2,y2,heading2,ship1, ship2)
l1=length(ship1.outlineX);
l2=length(ship2.outlineX);
d = distance(ship1,ship2);
points=[ship1.x ship2.y;ship2.x ship1.y];
outlineA = zeros(l1+1,2);
outlineB = zeros(l2+1,2);
angle=90/57.3-heading1;
scale=1;
%% Punkty na nowo
for i=1:l1
    outlineA(i,2)=y1...
        +ship1.outlineY(i,1)*sin(angle)/scale+ship1.outlineX(i,1)*cos(angle)/scale;
    outlineA(i,1)=x1...
        -ship1.outlineY(i,1)*cos(angle)/scale+ship1.outlineX(i,1)*sin(angle)/scale;
end
%P1 jeszcze raz ¿eby zamkn¹æ krzyw¹
outlineA(l1+1,1)=outlineA(1,1);
outlineA(l1+1,2)=outlineA(1,2);
%%%%%%%%%%%%%%%%
angle=90/57.3-heading2;
for i=1:l2
    outlineB(i,2)=y2...
        +ship2.outlineY(i,1)*sin(angle)/scale+ship2.outlineX(i,1)*cos(angle)/scale;
    outlineB(i,1)=x2...
        -ship2.outlineY(i,1)*cos(angle)/scale+ship2.outlineX(i,1)*sin(angle)/scale;
end
%P1 jeszcze raz ¿eby zamkn¹æ krzyw¹
outlineB(l2+1,1)=outlineB(1,1);
outlineB(l2+1,2)=outlineB(1,2);

%% iteracja po trójk¹tach


for i=1:l1
    %wierzcholek z outlineA
    for j=1:l2
        %krawedz z outlineB
        a=sqrt((outlineB(j,1)-outlineB(j+1,1))^2 + (outlineB(j,2)-outlineB(j+1,2))^2);
        b1=sqrt((outlineA(i,1)-outlineB(j,1))^2 + (outlineA(i,2)-outlineB(j,2))^2);
        b2=sqrt((outlineA(i,1)-outlineB(j+1,1))^2 + (outlineA(i,2)-outlineB(j+1,2))^2);
        s=0.5*(a+b1+b2);
        h=2*sqrt(s*(s-a)*(s-b1)*(s-b2))/a;
        if b2^2 > b1^2 + a^2
            if d>b1
                points=[outlineA(i,1) outlineA(i,2);outlineB(j,1) outlineB(j,2)];
                d=b1;
            end
        elseif b1^2 > b2^2 + a^2
            if d>b2
                
                points=[outlineA(i,1) outlineA(i,2);outlineB(j+1,1) outlineB(j+1,2)];
                d=b2;
            end
        elseif d>h
            % wysokoœæ
            if outlineB(j+1,2)==outlineB(j,2)
                points=[outlineA(i,1) outlineA(i,2);outlineA(i,1) outlineB(j+1,2)];
                d=h;
            elseif outlineB(j+1,1)==outlineB(j,1)
                points=[outlineA(i,1) outlineA(i,2);outlineB(j,1) outlineA(i,2)];
                d=h;
            else
                dd=(outlineB(j+1,2)-outlineB(j,2))/(outlineB(j+1,1)-outlineB(j,1));
                
                bb1b2=outlineB(j,2)-dd*outlineB(j,1);
                bac=outlineA(i,2)+outlineA(i,1)/dd;
                
                xc=(bb1b2-bac)/(dd+1/dd);
                yc=(-bb1b2/dd - bac*dd)/(dd+1/dd);
                points=[outlineA(i,1) outlineA(i,2);-xc -yc];
                d=h;
            end
        end
    end
end
for i=1:l2
    %wierzcholek z outlineB
    for j=1:l1
        %krawedz z outlineA
        a=sqrt((outlineA(j,1)-outlineA(j+1,1))^2 + (outlineA(j,2)-outlineA(j+1,2))^2);
        b1=sqrt((outlineB(i,1)-outlineA(j,1))^2 + (outlineB(i,2)-outlineA(j,2))^2);
        b2=sqrt((outlineB(i,1)-outlineA(j+1,1))^2 + (outlineB(i,2)-outlineA(j+1,2))^2);
        s=0.5*(a+b1+b2);
        h=2*sqrt(s*(s-a)*(s-b1)*(s-b2))/a;
        if b2^2 > b1^2 + a^2
            if d>b1
                points=[outlineA(j,1) outlineA(j,2);outlineB(i,1) outlineB(i,2)];
                d=b1;
            end
        elseif b1^2 > b2^2 + a^2
            if d>b2
                points=[outlineA(j+1,1) outlineA(j+1,2);outlineB(i,1) outlineB(i,2)];
                d=b2;
            end
        elseif d>h
            if outlineA(j+1,2)==outlineA(j,2)
                points=[outlineB(i,1) outlineA(j+1,2);outlineB(i,1) outlineB(i,2)];
                d=h;
            elseif outlineA(j+1,1)==outlineA(j,1)
                points=[outlineA(j+1,1) outlineB(i,2);outlineB(i,1) outlineB(i,2)];
                d=h;
            else
                dd=(outlineA(j+1,2)-outlineA(j,2))/(outlineA(j+1,1)-outlineA(j,1));
                
                bb1b2=outlineA(j,2)-dd*outlineA(j,1);
                bac=outlineB(i,2)+outlineB(i,1)/dd;
                
                xc=(bb1b2-bac)/(dd+1/dd);
                yc=(-bb1b2/dd - bac*dd)/(dd+1/dd);
                points=[-xc -yc;outlineB(i,1) outlineB(i,2)];
                d=h;
            end
        end
    end
end
end