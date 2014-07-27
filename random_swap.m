% This functions generates another solution by performing a random swap 
% between any two points

function [nextSolution] = random_swap(solution)

limit = max(solution);

swapPoints = randperm(limit);
swapPoints = swapPoints(1:2);

nextSolution = swap(solution, swapPoints(1), swapPoints(2));

end
