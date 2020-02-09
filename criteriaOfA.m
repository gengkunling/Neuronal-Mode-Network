function [newA, idxA]= criteriaOfA(A, sA)
% Control that the B would in range lowerBound to upperBound
upperBound = 1 - sA;
lowerBound = sA;

if A <= lowerBound;
    newA = lowerBound;
elseif A >= upperBound;
    newA = upperBound;
else
    newA = A;
end
idxA = floor(newA / sA);