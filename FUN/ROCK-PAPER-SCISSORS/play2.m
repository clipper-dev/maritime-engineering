function [winner] = play2(player1, player2)
if player1==player2
    winner=0;
elseif player1==1&&player2==2
    winner = 2;
elseif player1==2&&player2==3
    winner = 2;
elseif player1==3&&player2==1
    winner = 2;
else
    winner = 1;
end
end

