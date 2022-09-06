clc; clear all; close all;
c=["rock","paper","scissors"];
s=["random1","random2","only rock", "only rock and paper", ...
    "enemy previous clone", "enemy previous beat", "enemy previous lose"];
games = 100;
strategies = 10;
%% calculations
data=zeros(games,strategies);
%filling up strategies
scores=zeros(games, strategies);
%1 - losowy
data(:,1)=randi(3,games,1);
%2 - losowy
data(:,2)=randi(3,games,1);
data(1,:)=randi(1,1,strategies);
for i=2:games
    %3 - only rock
    data(i,3)=1;
    %4 - only rock and paper
    data(i,4)=randi(2);
    %5 - enemy previous clone
    data(i,5)=data(i-1,1);
    %6 - enemy previos beat
    data(i,6)=mod(data(i-1,1)-1,3)+1;
    %7 - enemy previous lose
    data(i,7)=mod(data(i-1,1)+1,3)+1;
    %8 - enemy previos most popular clone
    [a,b]=groupcounts(data(1:i-1,1));
    [c,ii]=min(a);
    data(i,8)=b(ii);
    %9 - enemy previos most popular beat
    [a,b]=groupcounts(data(1:i-1,1));
    [c,ii]=min(a);
    data(i,9)=mod(b(ii)-1,3)+1;
    %10 - enemy previos most popular lose
    [a,b]=groupcounts(data(1:i-1,1));
    [c,ii]=min(a);
    data(i,10)=mod(b(ii)+1,3)+1;
end

strategyResults=zeros(1,strategies);
for i=1:games
    for j=1:strategies
       scores(i,j)=play2(data(i,1),data(i,j));
       if scores(i,j)==1
        strategyResults(1,j)=strategyResults(1,j)+1;
    end
    end
    
end

%p1wp=round(p1w/games * 100);
%p2wp=round(p2w/games * 100);
%draws=round((games-p1w-p2w)/games * 100);
%disp("Player 1 won " + p1w + " games, player 2 won " + p2w + " games, " + (games-p1w-p2w) + " games were draws.");
%disp("Player 1 won " + p1wp + "% of games, player 2 won " + p2wp + "% of games, " + draws + "% of games were draws.");
strategyResults
