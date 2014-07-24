function [BestSol, BestCost] = TabuSearch( ...
            Data, TabuLength, NumIterations, NumReceivers, StartPoint)
% This function implements the tabu search algorithm
%
% Inputs:
%   Data: The data of the problem to be solved.
%   TabuLength: The lenght of the tabu list
%   NumIterations: The maximum number of iterations
%
% Outputs:
%   BestSol: The best solution obtained
%   BestCost: The cost of the best solution

% Generate the initial solution given the problem data
[Sol, TotalSolCost, SolCost, TabuMoves] = ... 
    GenInitialSol(Data, NumReceivers, StartPoint);

% Set best solution to initial solution
BestSol = Sol;
BestCost = TotalSolCost;

for n = 1:NumIterations
    % Get the best solution in the neighbourhood of the current solution
    % Avoid Tabu moves, consider aspiration criteria
    [Sol, TotalSolCost, SolCost, TabuMoves] = GetBestNeighbourSol( ...
        Data, Sol, SolCost, TabuMoves, TabuLength, NumReceivers, BestCost);
    
    % Update the best solution
    if TotalSolCost < BestCost
        BestSol = Sol;
        BestCost = SolCost;
    end
end

disp(BestCost);
end

function [Sol, TotalSolCost, SolCost, TabuMoves] = ...
    GenInitialSol(Data, NumReceivers, StartPoint)
% This function generates a random solution to the mTSP problem.
% 
% Inputs:
%   Data: A PxP matrix that represents a complete graph
%          where P is a point. The element (i, j) represents the cost
%          to move between points i and j.
%          The matrix has to be symmetric.
%
% Outputs:
%   Sol:  A matrix of size PxR where P is a point and
%         R is a receiver. Each row contains the points in the order
%         that the corresponding receiver visits them.
%   SolCost: The total cost of the given solution.
%   TabuMoves: Initialized 3D Matrix (PxPxR) of tabu moves

% Get the number of points that need to be visited
NumPoints = size(Data, 1);

Sol = zeros(NumPoints, NumReceivers);
Sol(:, 1) = StartPoint;

randPoints = randPerm(NumPoints);

for p = 1:NumPoints
    if randPoint(p) == StartPoint
        continue;
    end
    
    randReceiver = randi(NumReceivers, 1);
    for pos = 2:NumPoints
        if Sol(pos, randReceiver) == 0
            Sol(pos, randReceiver) = randPoints(p);
            break;
        end
    end
end

[TotalSolCost SolCost] = CalculateCost(Sol, Data);
TabuMoves = zeros(NumPoints, NumPoints, NumReceivers);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [BestNSol, BestNCost, SolCost, TabuMoves] = GetBestNeighbourSol( ...
    Data, Sol, SolCost, TabuMoves, TabuLength, NumReceivers, BestCost)

% This function gets the neighbours of the given solution
% with the lowest cost.
%
% Inputs:
%   Data: A PxP matrix that represents a complete graph
%          where P is a point. The element (i, j) represents the cost
%          to move between points i and j.
%          The matrix has to be symmetric.
%   Sol:  A matrix of size PxR where P is a point and
%         R is a receiver. Each row contains the points in the order
%         that the corresponding receiver visits them.
%   SolCost: Vector containing the costs of each receiver from the Sol
%   TabuEdges: A 3D matrix that represents the edges that are not allowed to
%               be removed from the current solution.
%   TabuLength: The length of the tabu list
%   NumReceivers: The total number of receivers
%   BestCost: The current best cost


% Get the number of points that need to be visited
NumPoints = size(Data, 1);

% A flag to indicate whether a tabu move to be added to the tabu list or
% not
AddTabuMove = false;

% Get all neighbouring moves
bestCandidateSol = Sol;
bestCandidateCost = Inf;
tabuEi = zeros(1, 3);
tabuEj = zeros(1, 3);

% 1. Find all swaps within a receiver's own tour
for r = 1:NumReceivers
    for i = 1:NumPoints-1
        if Sol(i, r) == 0
            break
        end
        
        for j = i+1:NumPoints
            if Sol(j, r) == 0
                break
            end
            
            % Swap
            newSol = Sol;
            tmp = newSol(j, r);
            newSol(j, r) = newSol(i, r);
            newSol(i, r) = tmp;

            % New costs
            [newTotCost, ~] = CalculateCost(Sol(r, :), Data);
            newSolCost = SolCost;
            newSolCost(r) = newTotCost;
            
            if newTotCost < bestCandidateCost
                % Aspiration Criteria
                newCost = sum(newSolCost);
                if newCost < BestCost
                    bestCandidateSol = newSol;
                    bestCandidateCost = sum(newSolCost);
                    AddTabuMove = true;
                    tabuEi = [i Sol(i, r) r];
                    tabuEj = [j Sol(j, r) r];
                    continue
                end
                
                % Check to see if move is in tabu list
                if TabuEdges(i, Sol(i, r), r) > 0 || ...
                        TabuEdges(j, Sol(j, r), r) > 0
                    continue
                end
                
                % Non tabu move, update candidate
                bestCandidateSol = newSol;
                bestCandidateCost = sum(newSolCost);
                AddTabuMove = true;
                tabuEi = [i Sol(i, r) r];
                tabuEj = [j Sol(j, r) r];
            end
        end
    end
