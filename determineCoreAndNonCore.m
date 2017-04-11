function [core,noncore] = determineCoreAndNonCore(clustering,centroids)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

[~,largestCentroidIndex] = max(centroids);

core = clustering(clustering(:,3) == largestCentroidIndex,:);

noncore = clustering;

noncore(noncore(:,3)  == largestCentroidIndex,:) = [];

end

