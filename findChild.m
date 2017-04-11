function [child,edge] = findChild(edges,point)
%FINDCHILD finds the next point to compute.
%   [child,edge] = FINDCHILD(edges,point) finds the second extremity of the
%   edges containing the point and returns the list of extremities as child
%   and the corresponding edges.

% Finds the set of child and the corresponding edges
child = vertcat(edges(edges(:,1) == point(1),2),edges(edges(:,2) == point(1),1));
edge = vertcat(edges(edges(:,1) == point(1),:),edges(edges(:,2) == point(1),:));


