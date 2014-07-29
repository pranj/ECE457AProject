colours = ['r' 'g' 'b' 'o' 'p'];
phandle = [];
idx = 1;
out = [];

[~,best2, gaOut] = ga(costs, 100, 20, .91, .91, 51, 2);
handle(1) = plot(gaOut, colours(1), 'LineWidth', 2);
ptitle('Cost Analysis')
xlabel('iteration')
ylabel('cost')
legend(phandle, 'ga', 'aco', 'sa', 'ts')
hold on
[~, l, acoOut] = ant_colony_optimization(Costs, 50, 51, 5, 12, 0.01, 1, 1, 0.15, 0.8850);
[~, l, saOut] = simulated_annealing(costs, bSol, 0.9, 0.8, 10E-10, 100);
phandle(2) = plot(acoOut, colours(2), 'LineWidth', 2);
phandle(3) = plot(saOut, colours(3), 'LineWidth', 2);
hold off
