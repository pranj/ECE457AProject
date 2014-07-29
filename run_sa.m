function [costs] = run_sa(CostData, InitialSoln)
    costs = zeros(5, 3);
    
    Alpha = 0.75;
    InitProb = 0.75;
    IterationsPerTemperature = 25;
    
    params = [Alpha InitProb IterationsPerTemperature];
    change = [0.045 0.045 325];
    
    NumOfRuns = 10;
    for i = 1:3
        for k = 1:5
            total = 0;
            cost = 0;
            for j = 1:NumOfRuns
                [~, cost] = ...
                    simulated_annealing(CostData, InitialSoln, Alpha, ...
                        InitProb, 10e-7, IterationsPerTemperature);
                total = total + cost;
            end
            costs(k, i) = total/NumOfRuns;
            params(i) = params(i) + change(i);
        end
        [~, idx] = min(costs(:, i));
        params(i) = params(i) - (6-idx)*change(i);
    end
    disp(params);
end
