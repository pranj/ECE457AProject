function [LowestCostPath, LowestCostSoFar] = ...
    ant_colony_optimization(Costs, StartPoint, NumIterations, NumPoints, NumReceivers, InitialPheromone, Alpha, Beta, EvaporationRate)

NumArtificialPoints = NumPoints + NumReceivers - 1;
EdgeDesirability = Costs.^(-1 * Beta);
PheromoneConcentration = InitialPheromone * ones(size(Costs));

LowestCostSoFar = Inf;
LowestCostPath = zeros(1, NumArtificialPoints);

for k = 1:NumIterations
    N = ones(NumReceivers, NumArtificialPoints);
    IterationLowestCostSoFar = Inf;
    IterationLowestCostPath = zeros(1, NumArtificialPoints);

    for CurrentReceiver = 1:NumReceivers
        CurrentPath = zeros(1, NumArtificialPoints);
        CurrentPath(1) = StartPoint;
        for iCurrentPoint = 1:NumArtificialPoints
            CurrentPoint = CurrentPath(iCurrentPoint);
            N(CurrentReceiver, CurrentPoint) = 0;
            UnvisitedNeighbours = find(N(CurrentReceiver, :));
            P = zeros(1, size(UnvisitedNeighbours, 2));
            for idx = 1:numel(UnvisitedNeighbours)
                neigbour = UnvisitedNeighbours(idx);
                if neigbour == CurrentPoint
                    P(idx) = 0;
                else
                    P(idx) = (PheromoneConcentration(CurrentPoint, neigbour) ^ Alpha) * EdgeDesirability(CurrentPoint, neigbour);
                end
            end

            TotalWeight = sum(P);
            for idx = 1:numel(UnvisitedNeighbours)
                if UnvisitedNeighbours(idx) == CurrentPoint
                    P(idx) = 0;
                else
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


        NormalizedCurrentPath = NormalizePath(CurrentPath, NumPoints);
        CurrentCost = calculate_cost(NormalizedCurrentPath, Costs, Costs(end, :));
        if CurrentCost < IterationLowestCostSoFar
            IterationLowestCostPath = CurrentPath;
            IterationLowestCostSoFar = CurrentCost;
        end

        if CurrentCost < LowestCostSoFar
            LowestCostPath = CurrentPath;
            LowestCostSoFar = CurrentCost;
        end
    end

    PheromoneConcentration = PheromoneConcentration * (1 - EvaporationRate);
    PheromoneDeposit = 1 / IterationLowestCostSoFar;
    for idx = 1:numel(IterationLowestCostPath) - 1
        PheromoneConcentration(IterationLowestCostPath(idx), IterationLowestCostPath(idx + 1)) += PheromoneDeposit;
    end
end

LowestCostPath = NormalizePath(LowestCostPath, NumPoints);
PheromoneConcentration
end


function [NormalizedPath] = NormalizePath(Path, NumPoints)
    NormalizedPath = Path;
    for idx = 1:numel(NormalizedPath)
        if NormalizedPath(idx) > NumPoints
            NormalizedPath(idx) = 0;
        end
    end
end