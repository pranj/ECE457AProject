% This functions generates another solution by performing a random swap 
% between any two points

function [nextSolution] = swap(solution, point1, point2)

idx1 = solution == point1;
idx2 = solution == point2;

solution(idx1) = point2;
solution(idx2) = point1;

nextSolution = solution;

end
