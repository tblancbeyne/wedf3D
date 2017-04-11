function [WEDF] = computeWEDF(tetCenters,tetrahedralization,WEDFPrev)
%%
%COMPUTEWEDF computes the wedf value of a point.
%   [WEDF] = computeWEDF(points,tetrahedralization,prevValue) computes
%   the WEDF value of a point using a tretrahedralization of the shape and
%   the list of points whose tetrahedron volume has to be added to the 
%   prevValue.

% Initialization
WEDF = WEDFPrev;

% Computing the WEDF of the point
for i=1:size(tetCenters,1)
    for j=1:size(tetrahedralization.LinkTetMedial,1)
        % For each tetrahedron on the path to boundary of the endpoint
        % i, it adds its volume to the WEDF of i and marks it as
        % assigned
        if tetrahedralization.LinkTetMedial(j,1) == tetCenters(i)
            tetrahedronVert = tetrahedralization.Points(tetrahedralization.ConnectivityList(j,:),:);
            volumeTet = computeTetVolume(tetrahedronVert);
            WEDF = WEDF + volumeTet; % Adding the wolume to the WEDF
            %break;
        end
    end
end


end

