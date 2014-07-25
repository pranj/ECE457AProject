% This functions generates another solution by performing a random swap 
% between any two points

function [nextSolution] = random_swap(solution)

limit = max(solution);

swapPoints = randperm(limit);
swapPoints = swapPoints(1:2);

idx1 = solution == swapPoints(1);
idx2 = solution == swapPoints(2);

solution(idx1) = swapPoints(2);
solution(idx2) = swapPoints(1);

nextSolution = solution;

end
