function [globalBestSol, globalBestCost, plot_points] = tabu_search( ...
            costs, tabuLength, numRcvr, MaxIterationsWithoutChange, initialSol)

numPoints = size(initialSol, 2) - (numRcvr - 1);
swap_tabu = zeros(numPoints, numPoints);
insert_tabu = zeros(numPoints + numRcvr - 1, numPoints + numRcvr - 1);

currentSol = initialSol;

globalBestSol = currentSol;
globalBestCost = calculate_cost(initialSol, costs, costs(end, :));

noimprovement_count = 0;

plot_points = zeros(50, 1);
iteration = 1;
while noimprovement_count < MaxIterationsWithoutChange
    % Get the best solution in the neighbourhood of the current solution
    % Avoid Tabu moves, consider aspiration criteria
    [neighbours method] = get_neighbours(currentSol);
    bestNeighbourCost = Inf;
    bestNeighbourIdx = 1;
    
    for k = 1:size(neighbours, 1)
        neighbourCost = calculate_cost(neighbours(k, :), costs, costs(end, :));
        if method(k, 1) == 0
            % check swap tabu
            point1 = method(k, 2);
            point2 = method(k, 3);
            if swap_tabu(point1, point2) || swap_tabu(point2, point1) > 0
                %aspiration
                if neighbourCost < globalBestCost
                    bestNeighbourCost = neighbourCost;
                    bestNeighbour = neighbours(k, :);
                    bestNeighbourIdx = k;
                else
                    continue;
                end
            end
            
        elseif method(k, 1) == 1
            % check insert tabu
            removePoint = method(k, 2);
            insertIdx = method(k, 3);
            if insert_tabu(removePoint, insertIdx) > 0
                % aspiration
                if neighbourCost < globalBestCost
                    bestNeighbourCost = neighbourCost;
                    bestNeighbour = neighbours(k, :);
                    bestNeighbourIdx = k;
                else
                    continue;
                end
            end
        end
        
        if neighbourCost < bestNeighbourCost
            bestNeighbourCost = neighbourCost;
            bestNeighbour = neighbours(k, :);
            bestNeighbourIdx = k;
        end
    end
    
    swap_tabu(find(swap_tabu)) = swap_tabu(find(swap_tabu)) - 1;
    swap_tabu(swap_tabu < 0) = 0;
    insert_tabu(find(insert_tabu)) = insert_tabu(find(insert_tabu)) - 1;
    insert_tabu(insert_tabu < 0) = 0;
    
    % tabu best neighbour method
    if method(bestNeighbourIdx, 1) == 0
        point1 = method(bestNeighbourIdx, 2);
        point2 = method(bestNeighbourIdx, 3);
        swap_tabu(point1, point2) = tabuLength;
    elseif method(bestNeighbourIdx, 1) == 1
        removePoint = method(bestNeighbourIdx, 2);
        insertIdx = method(bestNeighbourIdx, 3);
        insert_tabu(removePoint, insertIdx) = tabuLength;
    end
    
    if bestNeighbourCost < globalBestCost
        globalBestCost = bestNeighbourCost;
        globalBestSol = bestNeighbour;
        noimprovement_count = 0;
    end

    %disp(globalBestCost);
    plot_points(iteration) = globalBestCost;
    plot(plot_points)
    drawnow
    
    currentSol = bestNeighbour;
    noimprovement_count = noimprovement_count + 1;
    iteration = iteration + 1;
end

%disp('Solution Path:');
%disp(globalBestSol)
%disp('Cost for solution:');
%disp(globalBestCost);
%disp('Iterations to converge:')
%disp(iteration);
