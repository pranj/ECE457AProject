% This functions generates another solution by performing a random swap 
% between any two points

function [nextSolution] = random_swap(solution)

%generate two random indices that are not 0 to swap
solSize = size(solution, 2);

swapIndices = randperm(solSize);
swapPoints = solution(swapIndices);
swapPoints = swapPoints(1:2);
while any(find(swapPoints == 0))
    swapIndices = randperm(solSize);
    swapPoints = solution(swapIndices);
    swapPoints = swapPoints(1:2);
end

nextSolution = swap(solution, swapIndices(1), swapIndices(2));

end
