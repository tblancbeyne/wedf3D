function [edgeCounter] = countEdgesAppearances(edges)
%%
%COUNTEDGESAPPEARANCES Counts the appearances of an edge in the list of
%edges.
%   [edgeCounter] = countEdgesAppearances(edges) counts the appearances of 
%   each edge in the list of edges given by edges.


% Initialization
edgeCounter = [];

% Sort for easier computation
sortedEdges = sortrows(edges);

% Count same edges
prevEdge=zeros(1,2);

% Loop on the edges
for i = 1:size(sortedEdges,1)
    curEdge = sortedEdges(i,:);
    if prevEdge == curEdge % still the same edge
        sizeCount = size(edgeCounter);
        edgeCounter(sizeCount(1),3) = edgeCounter(sizeCount(1),3) + 1;
    else % new edge
        edgeCounter = vertcat(edgeCounter, [curEdge, 1]);
    end
    prevEdge = curEdge;  
end

end

