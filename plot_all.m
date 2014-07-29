[~,best, out] = ga(costs, 100, 20, .9, .1, 51, 2)
[~,best2, out2] = ga(costs, 100, 20, .87, .91, 51, 2)
phandle(1) = plot(out, colours(1), 'LineWidth', 2)
hold on
phandle(2) = plot(out2, colours(2), 'LineWidth', 2)
title('Shit be cray')
xlabel('iteration')
ylabel('cost')
legend(phandle, 'ga-1', 'ga-2')
hold off
