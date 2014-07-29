function [ final_solutions, tabu_lengths ] = runTabuMetrics( costs, start_point, end_point, intial_sol )
    receivers = 4;
    iterations = 50;
    
    final_solutions = zeros(1, end_point - start_point + 1);
    tabu_lengths = zeros(1, end_point - start_point + 1);
    
    for n = start_point:5:end_point
        trials = zeros(1,3);
        for k = 1:3
            [matrix, sol] = tabu_search(costs, n, iterations, receivers, intial_sol);
            trials(k) = sol;  
        end
        
        final_solutions(n) = mean(trials)
        tabu_lengths(n) = n;
    end
end

