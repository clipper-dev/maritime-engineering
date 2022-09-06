function [winner] = play(player1, player2)
if player1==player2
    winner=0;
end
if player1==1&&player2==2
    winner = player2;
elseif player1==2&&player2==3
    winner = player2;
elseif player1==3&&player2==1
    winner = player2;
else
    winner = player1;
end

end

