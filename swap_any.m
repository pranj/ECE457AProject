% This functions generates another solution by performing a random swap 
% between any two points (could be a delimiter)

function [nextSolution] = swap_any(solution)

limit = size(solution, 2);

swapIndices = randperm(limit);
swapIndices = swapIndices(1:2);

tmp = solution(swapIndices(1));
solution(swapIndices(1)) = solution(swapIndices(2));
solution(swapIndices(2)) = tmp;

nextSolution = solution;

end
