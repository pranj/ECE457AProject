function [Child1 Child2] = order1_crossover(Parent1, Parent2)
    ChromosomeLength = size(Parent1, 2);

    % we don't want the full parent to be chosen
    % so we union 1:end-1 and 2:end 
    PossibleIntervals = nchoosek(1:ChromosomeLength-1, 2);
    PossibleIntervals = union(PossibleIntervals, nchoosek(2:ChromosomeLength, 2), 'rows');

    NumPossibleIntervals =  size(PossibleIntervals, 1);
    ChosenIndex = fix((NumPossibleIntervals - 1)*rand(1,1) + 1);
    ChosenInterval = PossibleIntervals(ChosenIndex, :);

    Parent1 = alias(Parent1);
    Parent2 = alias(Parent2);
    Child1 = child(Parent1, Parent2, ChromosomeLength, ChosenInterval);
    Child2 = child(Parent2, Parent1, ChromosomeLength, ChosenInterval);
    Child1 = unalias(Child1);
    Child2 = unalias(Child2);
end

function [Parent] = alias(Parent) 
	idx = -1;
	for i = 1:size(Parent, 2)
		if(Parent(i) == 0)
			Parent(i) = idx;
			idx = idx - 1;
		end
	end
end

function [Child] = unalias(Child)
	for i = 1:size(Child, 2)
		if(Child(i) < 0)
			Child(i) = 0;
		end
	end
end

function [Child] = child(Parent1, Parent2, ChromosomeLength, ChosenInterval)
    Child = zeros(1, ChromosomeLength);
    Child(ChosenInterval(1):ChosenInterval(2)) = Parent1(ChosenInterval(1):ChosenInterval(2));

    LeftOut = horzcat(Parent1(1:(ChosenInterval(1) - 1)), Parent1((ChosenInterval(2) + 1):ChromosomeLength));


    X = find(ismember(Parent2, LeftOut) > 0);
    WriteIdx = 1;
    for i = 1:ChromosomeLength
        if i < ChosenInterval(1) || i > ChosenInterval(2)
            Child(i) = Parent2(X(WriteIdx));
            WriteIdx = WriteIdx + 1;
        end
    end
end
