function [isJunction] = isJunctionPoint(point,edges)
%%
%ISJUNCTIONPOINT computes if a point is a junction point in the current set
%of curves.
%   [isJunction] = isJunctionPoint(point,edges) computes if the point is a
%   junction point in the current set of curves represented as edges.

isJunction = size(find(edges(:,1) == point(1) | edges(:,2) == point(1)),1) >= 3;

end
