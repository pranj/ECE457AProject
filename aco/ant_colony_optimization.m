function [LowestCostPath, LowestCostSoFar] = ...
    ant_colony_optimization(Costs, MaxIterationsWithoutChange, NumPoints, NumReceivers, ...
                            NumAnts, InitialPheromone, Alpha, Beta, EvaporationRate, Ro)

[AugmentedCostMatrix, NumArtificialPoints] = augment_cost_matrix(Costs, NumPoints, NumReceivers);

FirstDepot = NumPoints + 1;
EdgeDesirability = AugmentedCostMatrix.^(-1 * Beta);
PheromoneConcentration = InitialPheromone * ones(size(AugmentedCostMatrix));

LowestCostSoFar = Inf;
LowestCostPath = zeros(1, NumArtificialPoints);


CurrentIteration = 1;
LastChangeIteration = 1;

plot_points = zeros(50, 1);

while CurrentIteration - LastChangeIteration < MaxIterationsWithoutChange
    N = ones(NumAnts, NumArtificialPoints);
    IterationLowestCostSoFar = Inf;
    IterationLowestCostPath = zeros(1, NumArtificialPoints);
    for CurrentAnt = 1:NumAnts
        CurrentPath = zeros(1, NumArtificialPoints);
        CurrentPath(1) = FirstDepot;
        for iCurrentPoint = 1:NumArtificialPoints
            CurrentPoint = CurrentPath(iCurrentPoint);
            N(CurrentAnt, CurrentPoint) = 0;
            UnvisitedNeighbours = find(N(CurrentAnt, :));
            P = zeros(1, size(UnvisitedNeighbours, 2));
            for idx = 1:numel(UnvisitedNeighbours)
                neigbour = UnvisitedNeighbours(idx);
                P(idx) = (PheromoneConcentration(CurrentPoint, neigbour) ^ Alpha) ...
                                * EdgeDesirability(CurrentPoint, neigbour);
            end

            r = rand(1, 1);
            if r < Ro && iCurrentPoint < NumArtificialPoints
                [MaxValue, MaxIdx] = max(P);
                CurrentPath(iCurrentPoint + 1) = UnvisitedNeighbours(MaxIdx);
            else
                TotalWeight = sum(P);
                if TotalWeight == 0
                    P = ones(1, size(UnvisitedNeighbours, 2));
                else
                    for idx = 1:numel(UnvisitedNeighbours)
                        P(idx) = P(idx) / TotalWeight;
                    end
                end

                RouletteWheel = cumsum(P);
                r = rand(1, 1);
                for idx = 1:numel(UnvisitedNeighbours)
                    if r <= RouletteWheel(idx)
                        CurrentPath(iCurrentPoint + 1) = UnvisitedNeighbours(idx);
                        break
                    end
                end
            end
        end

        NormalizedCurrentPath = normalize_path(CurrentPath, NumPoints);
        CurrentCost = calculate_cost(NormalizedCurrentPath, AugmentedCostMatrix, AugmentedCostMatrix(end, :));
        if CurrentCost < IterationLowestCostSoFar
            IterationLowestCostPath = CurrentPath;
            IterationLowestCostSoFar = CurrentCost;
        end

        if CurrentCost < LowestCostSoFar
            LowestCostPath = CurrentPath;
            LowestCostSoFar = CurrentCost;
            LastChangeIteration = CurrentIteration;
        end
        
        plot_points(CurrentIteration) = LowestCostSoFar;
        plot(plot_points)
        drawnow
    end

    PheromoneConcentration = PheromoneConcentration * (1 - EvaporationRate);
    PheromoneDeposit = 1 / IterationLowestCostSoFar;
    for idx = 1:numel(IterationLowestCostPath) - 1
        PheromoneConcentration(IterationLowestCostPath(idx), IterationLowestCostPath(idx + 1)) = ...
            PheromoneConcentration(IterationLowestCostPath(idx), IterationLowestCostPath(idx + 1)) + PheromoneDeposit;
    end

    CurrentIteration = CurrentIteration + 1;
end

LowestCostPath = normalize_path(LowestCostPath, NumPoints);
end

function [NormalizedPath] = normalize_path(Path, NumPoints)
    NormalizedPath = Path;
    for idx = 1:numel(NormalizedPath)
        if NormalizedPath(idx) > NumPoints
            NormalizedPath(idx) = 0;
        end
    end
end

function [AugmentedMatrix, AugmentedSize] = augment_cost_matrix(Costs, NumPoints, NumReceivers)
    AugmentedSize = NumPoints + NumReceivers;
    AugmentedMatrix = zeros(AugmentedSize, AugmentedSize);

    for idx = 1:AugmentedSize
        if idx > NumPoints + 1
            X = cat(1, Costs(:, NumPoints + 1), Inf * ones(AugmentedSize - (NumPoints + 1), 1));
            AugmentedMatrix(:, idx) = X;
            AugmentedMatrix(idx, :) = AugmentedMatrix(NumPoints + 1, :);
        else
            X = cat(1, Costs(:, idx), zeros(AugmentedSize - (NumPoints + 1), 1));
            AugmentedMatrix(:, idx) = X;
        end
    end
end