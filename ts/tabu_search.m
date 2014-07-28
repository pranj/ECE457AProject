function [globalBestSol, globalBestCost] = tabu_search( ...
            costs, tabuLength, numIterations, numRcvr, initialSol)
numPoints = size(initialSol, 2) - numRcvr + 1;
swap_tabu = zeros(numPoints, numPoints);
insert_tabu = zeros(numPoints + numRcvr - 1, numPoints + numRcvr - 1);

currentSol = initialSol;

globalBestSol = currentSol;
globalBestCost = calculate_cost(initialSol, costs, costs(end, :));

        
for n = 1:numIterations
    % Get the best solution in the neighbourhood of the current solution
    % Avoid Tabu moves, consider aspiration criteria
    [neighbours method] = get_neighbours(currentSol);
    bestNeighbourCost = Inf;
    bestNeighbourIdx = 1;
    for i = 1:size(neighbours, 1)
        neighbourCost = calculate_cost(neighbours(i, :), costs, costs(end, :));
        if method(i, 1) == 0
            % check swap tabu
            point1 = method(i, 2);
            point2 = method(i, 3);
            if swap_tabu(point1, point2) > 0
                %aspiration
                if neighbourCost < globalBestCost
                    bestNeighbourCost = neighbourCost;
                    bestNeighbour = neighbours(i, :);
                else
                    continue
                end
            end
            
        elseif method(i, 1) == 1
            % check insert tabu
            removePoint = method(i, 2);
            insertIdx = method(i, 3);
            if insert_tabu(removePoint, insertIdx) > 0
                % aspiration
                if neighbourCost < globalBestCost
                    bestNeighbourCost = neighbourCost;
                    bestNeighbour = neighbours(i, :);
                else
                    continue
                end
            end
        end
         
        if neighbourCost < bestNeighbourCost
            bestNeighbourCost = neighbourCost;
            bestNeighbour = neighbours(i, :);
            bestNeighbourIdx = i;
        end
    end
    
    % tabu best neighbour method
    if method(bestNeighbourIdx, 1) == 0
        point1 = method(bestNeighbourIdx, 2);
        point2 = method(bestNeighbourIdx, 3);
        swap_tabu(point1, point2) = tabuLength;
    elseif method(bestNeighbourIdx, 2) == 0
        removePoint = method(bestNeighbourIdx, 2);
        insertIdx = method(bestNeighbourIdx, 3);
        insert_tabu(removePoint, insertIdx) = tabuLength;
    end
    
    if bestNeighbourCost < globalBestCost
        globalBestCost = bestNeighbourCost;
        globalBestSol = bestNeighbour;
    end
    
    currentSol = bestNeighbour;
end
        
end