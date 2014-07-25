% This function generates a random solution to the mTSP problem.
% 
% Inputs:
%   data: A PxP matrix that represents a complete graph
%          where P is a point. The element (i, j) represents the cost
%          to move between points i and j.
%          The matrix has to be symmetric.
%
% Outputs:
%   solution: A vector of size P+(R-1) where P is the number of points and
%   R is the number of receivers. P points will be divided into R receivers
%   with R-1 gaps (denoted by -1) between each receiver. 

% Get the number of points that need to be visited

function [solution] = gen_initial_solution(numPoints, numReceivers)

solutionSize = numPoints + numReceivers - 1;
solution = randperm(solutionSize);
dividerValues = (solutionSize - numReceivers + 2:solutionSize);
[~, dividers] = intersect(solution, dividerValues);
solution(dividers) = 0;

end
