function [costs] = run_pso(CostData)
    costs = zeros(5, 4);
    

    InertiaWeight = 0.5;
    CognitiveAccel = 0.5;
    SocialAccel = 0.5;
    MaxVelocity = 10;
    
    NumParticle = 100;
    NumIterations = 100;
    NumReceivers = 5;
    NumPoints = 51;
    
    params = [MaxVelocity InertiaWeight CognitiveAccel SocialAccel];
    change = [8 0.1 0.2 0.2];
    
    NumOfRuns = 4;
    for i = 1:4
        for k = 1:5
            total = 0;
            cost = 0;
            for j = 1:NumOfRuns
                [~, cost] = ...
                    new_pso(CostData, NumIterations, NumParticle, ...
                    NumPoints, NumReceivers, InertiaWeight, ...
                    CognitiveAccel, SocialAccel, MaxVelocity);
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