%% SETTINGS
addpath('modele');
addpath('real exp');
lengths = double([4]);
%% WYWO£YWANIE SKRYPTÓW
generowanieTrajektorii;
scalanie;
%model trajectory offset
mxOff = 5;
myOff = -5.9;
%% OBRÓBKA DANYCH
%mmg
for i=1:time
   if mod(gtTrajektoria(i,4),360)>90 
       advance = gtTrajektoria(i,3)-myOff;
       transfer = gtTrajektoria(i,2)-mxOff;
       break;
   end
end
for i=1:time
   if mod(gtTrajektoria(i,4),360)>180 
       tacticalDiameter = gtTrajektoria(i,2)-mxOff;
       break;
   end
end
%exp

%% PLOTTING
%trajektoria
if true
f1 = figure('Name','Trajectories');grid on
movegui(f1,[100,800]);
hold on
plot(gtTrajektoria(:,2)+mxOff,gtTrajektoria(:,3)+myOff); %modelowana w oparciu o MMG
for i=1:4
    plot(trajectoriesXY(1:lengths(i),2*i-1),trajectoriesXY(1:lengths(i),2*i));
end
legend('exp_0', 'exp_9_0', 'exp_1_8_0', 'exp_2_7_0', 'model');
axis on
axis equal
hold off
end
%prêdkoœci
if true
%gtWyniki(i,5) = shipA.vx;
%gtWyniki(i,6) = shipA.vy;

if smoothed == true
    newLength = min(lengths);
    smoothedV = double([newLength,2]);
    rawValues = zeros([newLength,20]);
    rotationRaw = zeros([newLength,10]);
    %gather data
    for i=1:newLength
        %vx
        rawValues(i,1) = velocitiesXY(i,1);
        rawValues(i,2) = velocitiesXY(i,3);
        rawValues(i,3) = velocitiesXY(i,5);
        rawValues(i,4) = velocitiesXY(i,7);
        %vx average
        rawValues(i,5) = 0.25*sum(rawValues(i,1:4));
        if abs(rawValues(i,1)-rawValues(i,5))>abs(smoothFactor*rawValues(i,1))
            rawValues(i,6)=0.33*(rawValues(i,2)+rawValues(i,3)+rawValues(i,4));
        else
            rawValues(i,6)=rawValues(i,1);
        end
        if abs(rawValues(i,2)-rawValues(i,5))>abs(smoothFactor*rawValues(i,2))
            rawValues(i,7)=0.33*(rawValues(i,1)+rawValues(i,3)+rawValues(i,4));
        else
            rawValues(i,7)=rawValues(i,2);
        end
        if abs(rawValues(i,3)-rawValues(i,5))>abs(smoothFactor*rawValues(i,3))
            rawValues(i,8)=0.33*(rawValues(i,2)+rawValues(i,1)+rawValues(i,4));
        else
            rawValues(i,8)=rawValues(i,3);
        end
        if abs(rawValues(i,4)-rawValues(i,5))>abs(smoothFactor*rawValues(i,4))
            rawValues(i,9)=0.33*(rawValues(i,2)+rawValues(i,3)+rawValues(i,1));
        else
            rawValues(i,9)=rawValues(i,4);
        end
        rawValues(i,10) = 0.25*sum(rawValues(i,6:9));
        %vy
        rawValues(i,11) = velocitiesXY(i,2);
        rawValues(i,12) = velocitiesXY(i,4);
        rawValues(i,13) = velocitiesXY(i,6);
        rawValues(i,14) = velocitiesXY(i,8);
        rawValues(i,15) = 0.25*sum(rawValues(i,11:14));
        %vy average
        rawValues(i,15) = 0.25*sum(rawValues(i,11:14));
        if abs(rawValues(i,11)-rawValues(i,15))>abs(smoothFactor*rawValues(i,11))
            rawValues(i,16)=0.33*(rawValues(i,12)+rawValues(i,13)+rawValues(i,14));
        else
            rawValues(i,16)=rawValues(i,11);
        end
        if abs(rawValues(i,12)-rawValues(i,15))>abs(smoothFactor*rawValues(i,12))
            rawValues(i,17)=0.33*(rawValues(i,11)+rawValues(i,13)+rawValues(i,14));
        else
            rawValues(i,17)=rawValues(i,12);
        end
        if abs(rawValues(i,13)-rawValues(i,15))>abs(smoothFactor*rawValues(i,13))
            rawValues(i,18)=0.33*(rawValues(i,12)+rawValues(i,11)+rawValues(i,14));
        else
            rawValues(i,18)=rawValues(i,13);
        end
        if abs(rawValues(i,14)-rawValues(i,15))>abs(smoothFactor*rawValues(i,14))
            rawValues(i,19)=0.33*(rawValues(i,12)+rawValues(i,13)+rawValues(i,11));
        else
            rawValues(i,19)=rawValues(i,14);
        end
        rawValues(i,20) = 0.25*sum(rawValues(i,16:19));
        
        rotationRaw(i,1) = rotationZ(i,1)*60/5.911/57.3;
        rotationRaw(i,2) = rotationZ(i,2)*60/5.911/57.3;
        rotationRaw(i,3) = rotationZ(i,3)*60/5.911/57.3;
        rotationRaw(i,4) = rotationZ(i,4)*60/5.911/57.3;
    end
    %smoothen
    for i=1:newLength
       if i>2&&i<newLength-2&&false
           rawValues(i,10) = 0.2*sum(rawValues(i-2:i+2,10));
           rawValues(i,20) = 0.2*sum(rawValues(i-2:i+2,20));
       end
    end
    for i=1:newLength
       if i>1&&i<newLength-1&&false
           rawValues(i,10) = 0.33*sum(rawValues(i-1:i+1,10));
           rawValues(i,20) = 0.33*sum(rawValues(i-1:i+1,20));
       end
    end
    %plot
    f2 = figure('Name','Vx');grid on
    movegui(f2,[700,800]);
    hold on
    plot(gtWyniki(:,5)); %modelowana w oparciu o MMG
    plot(rawValues(:,10));
    legend('exp_s_m_o_o_t_h_e_d', 'model');
    axis on
    hold off
    f3 = figure('Name','Vy');grid on
    movegui(f3,[1300,800]);
    hold on
    plot(gtWyniki(:,6)); %modelowana w oparciu o MMG
    plot(rawValues(:,20));
    legend('exp_s_m_o_o_t_h_e_d', 'model');
    axis on
    hold off     
