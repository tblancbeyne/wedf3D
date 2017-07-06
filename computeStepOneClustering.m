function [core,noncore,centroids] = computeStepOneClustering(initialClustering,centroids,ics,clusterNumber)
%% Computing the step one of the clustering presented in the 2D paper
% This function takes as parameters :
%    - The ini 
%
% This function returns :
        

% Getting the main shape centroid
mainShapeCentroid = centroids(2);

% Determining the main shape in the initial clustering (core), this main 
% shape is not only calculated on the initial clusetring set (ics)
[core,noncore] = determineCoreAndNonCore(initialClustering,centroids);

% Determining the points in the ics that do noot belong to the main shape
noncoreICS = determineNonCoreICS(noncore,ics);

% Dividing the non belonging to main shape ics points WEDF values to
% perform the Kmeans clustering with initial seeds
% First : dividing the points to cluster into optimalK bins
percentiles = zeros(clusterNumber,1);

percentiles(1) = min(noncoreICS(:,2));

for i=1:clusterNumber-2
    percentiles(i+1) =  prctile(noncoreICS(:,2),100.0/(clusterNumber-2)*i);
end

% Sometimes 100.0/(clusterNumber-1)*(clusterNumber-1) is a bit greater than 100
% because of the machine precision
percentiles(clusterNumber) =  prctile(noncoreICS(:,2),100.0);

% Second : computing the seeds that will be used in the Kmeans clustering
seeds = zeros(clusterNumber-1,1);
for i=1:size(clusterNumber-1,1)
    seeds(i) = (percentiles(i) + percentiles(i+1))/2;
end

% Performin kmeans clustering
[~,centroids] = kmeans(noncoreICS(:,2),clusterNumber-1,'Start',seeds);

% Sorting the centroids by increasing value
centroids = [sort(centroids);mainShapeCentroid];

% Performing the lcustering of all remeaning WEDF points
for i=1:size(noncore,1)
        [~,noncore(i,3)] = min(abs(centroids-noncore(i,2)));
end

end

