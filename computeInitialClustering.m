function [clustering,centroids,initialClusteringSet] = computeInitialClustering(edgesSk,WEDF)
%% Computing the initial clustering step: determining the main shape

% Initial clustering set is computed : it consists in the junction points
% and their neighbors
initialClusteringSet = findInitialClusteringSet(edgesSk);

% A Kmeans clustering is performed on this set to determine which points
% belong to the main shape and which point doesn't
if ~isempty(initialClusteringSet)
    [currClusters,centroids] = kmeans(WEDF(initialClusteringSet(:)),2,'Start',vertcat(min(WEDF(initialClusteringSet(:))),max(WEDF(initialClusteringSet(:)))));
    cluster = zeros(size(WEDF,1),1);
    currClusters = horzcat(initialClusteringSet,WEDF(initialClusteringSet(:)),currClusters);
    for i=1:size(WEDF,1)
        [~,cluster(i)] = min(abs(centroids-WEDF(i)));
    end

    % For testing
%     for i=1:size(currClusters,1) 
%         assert(currClusters(i,3) == cluster(initialClusteringSet(i)));
%     end

    clustering = horzcat([1:size(WEDF,1)]',WEDF,cluster);
else
    cluster = ones(size(WEDF,1),1);
    centroids = mean(WEDF);
    clustering = horzcat([1:size(WEDF,1)]',WEDF,cluster);
end

