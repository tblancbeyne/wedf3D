function [] = GeometricShapeDecomposition()
%GeometricShapeDecomposition Summary of this function goes here
%
tic

prompt = 'What is the number of cluster? ';
clustNb = input(prompt);

% Parsing the shape
[verticesS,facesS] = parseOff('data/ant1/ant1.off');

% noise = rand(size(verticesS))/10;
% verticesS = verticesS + noise - mean(noise(:));

% Parsing the medial axis
[verticesM] = parseOff2('data/ant1/ant1-medial_axis.off');


% Parsing erosion thickness. In our case, the ET is in fact the MBT because
% radiuses of balls is set to 0 when computing the ET
verticesEt = parseEt('data/ant1/ant1-erosion_thickness.et');
verticesM = horzcat(verticesM,verticesEt);

% Parsing skeleton
[verticesSk,edgesSk] = parseSk2('data/ant1/ant1-skeleton.sk');

%displaySkeleton(verticesSk,edgesSk);

% Delaunay tetrahedralization of the shapew
tetrahedralization = delaunayTetrahedralization(verticesS,verticesM);

% Linking skeleton
links = linkToClosestETDistance(verticesM,verticesSk);

% Finding skeleton endpoints and setting their WEDF value. Skeleton
% endpoints are the point that are related to ZERO or ONE point, but not
% more
endPoints = findEndpoints(edgesSk, size(verticesSk,1));
endPoints = horzcat(endPoints, zeros(size(endPoints,1),1));

% Initializing WEDF to infty
WEDF = initWEDF(size(verticesSk));

% Computing and saving the WEDF of endpoints
for i=1:size(endPoints,1)
    WEDF(endPoints(i,1)) = computeWEDF(links{endPoints(i,1)},tetrahedralization,0);
    endPoints(i,2) = WEDF(endPoints(i,1));
end

toc

% Computing EDF
% EDF(endPoints(:,1)) = 0;
% edfEdgesSk = edgesSk;
% edfEndPoints = endPoints;
% while ~isempty(edfEndPoints) && ~isempty(edfEdgesSk)
%     minEndPoint = edfEndPoints(1,1); % Finding the point with smallest WEDF value among endpoints
%     [edfChild] = findChild(edfEdgesSk,minEndPoint(1));  % Finding the child of this point
%     
%     % If the point is not a junction or an endpoint (if it is, we finished
%     % the branch). A junction point is a point that is related to THREE or more points
%     if ~isempty(edfChild) && ~isJunctionPoint(edfChild,edfEdgesSk) && ~isEndPoint(edfChild(1),edfEdgesSk)
%         % Computing WEDF
%         EDF(edfChild(1)) = computeEDF(verticesSk(edfChild(1),:),verticesSk(minEndPoint(1),:),EDF(minEndPoint(1))); 
%         
%         % The child is a new endpoint as its parent will be deleted : it
%         % allows junctions points to become regular point as their
%         % connection with the parent is deleted
%         if ~isEndPoint(edfChild(1),edfEdgesSk)
%             edfEndPoints = vertcat(edfEndPoints,[edfChild(1) EDF(edfChild(1))]);
%         end
%     end

%     % In all cases, we remove the current endpoint and all the edges that
%     % are related to this point (so it child really becomes an endpoint if
%     % it was not a junction point, or lose one connection if it was a
%     % junction point)
%     edfEndPoints = removePoint(minEndPoint(1),edfEndPoints);
%     edfEdgesSk = updateSkeleton(minEndPoint(1),edfEdgesSk,[]);
%     
%     edfEndPoints = sortrows(edfEndPoints, 2);
% end
% 
% toc

