function [isEndPoint] = isEndPoint(point,edges)
%%
%ISENDPOINT computes if a point is an extremity in the current set of 
%curves.
%   [isEndPoint] = ISENDPOINT(point,edges) computes if the point is an 
%   extremity in the current set of curves represented as edges.

isEndPoint = size(find(edges == point),1) <= 1;

end
