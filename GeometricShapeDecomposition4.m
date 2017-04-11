function [] = GeometricShapeDecomposition4()
%GeometricShapeDecomposition Summary of this function goes here
%

% Parsing the shape
[verticesS,facesS] = parseObj('data/david6/david6.obj');

% Parsing the medial axis
[verticesM] = parseOff2('data/david6/david6-medial_axis.off');


% Parsing erosion thickness
verticesEt = parseEt('data/david6/david6-erosion_thickness.et');
verticesM = horzcat(verticesM,verticesEt);

% Parsing skeleton
[verticesSk,edgesSk] = parseCg('data/david6/david6-skeleton.cg');

% Delaunay tetrahedralization of the shape
tetrahedralization = delaunayTetrahedralization(verticesS,verticesM);

% Linking skeleton
[links,~] = linkToClosestETDistance(verticesM,verticesSk);

% Finding skeleton endpoints and setting their WEDF value. Skeleton
% endpoints are the point that are related to ZERO or ONE point, but not
% more
endPoints = findEndpoints(edgesSk, size(verticesSk,1));
endPoints = horzcat(endPoints, zeros(size(endPoints,1),1));

%testEndPoints = endPoints(:,1);
% Initializing WEDF to infty
WEDF = initWEDF(size(verticesSk));

% Computing and saving the WEDF of endpoints
for i=1:size(endPoints,1)
    WEDF(endPoints(i,1)) = computeWEDF(links{endPoints(i,1)},tetrahedralization,0);
    endPoints(i,2) = WEDF(endPoints(i,1));
end

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

% To print WEDF
% fig = figure;
% for i=1:size(edgesSk,1)
%     hold on
%     scatter3(verticesSk(edgesSk(i,:),1),verticesSk(edgesSk(i,:),2),verticesSk(edgesSk(i,:),3),8,WEDF(edgesSk(i,:)),'LineWidth',10);
% end

% Clustering, first step
[initialClustering,centroids,ics] = computeInitialClustering(edgesSk,WEDF);

if ~isempty(ics)
    [core,noncore,centroids] = computeStepOneClustering(initialClustering,centroids,ics);
    core(:,3) = max(noncore(:,3)) + 1;
    clustering = sortrows(vertcat(noncore,core),1);
else
    clustering = initialClustering;
end

% To print the clustering of the skeleton
% fig = figure;
% for i=1:size(edgesSk,1)
%     hold on
%     scatter3(verticesSk(edgesSk(i,:),1),verticesSk(edgesSk(i,:),2),verticesSk(edgesSk(i,:),3),8,clustering(edgesSk(i,:),3),'LineWidth',10);
% end

% Clustering the faces rather than the tetrahedra
[faceClustering] = computeFaceClustering(clustering(:,3),facesS,verticesS,verticesSk,centroids,WEDF);

% Print the clustering of the shape
figure; 
hold on
for i=1:size(facesS,1)
    fill3(verticesS(facesS(i,1:3),1),verticesS(facesS(i,1:3),2),verticesS(facesS(i,1:3),3),faceClustering(i,:),'EdgeColor','none');
end



end
