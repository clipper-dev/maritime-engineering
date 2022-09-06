classdef bot
properties
    money
    value
    stocks
end

methods
    function obj = bot(initialMoney, stocksNumber)
        obj.money = initialMoney;
        obj.stocks = zeros(stocksNumber);
    end
    %% financial calculus
    function v = calculateValue(obj, marketData, now)
        n = length(obj.stocks);
        v = 0;
        v = obj.money;
        for i=1:n
           v = v + obj.stocks(n) * marketData(now, n, 1);
        end
    end
    
    function a = analyse(obj,marketData, now)
        n = length(obj.stocks);
        for i=1:n
           change = marketData(now,n,1) - marketData(now-1,n,1);
           if change < 0 && marketData(now,n,1) > 0
               % sell
               obj.money = obj.money + obj.stocks(n) * marketData(now,n,1);
               obj.stocks(n) = 0;
           elseif obj.stocks(n) == 0 && marketData(now,n,1) > 0
               % buy
               amount = floor(obj.money / marketData(now,n,1));
               amount = min(amount, 100);
               obj.money = obj.money - amount * marketData(now,n,1);
               obj.stocks(n) = amount;
           end
           a = obj;
        end
    end
end
end