classdef weather
    %POGODA weather(windDirection, windSpeed, waveDirection, waveHeight,
    %waveFrequency)
    %   Detailed explanation goes here
    
    properties
        windDirection
        windSpeed
        waveDirection
        waveHeight
        waveFrequency
    end
    
    methods
        function obj = weather(windDirection, windSpeed, waveDirection, waveHeight, waveFrequency)
            
            obj.windDirection = windDirection;
            obj.windSpeed = windSpeed;
            obj.waveDirection = waveDirection;
            obj.waveHeight = waveHeight;
            obj.waveFrequency = waveFrequency;
        end
    end
end

