function [listOfPoints] = removePoint(point,listOfPoints)
%REMOVEPOINT removes a point from a list of points.
%   [listOfPoints] = REMOVEPOINT(point,listOfPoints) removes point
%   from listOfPoints.

listOfPoints(listOfPoints(:,1) == point(1),:) = [];

end