% Computing WEDF on other points
junctionWEDF = zeros(size(verticesSk,1),1); % Temp parameter to sum WEDF at junctions
currEdgesSk = edgesSk; % Temp parameter to update the edges
while ~isempty(endPoints) && ~isempty(currEdgesSk)
    minEndPoint = endPoints(1,1); % Finding the point with smallest WEDF value among endpoints
    [currChild] = findChild(currEdgesSk,minEndPoint(1)); % Finding the child of this point
    
    % If the child exist and is not a junction nor another endpoint. A
    % junction point is a point that is related to THREE or more points
    if ~isempty(currChild) && ~isJunctionPoint(currChild,currEdgesSk) && ~isEndPoint(currChild(1),currEdgesSk)
        
        % Normal WEDF computation of the child + summing the volume at junctions
        WEDF(currChild(1)) = computeWEDF(links{currChild(1)},tetrahedralization,WEDF(minEndPoint(1)));
        WEDF(currChild(1)) = WEDF(currChild(1)) + junctionWEDF(currChild); 

        % The child is a new endpoint as its parent will be deleted : it
        % allows junctions points to become regular point as their
        % connection with the parent is deleted
        endPoints = vertcat(endPoints,[currChild(1) WEDF(currChild(1))]);
        
    % if the child exists but is a junction point, we had the WEDF value of
    % its current parent for later
    elseif ~isempty(currChild) && isJunctionPoint(currChild,currEdgesSk)
         junctionWEDF(currChild) = junctionWEDF(currChild) + WEDF(minEndPoint(1));
    end
    
    % In all cases, we remove the current endpoint and all the edges that
    % are related to this point (so it child really becomes an endpoint if
    % it was not a junction point, or lose one connection if it was a
    % junction point)
    endPoints = removePoint(minEndPoint(1),endPoints);
    currEdgesSk = updateSkeleton(minEndPoint(1),currEdgesSk);
    
    % Sorting the endpoints by WEDF value : smallest WEDF value first
    endPoints = sortrows(endPoints, 2);
end

toc

% Clustering the skeleton main shape
[initClustering,centroids,ics] = clusterInitialSet(edgesSk,WEDF);

toc

% Clustering the main shape faces
[facesS,verticesS,faceClustering] = clusterFaces(initClustering(:,3),facesS,verticesS,verticesSk,centroids,WEDF);

toc

% Clustering the other skeleton points
if ~isempty(ics)
    [clustering,centroids] = clusterSkeleton(initClustering,centroids,ics,clustNb); 
else
    clustering = initClustering;
end

faceClustering(faceClustering(:) == 2) = max(clustering(:,3));

% Histogram of first clusterized points
printHist(ics,WEDF,clustering,10);

% Histogram of all points
printHist(1:length(verticesSk),WEDF,clustering,3000);

toc

% To print WEDF
printSkeleton(verticesS,facesS,verticesSk,WEDF);

% To print clustering
printSkeleton(verticesS,facesS,verticesSk,clustering(:,3))

% Clustering the other faces
[facesS,verticesS,faceClustering] = clusterFaces2(clustering(:,3),facesS,verticesS,verticesSk,centroids,WEDF,faceClustering);

toc

% Print the clustering of the shape
figure; 
hold on
for i=1:size(facesS,1)
    fill3(verticesS(facesS(i,1:3),1),verticesS(facesS(i,1:3),2),verticesS(facesS(i,1:3),3),faceClustering(i,:),'EdgeColor','none');
end

pause;

for k = 1:3;
figure; 
hold on
    for i=1:size(facesS,1)
        if faceClustering(i,:) <= k
            fill3(verticesS(facesS(i,1:3),1),verticesS(facesS(i,1:3),2),verticesS(facesS(i,1:3),3),faceClustering(i,:),'EdgeColor','none');
        end
    end
end
 
for k = 2:3;
figure; 
hold on
    for i=1:size(facesS,1)
        if faceClustering(i,:) <= k
            fill3(verticesS(facesS(i,1:3),1),verticesS(facesS(i,1:3),2),verticesS(facesS(i,1:3),3),[1 1 0],'EdgeColor','none');
        end
    end
end

disp('FIN.');

end
