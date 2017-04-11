function [initialClusteringSet] = findInitialClusteringSet(edges)
% Finds the initial clustering set, which is composed of the junction
% points and their neighbors

junctions = findJunctions(edges);

initialClusteringSet = [];

for i=1:size(junctions,1)
    currPoints = edges(edges(:,1) == junctions(i) | edges(:,2) == junctions(i),:);
    initialClusteringSet = vertcat(initialClusteringSet,currPoints(:));
end

initialClusteringSet = unique(initialClusteringSet);
