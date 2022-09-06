%% MARKET INITIALIZATION
clc;clear;close all;
duration = 100;
market(1) = stock("Red", 1, 100);
%market(2) = stock("Blue", 1, 100);
coins = length(market);
crypto = bot(10,coins);
mData = zeros(duration, coins, 1);
results = zeros(duration,1);
%% TIME LOOP
for i=1:duration
    for j=1:coins
       market(j) = market(j).update();
       mData(i,j,1) = market(j).price; %current price
       mData(i,j,2) = 0; %current volume       
    end
    %% bot
    if i > 1
    crypto = crypto.analyse(mData,i);
    end
    %% results
    results(i) = crypto.calculateValue(mData,i);
end

%% PLOTTING
figure; hold on; 
plot(results, 'b');
plot(mData(:,1,1), 'r');
%plot(mData(:,2,1), 'b');
legend('value',market(1).name);
%legend('value',market(1).name, market(2).name);

