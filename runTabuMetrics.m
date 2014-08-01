function [ final_solutions, tabu_lengths, converge_times ] = runTabuMetrics( costs, intial_sol )
    receivers = 4;
    
    final_solutions = zeros(1, 11);
    converge_times = zeros(1, 11);
    tabu_lengths = zeros(1, 11);
    
    for n = 0:5:50
        [matrix, sol] = tabu_search(costs, n, receivers, intial_sol);
        if n == 0
            final_solutions(1) = sol;
            tabu_lengths(1) = sol;
            converge_times(1) = time;
        else
            final_solutions(n) = sol;
            tabu_lengths(n) = n;
            converge_times(n) = time;
        end
    end
end

