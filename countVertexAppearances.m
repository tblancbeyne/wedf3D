function [vertexAppearances] = countVertexAppearances(edges,nbVert)
%COUNTVERTEXAPPEARANCES counts the appearances of each vertex as an
%edge's extremity.
%   COUNTVERTEXAPPEARANCES(edges,nbVert) counts the appearances of the
%   vertices as an edge's extremity.

% Initialization
vertexAppearances = zeros(nbVert,1);

% Count vertex appearances: one per edge it appears
for i=1:size(edges,1)
    vertexAppearances(edges(i,1)) = vertexAppearances(edges(i,1)) + 1;
    vertexAppearances(edges(i,2)) = vertexAppearances(edges(i,2)) + 1;
end

end

