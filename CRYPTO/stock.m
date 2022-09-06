classdef stock
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        name
        price
        initialPrice
        volume
    end
    
    methods
        function obj = stock(name,price, volume)
            %UNTITLED Construct an instance of this class
            %   Detailed explanation goes here
            obj.name = name;
            obj.price = price;
            obj.initialPrice = price;
            obj.volume = volume;
        end
        
        function price = setPrice(obj,newPrice)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            obj.price = newPrice;
        end
        
        function p = update(obj)
            change = normrnd(0,1);
            obj.price = obj.price + rand*obj.initialPrice*(change);
            obj.price = max(obj.price, 0);
            p = obj;
        end
    end
end

