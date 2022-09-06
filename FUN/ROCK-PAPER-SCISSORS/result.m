function [text] = result(player1, player2)
c=["rock","paper","scissors"];
r=play(player1,player2);
if r==player1
   text = "Player 1 won by using " + c(player1) + " against " + c(player2) + "."; 
elseif r==player2
   text = "Player 2 won by using " + c(player2) + " against " + c(player1) + "."; 
else
   text = "Both players chose "+c(player1)+". There was a draw."; 
end
    
end

