function [searchLevels] = smartBinarySearchLevel(distance,precision, levelLimit)
%smartBinarySearchLevel(distance,precision, levelLimit)
currentStep = distance;
searchLevels = 0;
while currentStep > precision || searchLevels == levelLimit
    currentStep = currentStep/2;
    searchLevels = searchLevels + 1;
end
end

