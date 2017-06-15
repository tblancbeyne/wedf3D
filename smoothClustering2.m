function [faces,vertices,faceClustering] = smoothClustering2(faces,index,vertices,verticesSk,clustering,faceClustering,medians,clust)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

[faces,vertices] = divideFace2(faces,index,vertices,verticesSk,clustering,medians,clust);

faceClustering = [faceClustering;[0;0;0]];

faceClustering(index) = median(clust);
faceClustering(size(faceClustering,1)-2) = clust(1);
faceClustering(size(faceClustering,1)-1) = clust(2);
faceClustering(size(faceClustering,1)) = clust(3);

end