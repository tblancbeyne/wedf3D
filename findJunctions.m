function [junctions] = findJunctions(edges)
%FINDJUNCTIONS Summary of this function goes here
%  sortedEdges : edges previously sorted with sortEdge(edges)

vertCounter = zeros(max(max(edges)),1);

for i=1:size(edges,1)
    vertCounter(edges(i,1)) = vertCounter(edges(i,1)) + 1; 
    vertCounter(edges(i,2)) = vertCounter(edges(i,2)) + 1; 
end

junctions = find(vertCounter(:) >= 3);