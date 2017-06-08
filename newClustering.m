function [clustering,centroids] = newClustering(edgesSk,WEDF)
%% Testing a new clustering process

clustering = zeros(size(WEDF,1),3);

clustering(:,1:2) = [[1:size(WEDF,1)]',WEDF];

initialClusteringSet = findInitialClusteringSet(edgesSk);
if ~isempty(initialClusteringSet)
    
    initialWEDF = WEDF(initialClusteringSet);
    
    % Using the gap analysis to get the number of clusters to use
    optimalK = zeros(10,1);
    for i=1:10
        eva = evalclusters(initialWEDF,'kmeans','gap','KList',1:12);
        optimalK(i) = eva.OptimalK;
    end
    optimalK = mode(optimalK);
     
    % Dividing the WEDF values to perform the Kmeans clustering with initial seeds
    % First : dividing the points to cluster into optimalK bins
    percentiles = zeros(optimalK+1,1);
    percentiles(1) = min(initialWEDF);
    for i=1:optimalK-1
        percentiles(i+1) =  prctile(initialWEDF,100.0/(optimalK-1)*i);
    end
    % Sometimes 100.0/(optimalK-1)*(optimalK-1) is a bit greater than 100
    % because of the machine precision
    percentiles(optimalK+1) =  prctile(initialWEDF,100.0);

    % Second : computing the seeds that will be used in the Kmeans clustering
    seeds = zeros(optimalK,1);
    for i=1:size(optimalK,1)
        seeds(i) = (percentiles(i) + percentiles(i+1))/2;
    end

    % Performin kmeans clustering
    [~,centroids] = kmeans(initialWEDF,optimalK,'Start',seeds);

   % Sorting the centroids by increasing value
    centroids = sort(centroids);

    % Performing the clustering of all remeaning WEDF points
    for i=1:size(WEDF,1)
    	[~,clustering(i,3)] = min(abs(centroids-WEDF(i)));
    end
    
    % A second Kmeans clustering is performed on this set to determine which
    %points belong to the main shape and which point doesn't
    [~,centroids2] = kmeans(WEDF(initialClusteringSet(:)),2,'Start',vertcat(min(WEDF(initialClusteringSet(:))),max(WEDF(initialClusteringSet(:)))));
    cluster2 = zeros(size(WEDF,1),1);
    for i=1:size(WEDF,1)
        [~,cluster2(i)] = min(abs(centroids2-WEDF(i)));
    end

    % For testing
%     for i=1:size(currClusters,1) 
%         assert(currClusters(i,3) == cluster(initialClusteringSet(i)));
%     end

    clustering(cluster2(:) == 2,3) = optimalK;
    
else
    cluster = ones(size(WEDF,1),1);
    centroids = mean(WEDF);
    clustering = horzcat([1:size(WEDF,1)]',WEDF,cluster);
end



end

