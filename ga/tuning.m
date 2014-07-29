
BestCost = Inf;
bestpCross = Inf;
bestpMut = Inf;
bestPop = Inf;
A = 0.5:0.1:0.9;
B = 0.5:0.1:0.9;
C = 10:5:25;
M = zeros(numel(A), numel(B), numel(C));
for pCross = A
    for pMut = B
	for pop = C
		Y = zeros(1, 3);
		for idx = 1:numel(Y)
		    [S C] = ga(costs, 50, pop, pCross, pMut, 51, 2)
		    Y(idx) = C;
		    if C < BestCost
			bestpCross = pCross;
			bestpMut = pMut;
			bestPop = pop;
		    end
		end
		M((pCross - 0.5)/0.1 + 1, (pMut - 0.5)/0.1 + 1, (pop - 10)/5 + 1) = mean(Y);
	end
    end
end

I = [34    1   35   30   37   43   50    4   15   25   11   47   14   21    0   44   49   46    8   42   40   26    2   33 12   18   51    5   10   45   20    7   16   39   41   23   13   31    6   32   29    3   48    0   19   17   38   28 24    9   36    0   22   27];
