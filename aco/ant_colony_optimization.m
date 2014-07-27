function [LowestCostPath, LowestCostSoFar] = ...
    ant_colony_optimization(Costs, NumIterations, NumPoints, NumReceivers, ...
                            NumAnts, InitialPheromone, Alpha, Beta, EvaporationRate, Ro)

NumArtificialPoints = NumPoints + NumReceivers;
FirstDepot = NumPoints + 1;
EdgeDesirability = Costs.^(-1 * Beta);
PheromoneConcentration = InitialPheromone * ones(size(Costs));
LowestCostSoFar = Inf;
LowestCostPath = zeros(1, NumArtificialPoints);

for iteration = 1:NumIterations
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
                for idx = 1:numel(UnvisitedNeighbours)
                    P(idx) = P(idx) / TotalWeight;
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