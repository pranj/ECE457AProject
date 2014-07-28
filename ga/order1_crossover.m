function [Child1 Child2] = order1_crossover(Parent1, Parent2)
    ChromosomeLength = size(Parent1, 2);

    PossibleIntervals = nchoosek(1:ChromosomeLength, 2);
    NumPossibleIntervals =  size(PossibleIntervals, 1);
    ChosenIndex = fix((NumPossibleIntervals - 1)*rand(1,1) + 1);
    ChosenInterval = PossibleIntervals(ChosenIndex, :);
    ChosenInterval

    Child1 = child(Parent1, Parent2, ChromosomeLength, ChosenInterval);
    Child2 = child(Parent2, Parent1, ChromosomeLength, ChosenInterval);

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