end

% 2. Find all swaps with points in other receivers
for r = 1:NumReceivers
    for i = 1:NumPoints
        if Sol(i, r) == 0
            break
        end

        for rc = 1:NumReceivers
            if rc == r
                continue
            end
            
            for j = 1:NumPoints
                if Sol(j, rc) == 0
                    break
                end
                
                % Swap
                newSol = Sol;
                tmp = newSol(j, rc);
                newSol(j, rc) = newSol(i, r);
                newSol(i, r) = tmp;

                % New Costs
                [newTotCost, newCosts] = ...
                    CalculateCost(Sol([r, rc], :), Data);
                newSolCost = SolCost;
                newSolCost(r) = newCosts(1);
                newSolCost(rc) = newCosts(2);
                
                if newTotCost < bestCandidateCost
                    % Aspiration Criteria
                    newCost = sum(newSolCost);
                    if newCost < BestCost
                        bestCandidateSol = newSol;
                        bestCandidateCost = sum(newSolCost);
                        AddTabuMove = true;
                        tabuEi = [i Sol(i, r) r];
                        tabuEj = [j Sol(j, rc) rc];
                        continue
                    end

                    % Check to see if move is in tabu list
                    if TabuEdges(i, Sol(i, r), r) > 0 || ...
                            TabuEdges(j, Sol(j, rc), rc) > 0
                        continue
                    end

                    % Non tabu move, update candidate
                    bestCandidateSol = newSol;
                    bestCandidateCost = sum(newSolCost);
                    AddTabuMove = true;
                    tabuEi = [i Sol(i, r) r];
                    tabuEj = [j Sol(j, rc) rc];
                end
            end
        end
    end
end


% 3. Find all insertions into other receivers
for r = 1:NumReceivers
    for i = 1:NumPoints
        if Sol(i, r) == 0
            break
        end
        
        for rc = 1:NumReceivers
            if r == rc
                continue
            end
            
            for j = 1:NumPoints
                if Sol(j, rc) == 0
                    break
                end
                
                % Remove and insert
                newSol = Sol;
                tmp = newSol(i, r);
                newr = newSol(r, :);
                newr = [newr(1:i-1) newr(1:i+1) 0];
                newrc = newSol(rc, :);
                newrc = [newrc(1:j-1) tmp newrc(j:end)];
                newSol(r, :) = newr;
                newSol(rc, :) = newrc;

                % New Costs
                [newTotCost, newCosts] = ...
                    CalculateCost(Sol([r, rc], :), Data);
                newSolCost = SolCost;
                newSolCost(r) = newCosts(1);
                newSolCost(rc) = newCosts(2);
                
                if newTotCost < bestCandidateCost
                    % Aspiration Criteria
                    newCost = sum(newSolCost);
                    if newCost < BestCost
                        bestCandidateSol = newSol;
                        bestCandidateCost = sum(newSolCost);
                        AddTabuMove = true;
                        tabuEi = [i Sol(i, r) r];
                        tabuEj = [0 0 0];
                        continue
                    end

                    % Check to see if move is in tabu list
                    if TabuEdges(i, Sol(i, r), r) > 0
                        continue
                    end

                    % Non tabu move, update candidate
                    bestCandidateSol = newSol;
                    bestCandidateCost = sum(newSolCost);
                    AddTabuMove = true;
                    tabuEi = [i Sol(i, r) r];
                    tabuEj = [0 0 0];
                end
            end
        end 
    end
end
    

% Update tabu structure
TabuMoves = TabuMoves - 1;
TabuMoves(TabuMoves<0) = 0;

% Add new edges to the tabu list (if any)
if AddTabuMove
    % When an edge is added to the tree, it should not be removed from the 
    % tree during the next TabuLenght iterations
    TabuMoves(tabuEi(1), tabuEi(2), tabuEi(3)) = TabuLength;
    if tabuEj(1) > 0
        TabuMoves(tabuEj(1), tabuEj(2), tabuEj(3)) = TabuLength;
    end
end

end

function [TotalCost, Cost] = CalculateCost(Sol, Data)
% This function outputs the cost of each receiver and the total cost
[p, r] = size(Sol);
Cost = zeros(1, r);
for tour = 1:r
    % Calculate cost of a single tour 
    % Find sum of cost of adjacent 
    for i = 1:p-1
        Cost(tour) = Cost(tour) + Data(Sol(i, tour), Sol(i+1, tour));
    end
end
TotalCost = sum(Cost);
end
