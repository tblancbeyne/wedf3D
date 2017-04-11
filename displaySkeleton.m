function [] = displaySkeleton(vertices,edges)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
fig = figure;
hold on
for i=1:size(edges,1)
    line([vertices(edges(i,1),1);vertices(edges(i,2),1)],[vertices(edges(i,1),2);vertices(edges(i,2),2)],[vertices(edges(i,1),3);vertices(edges(i,2),3)])
end

end

