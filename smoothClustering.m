function [faces,vertices,faceClustering] = smoothClustering(faces,index,vertices,faceClustering,currClust)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

[faces,vertices] = divideFace(faces,index,vertices);

faceClustering = [faceClustering;[0;0;0]];

faceClustering(index) = median(currClust);
faceClustering(size(faceClustering,1)-2) = currClust(1);
faceClustering(size(faceClustering,1)-1) = currClust(2);
faceClustering(size(faceClustering,1)) = currClust(3);

end

