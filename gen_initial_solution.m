% This function generates a random solution to the mTSP problem.
% 
% Inputs:
%   data: A PxP matrix that represents a complete graph
%          where P is a point. The element (i, j) represents the cost
%          to move between points i and j.
%          The matrix has to be symmetric.
%
% Outputs:
%   solution:  A matrix of size PxR where P is a point and
%         R is a receiver. Each row contains the points in the order
%         that the corresponding receiver visits them.
%   solutionCost: The total cost of the given solution.

% Get the number of points that need to be visited

function [solution] = gen_initial_solution(data, numReceivers)

numPoints = size(data, 1);

solution = zeros(numReceivers, numPoints);

permutation = randperm(numPoints);
recvrIndices = ones(numReceivers, 1);

for i = 1:numPoints
    receiver = randi(numReceivers);
    solution(receiver, recvrIndices(receiver)) = permutation(i);
    recvrIndices(receiver) = recvrIndices(receiver) + 1;
end

end
