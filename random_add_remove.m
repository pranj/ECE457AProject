% This function generates another solution by randomly selecting a point to
% remove and randomly selecting another location (before 1, after 2) to
% insert it.

function [nextSolution] = random_add_remove(solution)
solSize = size(solution, 2);

removeIdx = randi(solSize);
while ~solution(removeIdx)
    removeIdx = randi(solSize);
end

removePoint = solution(removeIdx);
insertIdx = randi(size(solution, 2));

nextSolution = add_remove(solution, removePoint, insertIdx);

end
