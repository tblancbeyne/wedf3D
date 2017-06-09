function [vertices,edges] = resampleSkeleton(vertices,edges,ratio)
%% Function to resample the skeleton by deleting the points that are too close

junctions = findJunctions(edges); % Junctions in the skeleton
endpoints = findEndpoints(edges,size(vertices,1)); % Endpoints in the skeleton

nearJunction = []; % Neighbors of junctions point that haev already been used

% Last branches
while ~isempty(endpoints)
    % Initializing values
    prevPoint = 0; % The previous point
    distance = 0; % The distance from the kept point to the current point
    nbPoint = 1; % The number of points between the kept point and the current point (both included)
    currChild = 0; % The child of the currPoint (i.e. the next point on the branch)
    currPoint = endpoints(1,:); % First point of the current branch
    endpoints(1,:) = []; % Deleting this endpoint as it as been used
    
    while max(currChild==junctions) ~= 1 % While we are not at a junction
        currChild = findChild(edges,currPoint); % The neighbors of the currPoint
        currChild = currChild(currChild(:) ~= prevPoint); % Only keeping the NEXT one on the branch
        distance = distance + sqrt(sum((vertices(currPoint,:) - vertices(currChild,:)) .^ 2)); % Computing the geodesic distance between the last kept point and the child 
        
        if max(currChild==junctions) ~= 1 % If we are not at the end of the branch (i.e. a junction point)
            if (1/distance > ratio) % If we have too much points for a too small distance
                [vertices,edges] = deleteAndRemplaceVertex(currChild,currPoint,vertices,edges); % Deleting the child
                junctions(junctions(:) > currChild) = junctions(junctions(:) > currChild) - 1;             %
                endpoints(endpoints(:) > currChild) = endpoints(endpoints(:) > currChild) - 1;             % 
                nearJunction(nearJunction(:) > currChild) = nearJunction(nearJunction(:) > currChild) - 1; %
                if currPoint > currChild                                                                   % Updating values
                    currPoint = currPoint - 1;                                                             %
                end                                                                                        %
            else
                prevPoint = currPoint; % Keeping the point and storing it as previous point
                currPoint = currChild; % Updating currPoint as the child has been kept
                distance = 0;          % Reinitializing the distance
            end
        end
        nearJunction = vertcat(nearJunction,currPoint); % Storing the currPoint as a neighbor of a junction because we already went through its branch
           
    end
    
end
        
% Branches between junction points
while ~isempty(junctions)
    % Initializing values, same as previous loop on bendpoints branches
    prevPoint = 0;
    distance = 0;
    currPoint = junctions(1,:);
    currChild = 0;
    junctions(1,:) = [];
    
    while max(currChild==junctions) ~= 1 % While we are not at the next junction point
        currChild = findChild(edges,currPoint); % Finding the neighbors points
        for i=1:size(nearJunction,1)                                %
            currChild = currChild(currChild(:) ~= nearJunction(i)); % Keeping only unused points
        end                                                         %
        currChild = currChild(currChild(:) ~= prevPoint);           %
        if size(currChild,1) > 1                      % If there are still several unused points,
            junctions = [currPoint;junctions];        % keeping the first one, marking it used 
            currChild = currChild(1);                 % and putting the junction point back to
            nearJunction = [nearJunction;currChild];  % the list in order to access 
        end                                           % the other branches
        if isempty(currChild) %
            break;            % if there are no child, exiting the loop
        end                   %
        distance = distance + sqrt(sum((vertices(currPoint,:) - vertices(currChild,:)) .^ 2)); % Computing the geodesic distance between the last kept point and the child 
        
        if max(currChild==junctions) ~= 1 % If we are not at the end of the branch (i.e. a junction point)
            if (1/distance >= ratio) % If we have too much points for a too small distance
                [vertices,edges] = deleteAndRemplaceVertex(currChild,currPoint,vertices,edges); % Deleting the child
                junctions(junctions(:) > currChild) = junctions(junctions(:) > currChild) - 1;             %
                endpoints(endpoints(:) > currChild) = endpoints(endpoints(:) > currChild) - 1;             %
                nearJunction(nearJunction(:) > currChild) = nearJunction(nearJunction(:) > currChild) - 1; % Updating values
                if currPoint > currChild                                                                   %
                    currPoint = currPoint - 1;                                                             %
                end                                                                                        %
            else
                prevPoint = currPoint; % Keeping the point and storing it as previous point
                currPoint = currChild; % Updating currPoint as the child has been kept
                distance = 0;          % Reinitializing the distance
            end
        end
        nearJunction = vertcat(nearJunction,currPoint); % Storing the currPoint as a neighbor of a junction because we already went through its branch
    end
end
    
    
end

