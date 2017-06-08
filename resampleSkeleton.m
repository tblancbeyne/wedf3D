function [vertices,edges] = resampleSkeleton(vertices,edges,ratio)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

junctions = findJunctions(edges);
endpoints = findEndpoints(edges,size(vertices,1));

nearJunction = [];

% Last branches
while ~isempty(endpoints)
    prevPoint = 0;
    distance = 0;
    nbPoint = 0;
    currEdges = edges;
    currPoint = endpoints(1,:);
    currChild = 0;
    endpoints(1,:) = [];
    
    while max(currChild==junctions) ~= 1
        currChild = findChild(currEdges,currPoint);
        currChild = currChild(currChild(:) ~= prevPoint);
        distance = distance + sqrt(sum((vertices(currPoint,:) - vertices(currChild,:)) .^ 2));
        nbPoint = nbPoint + 1;
        
        if max(currChild==junctions) ~= 1
            if (nbPoint/distance > ratio)
                [vertices,edges] = deleteAndRemplaceVertex(currChild,currPoint,vertices,edges);
                [~,currEdges] = deleteAndRemplaceVertex(currChild,currPoint,[],currEdges);
                junctions(junctions(:) > currChild) = junctions(junctions(:) > currChild) - 1;
                endpoints(endpoints(:) > currChild) = endpoints(endpoints(:) > currChild) - 1;
                nearJunction(nearJunction(:) > currChild) = nearJunction(nearJunction(:) > currChild) - 1;
                if currPoint > currChild
                    currPoint = currPoint - 1;
                end
            else
                prevPoint = currPoint;
                currPoint = currChild;
                distance = 0;
                nbPoint = 0;
            end
        end
        nearJunction = vertcat(nearJunction,currPoint);
           
    end
    
end
        
% Branches between junction points
while ~isempty(junctions)
    prevPoint = 0;
    distance = 0;
    nbPoint = 0;
    currEdges = edges;
    currPoint = junctions(1,:);
    currChild = 0;
    junctions(1,:) = [];
    
    while max(currChild==junctions) ~= 1
        currChild = findChild(currEdges,currPoint);
        for i=1:size(nearJunction,1)
            currChild = currChild(currChild(:) ~= nearJunction(i));
        end
        currChild = currChild(currChild(:) ~= prevPoint);
        if size(currChild,1) > 1
            junctions = [currPoint;junctions];
            currChild = currChild(1);
            nearJunction = [nearJunction;currChild];
        end
        if isempty(currChild)
            break;
        end
        distance = distance + sqrt(sum((vertices(currPoint,:) - vertices(currChild,:)) .^ 2));
        nbPoint = nbPoint + 1;
        
        if max(currChild==junctions) ~= 1
            if (nbPoint/distance > ratio)
                [vertices,edges] = deleteAndRemplaceVertex(currChild,currPoint,vertices,edges);
                [~,currEdges] = deleteAndRemplaceVertex(currChild,currPoint,[],currEdges);
                junctions(junctions(:) > currChild) = junctions(junctions(:) > currChild) - 1;
                endpoints(endpoints(:) > currChild) = endpoints(endpoints(:) > currChild) - 1;
                nearJunction(nearJunction(:) > currChild) = nearJunction(nearJunction(:) > currChild) - 1;
                if currPoint > currChild
                    currPoint = currPoint - 1;
                end
            else
                prevPoint = currPoint;
                currPoint = currChild;
                distance = 0;
                nbPoint = 0;
            end
        end
        nearJunction = vertcat(nearJunction,currPoint);
    end
end
    
    
end

