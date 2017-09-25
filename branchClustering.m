function [clusters] = branchClustering(clusters,edgesSk)

branches = getBranches(edgesSk);

if length(branches) == 1
    return;
end

mainShape = find(clusters(:) == max(clusters));

oldClusters = clusters;
clusters = zeros(length(clusters),1);
nbPrevClusters = 0;

for i=1:length(branches)
    clusters(branches{i}) = oldClusters(branches{i}) + nbPrevClusters;
    nbPrevClusters = max(clusters);
end

clusters(mainShape(:)) = nbPrevClusters;
