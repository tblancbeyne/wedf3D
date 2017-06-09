function [verts,edges,j] = deleteAndRemplaceVertex(i,j,verts,edges)
%%
% Delete vertex i and remplace it with vertex j in the skeleton given
% (verts and edges args)

if i == j
    return
end

if ~isempty(verts)
    verts(i,:) = [];
end

if isempty(edges)
    return
end

for k=size(edges,1):-1:1 % loop on edges to update the indexes
    if edges(k,1) == i || edges(k,2) == i
        if edges(k,1) == i
            % To keep the order in the edges
            edgePart1 = min(j,edges(k,2));
            edgePart2 = max(j,edges(k,2));
        end
        if edges(k,2) == i
            edgePart1 = min(j,edges(k,1));
            edgePart2 = max(j,edges(k,1));
        end
        edges(k,:) = [edgePart1,edgePart2];
    end
    if edges(k,1) > i
        edges(k,1) = edges(k,1) - 1;
    end
    if edges(k,2) > i
        edges(k,2) = edges(k,2) - 1;
    end
    if edges(k,2) == edges(k,1); % deleting edges that have the same extremities
        edges(k,:) = [];
    end
end

if j > i
    j = j-1;
end

% Sorting the edges
edges = unique(edges,'rows','sorted');