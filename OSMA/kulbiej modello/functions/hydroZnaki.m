function set = hydroZnaki(hydroSet)
set = hydroSet;
%% X
if hydroSet(1) > 0
    %set(1) = -hydroSet(1);
end
if hydroSet(2) < 0
%    set(2) = -hydroSet(2);
end
if hydroSet(3) > 0
 %   set(3) = -hydroSet(3);
end
if hydroSet(4) > 0
  %  set(4) = -hydroSet(4);
end
%% Y
if hydroSet(5) > 0
    set(5) = -hydroSet(5);
end
if hydroSet(6) < 0
    set(6) = -hydroSet(6);
end
if hydroSet(7) > 0
    set(7) = -hydroSet(7);
end
if hydroSet(8) > 0
    set(8) = -hydroSet(8);
end
if hydroSet(9) > 0
    set(9) = -hydroSet(9);
end
if hydroSet(10) > 0
    set(10) = -hydroSet(10);
end
%% N
if hydroSet(11) < 0
    set(11) = -hydroSet(11);
end
if hydroSet(12) > 0
    set(12) = -hydroSet(12);
end
if hydroSet(13) < 0
    set(13) = -hydroSet(13);
end
if hydroSet(14) > 0
    %set(14) = -hydroSet(14);
end
if hydroSet(15) > 0
    %set(15) = -hydroSet(15);
end
if hydroSet(16) < 0
    %set(16) = -hydroSet(16);
end

end