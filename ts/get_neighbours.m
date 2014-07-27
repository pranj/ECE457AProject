function [neighbours] = get_neighbours(solution, numRcvr)
numPoints = size(solution, 2) - (numRcvr - 1);
numNeighbours = nchoosek(numPoints, 2) + numPoints*(numPoints - 1);
neighbours = zeros(numNeighbours+10, size(solution, 2));

neighbourIdx = 1;
for i = 1:numPoints
    for j = i+1:numPoints
        neighbours(neighbourIdx, :) = swap(solution, i, j);
        neighbourIdx = neighbourIdx + 1;
    end
end

for i = 1:numPoints
    for j = 1:numPoints
        neighbours(neighbourIdx, :) = add_remove(solution, i, j);
        neighbourIdx = neighbourIdx + 1;
    end
end
end