function [branches] = getBranches(edgesSk)

endPoints = findEndpoints(edgesSk);
juncPoints = findJunctions(edgesSk);

branches = cell(0);

while ~isempty(endPoints) || ~isempty(juncPoints)
    branch = [];
    if ~isempty(endPoints)
        currPoint = endPoints(1);
        endPoints(1) = [];
    elseif ~isempty(juncPoints)
        i = 1;
        while ~isEndPoint(juncPoints(i),edgesSk)
            i = i + 1;
            if i > length(juncPoints)
                disp('Loop in the skeleton... Aborting');
                return;
            end
        end
        currPoint = juncPoints(i)
        juncPoints(i) = [];
    else
        break;
    end
    if isempty([endPoints;juncPoints])
        break;
    end

    branch = [branch;currPoint];

    while isempty(find(endPoints(:) == currPoint)) && isempty(find(juncPoints(:) == currPoint))
        currChild = findChild(edgesSk,currPoint);
        edgesSk = updateSkeleton(currPoint,edgesSk);
        currPoint = currChild;
        branch = [branch;currPoint]
    end

    endPoints(endPoints(:) == currPoint) = [];
    branches = [branches,branch];
end

end
