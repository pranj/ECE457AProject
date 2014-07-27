% This function generates another solution by randomly selecting a point to
% remove and randomly selecting another location (before 1, after 2) to
% insert it.

function [nextSolution] = random_add_remove(solution)

limit = max(solution);

removedPoint = randi(limit);
insertIdx = randi(size(solution, 2));

nextSolution = add_remove(solution, removedPoint, insertIdx);

end
