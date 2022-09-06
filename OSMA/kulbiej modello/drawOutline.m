function outline = drawOutline(x,y,heading,ship,scale)
%x,y - pozycja, heading-kurs/obrót w radianach, length,breadth-w metrach,
%scale-np. d³ugoœæ statku dla wyrysowania bezwymiarowego
l1=length(ship.outlineX);

outline = zeros(l1+1,2);
x=x/scale;
y=y/scale;
angle=90/57.3-heading;
%Punkt
for i=1:l1
outline(i,1)=y...
   +ship.outlineY(i,1)*sin(angle)/scale+ship.outlineX(i,1)*cos(angle)/scale;
outline(i,2)=x...
   -ship.outlineY(i,1)*cos(angle)/scale+ship.outlineX(i,1)*sin(angle)/scale;
end
%P1 jeszcze raz ¿eby zamkn¹æ krzyw¹
outline(l1+1,1)=outline(1,1);
outline(l1+1,2)=outline(1,2);
end

