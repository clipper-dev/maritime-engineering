function c = rysujWykresy(bezWymiarowo,monitor, dane, vessel, HDGCOG, path, outlines, offset, velocities, accelerations, ...
    X, Y, N, weather, zigZag)
time = length(dane(:,1));
timeDimentionLess = zeros(time,1);
for i=1:time
    timeDimentionLess(i,1)=i*vessel.vx/vessel.length;
end
if HDGCOG==true
    f8 = figure('Name','Kurs');grid on
    title(vessel.name);
    xlabel('czas [s]') 
    ylabel('kurs [deg]')
    if monitor == true
        movegui(f8,[1850,800]);
    else 
        movegui(f8,[1850,100]);        
    end
    hold on
    plot(dane(:,4)*57.3);%kurs
    plot(dane(:,5)*57.3);%COG
    legend('HDG','COG');
    hold off
end
if path == true
    f1 = figure('Name',"Trajektoria statku " + vessel.name);grid on; hold on; axis equal;
    
    title(vessel.name);
    if monitor == true
        movegui(f1,[50,800]);
    else
        movegui(f1,[50+550*0,100+550*0]);
    end
    if bezWymiarowo==true
        xlabel('X/L [-]') 
        ylabel('Y/L [-]') 
        scale=vessel.length; 
    else
        xlabel('X [m]') 
        ylabel('Y [m]') 
        scale=1;
    end
    plot(dane(:,3)/scale,dane(:,2)/scale,vessel.colour);
    if outlines == 1           
        for i=1:time
           if mod(i,offset)==0               
               outline=drawOutline(dane(i,3),dane(i,2),dane(i,4),vessel,scale);
               plot(outline(:,1),outline(:,2),vessel.colour);
               plot(dane(i,3)/scale,dane(i,2)/scale,'+','LineWidth',2,'MarkerSize',10,'MarkerEdgeColor',vessel.colour);
           end
        end
    elseif outlines == 2
           done = 0;
           offset=offset/57.3;
           for i=1:time
               check = (dane(i,4) - offset*done) > (offset);
               if check == true
                   done = done + 1;
                   outline=drawOutline(dane(i-1,3),dane(i-1,2),dane(i-1,4),vessel.length,vessel.breadth,scale);
                   plot(outline(:,1),outline(:,2),vessel.colour);
                   plot(dane(i-1,3)/scale,dane(i-1,2)/scale,'+','LineWidth',2,'MarkerSize',10,'MarkerEdgeColor',vessel.colour);
               end
           end
    end
    hold off
end
if velocities == true
    f2 = figure('Name','Prêdkoœci');grid on
    title(vessel.name);
    xlabel('czas [s]') 
    ylabel('prêdkoœæ [m/s] lub 1 [-]')
    if monitor == true
        movegui(f2,[650,800]);
    else 
        movegui(f2,[50+550*1,100+550*0]);        
    end
    hold on   
    plot(dane(:,7));
    plot(dane(:,8));
    plot(dane(:,9));
    plot(dane(:,12));
    legend('V','u','v',"r'");
    hold off
end
if accelerations == true
    f7 = figure('Name','Przyspieszenia');grid on
    title(vessel.name);
    xlabel('czas [s]') 
    ylabel('przyspieszenia [m/s^2]')
    if monitor == true
        movegui(f7,[1250,800]);
    else 
        movegui(f7,[50+550*2,100+550*0]);        
    end
    hold on
    plot(dane(:,13));
    plot(dane(:,14));
    plot(dane(:,15));
    legend({'$\dot{u}$', '$\dot{v}$', '$\dot{r}$'}, 'Interpreter', 'latex');    
    hold off
end
if X == true
    f3 = figure('Name','Si³y X');grid on
    title(vessel.name);
    movegui(f3,[50+550*0,100+550*1]);  
    hold on
    plot(dane(:,16)+dane(:,17)+dane(:,18)+dane(:,19)+dane(:,20));
    plot(dane(:,16));
    plot(dane(:,17));
    plot(dane(:,18));
    if weather==true
        plot(dane(:,19));
        plot(dane(:,20));
        legend('X_t_o_t_a_l','X_h_u_l_l', 'X_r_u_d_d_e_r', 'X_p_r_o_p_e_l_l_e_r', 'X_a_i_r', 'X_w_a_v_e');  
    else
        legend('X_t_o_t_a_l','X_h_u_l_l', 'X_r_u_d_d_e_r', 'X_p_r_o_p_e_l_l_e_r'); 
    end 
    hold off
end
if Y == true
    f4 = figure('Name','Si³y Y');grid on
    title(vessel.name);
    movegui(f4,[50+550*1,100+550*1]);
    hold on
    plot(dane(:,22)+dane(:,23)+dane(:,24)+dane(:,25)+dane(:,26));
    plot(dane(:,22)); 
    plot(dane(:,23));
    plot(dane(:,24));     
    if weather==true
        plot(dane(:,25));
        plot(dane(:,26));
        legend('Y_t_o_t_a_l','Y_h_u_l_l', 'Y_r_u_d_d_e_r', 'Y_p_r_o_p_e_l_l_e_r', 'Y_a_i_r', 'Y_w_a_v_e');
    else
        legend('Y_t_o_t_a_l','Y_h_u_l_l', 'Y_r_u_d_d_e_r', 'Y_p_r_o_p_e_l_l_e_r');
    end 
    hold off
end
if N == true
    f5 = figure('Name','Momenty N');grid on
    title(vessel.name);
    movegui(f5,[50+550*2,100+550*1]);
    hold on
    plot(dane(:,27)+dane(:,28)+dane(:,29)+dane(:,30)+dane(:,31));
    plot(dane(:,27));
    plot(dane(:,28));
    plot(dane(:,29));
    if weather==true
        plot(dane(:,30));
        plot(dane(:,31));
        legend('N_t_o_t_a_l','N_h_u_l_l', 'N_r_u_d_d_e_r', 'N_p_r_o_p_e_l_l_e_r', 'N_a_i_r', 'N_w_a_v_e');  
    else
        legend('N_t_o_t_a_l','N_h_u_l_l', 'N_r_u_d_d_e_r', 'N_p_r_o_p_e_l_l_e_r');
    end 
    hold off
end
if zigZag == true
    f6 = figure('Name','Zig Zag');grid on
    if monitor == true
        movegui(f6,[1250,100]);
    end
    hold on
    if bezWymiarowo
    plot(timeDimentionLess(:,1),dane(:,32)*57.3);
    plot(timeDimentionLess(:,1),dane(:,4)*57.3); 
    xlabel("t' [-]");
    ylabel("\psi, \delta [\circ]");    
    else       
    plot(dane(:,32)*57.3);
    plot(dane(:,4)*57.3); 
    xlabel("time [s]");
    ylabel("\delta [deg]");
    end
    legend('rudder','heading');
    
    hold off
end
c = true;
end