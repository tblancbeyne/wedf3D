function [edges] = updateSkeleton(points,edges)
%% Updating the skeleton edges and links by removing the edges containing the
%% given points

for i=1:size(points,1)
    for j=size(edges,1):-1:1
        if edges(j,1) == points(i) || edges(j,2) == points(i)
            edges(j,:) = [];
        end
    end
end

end

