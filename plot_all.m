colours = ['b' 'g' 'r' 'y' 'c'];
phandle = [];
idx = 1;
out = [];

addpath '.'
addpath 'ga'
addpath 'ts'
addpath 'sa'
addpath 'aco'
addpath 'pso'

hold off

[~,best2, gaOut] = ga(costs, 50, 20, .91, .91, 51, 2);
phandle(1) = plot(gaOut, colours(1), 'LineWidth', 2);
title('Cost Analysis')
xlabel('iteration')
ylabel('cost')
hold on
[~, l, acoOut] = ant_colony_optimization(costs, 50, 51, 5, 12, 0.01, 1, 1, 0.15, 0.8850);
haxes1 = gca;
haxes1_pos = get(haxes1,'Position'); % store position of first axes
phandle(2) = line(1:size(acoOut, 2), acoOut, 'Parent', haxes1, 'Color', colours(2), 'LineWidth', 2);
haxes2 = axes('Position',haxes1_pos,...
              'XAxisLocation','top',...
              'YAxisLocation','right',...
              'Color','none');
set(haxes2,'XColor','r','YColor','r')
[~, l, saOut, saIter] = simulated_annealing(costs, I, 0.9, 0.8, 10E-10, 100);
phandle(3) = line(1:size(saOut, 2), saOut, 'Parent', haxes2, 'Color', colours(3), 'LineWidth', 2);
[~, l, tsOut] = tabu_search(costs, 30, 5, 10, I);
phandle(4) = plot(tsOut, colours(4), 'LineWidth', 2);
[~, l, psoOut] = new_pso(costs, 150, 125, 51, 4, 0.4, 2, 2, 25);
phandle(5) = line(1:size(psoOut, 2), psoOut, 'Parent', haxes1, 'Color', colours(5), 'LineWidth', 2);
legend(phandle, 'ga', 'aco', 'sa', 'ts', 'pso')
hold off