else
    f2 = figure('Name','Vx');grid on
    movegui(f2,[700,800]);
    hold on
    plot(gtWyniki(:,5)); %modelowana w oparciu o MMG
    for i=1:4
        plot(velocitiesXY(1:lengths(i),2*i-1));
    end
    legend( 'model','exp_0', 'exp_9_0', 'exp_1_8_0', 'exp_2_7_0');
    axis on
    hold off
    f3 = figure('Name','Vy');grid on
    axis on
    movegui(f3,[1300,800]);
    hold on
    plot(gtWyniki(:,6)); %modelowana w oparciu o MMG
    for i=1:4
        plot(velocitiesXY(1:lengths(i),2*i));
    end
    legend( 'model','exp_0', 'exp_9_0', 'exp_1_8_0', 'exp_2_7_0');
    axis on
    hold off 
end    
end


%pozycje statku
for i=1:time
   if mod(i,drawOutlineEvery)==0 && false
       outline = zeros(6,2);
       angle = (360 - gtTrajektoria(i,4))/57.3 + atan(gtWyniki2(i,7)/gtWyniki2(i,6));
       %P1
       outline(1,1)=gtTrajektoria(i,2)...
           -0.4*shipA.length*sin(angle)-0.5*shipA.breadth*cos(angle);
       outline(1,2)=gtTrajektoria(i,3)...
           +0.4*shipA.length*cos(angle)-0.5*shipA.breadth*sin(angle);
       %P2 - dziób
       outline(2,1)=gtTrajektoria(i,2)-0.5*shipA.length*sin(angle);
       outline(2,2)=gtTrajektoria(i,3)+0.5*shipA.length*cos(angle);
       %P3
       outline(3,1)=gtTrajektoria(i,2)...
           -0.4*shipA.length*sin(angle)+0.5*shipA.breadth*cos(angle);
       outline(3,2)=gtTrajektoria(i,3)...
           +0.4*shipA.length*cos(angle)+0.5*shipA.breadth*sin(angle);
       %P4
       outline(4,1)=gtTrajektoria(i,2)...
           +0.4*shipA.length*sin(angle)+0.5*shipA.breadth*cos(angle);
       outline(4,2)=gtTrajektoria(i,3)...
           -0.4*shipA.length*cos(angle)+0.5*shipA.breadth*sin(angle);
       %P5
       outline(5,1)=gtTrajektoria(i,2)...
           +0.4*shipA.length*sin(angle)-0.5*shipA.breadth*cos(angle);
       outline(5,2)=gtTrajektoria(i,3)...
           -0.4*shipA.length*cos(angle)-0.5*shipA.breadth*sin(angle);
       %P1 jeszcze raz ¿eby zamkn¹æ krzyw¹
       outline(6,1)=outline(1,1);
       outline(6,2)=outline(1,2);
       plot(outline(:,1),outline(:,2));
   end
end
% inne wykresy
if false
figure;
hold on;
plot(gtTrajektoria(:,1),gtWyniki2(:,6))
plot(gtTrajektoria(:,1),gtWyniki2(:,7))
plot(gtTrajektoria(:,1),atan(gtWyniki2(:,7)/gtWyniki2(:,6)))
legend('V_X', 'V_Y', 'Ratio');
hold off;
%kurs i k¹t drogi
figure;
hold on;
plot(gtTrajektoria(:,1), gtTrajektoria(:,4))
plot(gtTrajektoria(:,1), gtTrajektoria(:,4)+atan(gtWyniki2(:,7)/gtWyniki2(:,6))*57.3)
legend('HDG', 'COG');
hold off;
figure
plot(gtTrajektoria(:,1),gtTrajektoria(:,5));
legend("r'");
end
