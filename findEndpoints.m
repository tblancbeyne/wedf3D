function [endPoints] = findEndpoints(edges, nbVertices)
%%
%FINDENDPOINTS finds the extremities of a set of curves.
%   [endPoints] = FINDENDPOINTS(edges) finds the extremities of a set of 
%   curves given as a set of edges.
%   [endPoints] = FINDENDPOINTS(edges,nbVertices) finds the extremities of 
%   a set of curves given as a set of edges. Even vertices that doesn't
%   belong to any edge will be taken into account.


% Initialization
% endPoints = [];

% Getting an approximate number of vertices if needed, it is approximate
% because some vertices may not belong to any edge (take care when using
% it)
if nargin == 1 && ~isempty(edges)
    edgesTemp = edges(:,1:2);
    nbVertices = max(edgesTemp(:));
end

% Computing the appearances of each vertex to find extremities : vertices 
% that appear once or less
vertAppearances = countVertexAppearances(edges,nbVertices);

% Finding extremities : vertices appearing ONCE or less
endPoints = find(vertAppearances<=1);

end


