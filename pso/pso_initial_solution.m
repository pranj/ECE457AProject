function [solution] = pso_initial_solution(numPoints, numReceivers)

solutionSize = numPoints + numReceivers - 1;
solution = randperm(solutionSize);
dividerValues = (solutionSize - numReceivers + 2:solutionSize);
[~, dividers] = intersect(solution, dividerValues);
if size(dividers, 2) == 1
    dividers = dividers';
end
for x = 1:size(dividers, 2)
    solution(dividers(x)) = -x;
end
end