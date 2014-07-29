colours = ['r' 'g' 'b' 'o' 'p'];
phandle = [];
idx = 1;
out = [];

[~,best2, out(1)] = ga(costs, 100, 20, .91, .91, 51, 2);
[~, l, out(2)] = ant_colony_optimization(Costs, 50, 51, 5, 12, 0.01, 1, 1, 0.15, 0.8850);
[~, l, out(3)] = simulated_annealing(costs, bSol, 0.9, 0.8, 10E-10, 100);
phandle(1) = plot(out(1), colours(1), 'LineWidth', 2);
hold on
phandle(2) = plot(out(2), colours(2), 'LineWidth', 2);
phandle(3) = plot(out(3), colours(3), 'LineWidth', 2);
title('Cost Analysis')
xlabel('iteration')
ylabel('cost')
legend(phandle, 'ga', 'aco', 'sa', 'ts')
hold off
