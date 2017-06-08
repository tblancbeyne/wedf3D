function [core,noncore,centroids] = computeStepOneClustering(initialClustering,centroids,ics)
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

% Using the gap analysis to get the number of clusters to use
optimalK = zeros(10,1);
for i=1:10
    eva = evalclusters(noncoreICS(:,2),'kmeans','gap','KList',1:12);
%    eva = evalclusters(noncore(:,2),'kmeans','gap','KList',1:7);
    optimalK(i) = eva.OptimalK;
end
optimalK = mode(optimalK);

% For experiments
% % if size(noncoreICS,1) >= 6
%   optimalK = 3;
% % else
% %    optimalK = size(noncoreICS,1);
% end
%optimalK = 6;

% Dividing the non belonging to main shape ics points WEDF values to
% perform the Kmeans clustering with initial seeds
% First : dividing the points to cluster into optimalK bins
percentiles = zeros(optimalK+1,1);

percentiles(1) = min(noncoreICS(:,2));

for i=1:optimalK-1
    percentiles(i+1) =  prctile(noncoreICS(:,2),100.0/(optimalK-1)*i);
end

% Sometimes 100.0/(optimalK-1)*(optimalK-1) is a bit greater than 100
% because of the machine precision
percentiles(optimalK+1) =  prctile(noncoreICS(:,2),100.0);

% Second : computing the seeds that will be used in the Kmeans clustering
seeds = zeros(optimalK,1);
for i=1:size(optimalK,1)
    seeds(i) = (percentiles(i) + percentiles(i+1))/2;
end

% Performin kmeans clustering
[~,centroids] = kmeans(noncoreICS(:,2),optimalK,'Start',seeds);

% Sorting the centroids by increasing value
centroids = [sort(centroids);mainShapeCentroid];

% Performing the lcustering of all remeaning WEDF points
for i=1:size(noncore,1)
        [~,noncore(i,3)] = min(abs(centroids-noncore(i,2)));
end

end

