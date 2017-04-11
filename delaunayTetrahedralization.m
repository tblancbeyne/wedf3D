function [tetrahedralization] = delaunayTetrahedralization(vertices,verticesM)
%%
%DELAUNAYTETRAHEDRALIZATION Summary of this function goes here
%   Detailed explanation goes here

% Making a first Delaunay tetrahedralization of the shape
tetrahedralizationTemp = delaunayTriangulation(vertices(:,1:3));

% Computing the circum centers of the tetrahedra
[cirCenters,radius] = circumcenter(tetrahedralizationTemp);

% Distance tolerance (radius*coeff)
coeff = 0.5;

% Initialization of a temporary connectivity list and a distance array
countA = 0;
%indexes = [];
connectTemp = zeros(1,4);
distArray = zeros(1,1);

% Finding the tetrahedra that are inside the shape
for i=1:size(cirCenters,1)
    distmin = realmax;
    vertmin = 0;
    vert = tetrahedralizationTemp.Points(tetrahedralizationTemp.ConnectivityList(i,1),:);
    for j=1:size(verticesM,1)
        % Bounding box
        if sqrt((verticesM(j,1)-cirCenters(i,1))^2) < radius(i) && sqrt((verticesM(j,2)-cirCenters(i,2))^2) < radius(i) && sqrt((verticesM(j,3)-cirCenters(i,3))^2) < radius(i) 
            % Computing the euclidean distance between the
            % circumcenter and the medial axis
            disti = sqrt((verticesM(j,1)-cirCenters(i,1))^2 + (verticesM(j,2)-cirCenters(i,2))^2 + (verticesM(j,3)-cirCenters(i,3))^2);
            if disti < distmin
                distmin = disti;
                vertmin = j;
            end
        end
    end
    % Storing the distance and the tetahedron if the distance is smaller
    % than a given threshold
    if distmin < radius(i);
        %indexes = vertcat(indexes,i);
        countA = countA+1;
        if countA > size(distArray,1)
            distArray = vertcat(distArray,zeros(size(distArray,1),size(distArray,2)));
            connectTemp = vertcat(connectTemp,zeros(size(connectTemp,1),size(connectTemp,2)));
        end
        distArray(countA) = vertmin;
        connectTemp(countA,:) = tetrahedralizationTemp.ConnectivityList(i,:);
    end
end

% Updating the 'inside' tetrahedralization of the shape
tetrahedralization.Points = tetrahedralizationTemp.Points;
tetrahedralization.ConnectivityList = connectTemp(1:countA,:);
tetrahedralization.LinkTetMedial = distArray(1:countA,:);

%tetrahedralization.CircumCenters = circumcenter(tetrahedralizationTemp,indexes);

% Plotting the shape's tetrahedralization (for test purpose)
%figure
%tetramesh(tetrahedralization.ConnectivityList(1:1000,:),tetrahedralization.Points);
%pause;

end

