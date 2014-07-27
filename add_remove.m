% This function generates another solution by randomly selecting a point to
% remove and randomly selecting another location (before 1, after 2) to
% insert it.

function [nextSolution] = add_remove(solution, removedPoint, insertIdx)
numRcvrs = sum(solution == 0) + 1;

%set insert locations
tempSol = zeros(1, 2*size(solution, 2) - numRcvrs);

if solution(1) == removedPoint
    tempSolIdx = 1;
    slot = 1;
else
    tempSol(1) = -1;
    tempSol(2) = solution(1);
    tempSolIdx = 3;
    slot = 2;
end
for i = 2:size(solution, 2)
    if solution(i) == removedPoint
        continue
    end
    
    if solution(i - 1) ~= removedPoint
        tempSol(tempSolIdx) = -1 * slot;
        tempSol(tempSolIdx + 1) = solution(i);
        tempSolIdx = tempSolIdx + 2;
        slot = slot + 1;
    else
        tempSol(tempSolIdx) = solution(i);
        tempSolIdx = tempSolIdx + 1;
    end
end

if solution(end) ~= removedPoint
    tempSol(tempSolIdx) = -1 * slot;
end

%replace
replaceIdx = tempSol == -1 * insertIdx;
tempSol(replaceIdx) = removedPoint;
nextSolution = tempSol(tempSol >= 0);

end
