function [tetrahedralization] = delaunayTetrahedralization(vertices,verticesM)
%%
%DELAUNAYTETRAHEDRALIZATION Summary of this function goes here
%   Detailed explanation goes here

% Making a first Delaunay tetrahedralization of the shape
tetrahedralizationTemp = delaunayTriangulation(vertices(:,1:3));

% Computing the circum centers of the tetrahedra
[cirCenters,radius] = circumcenter(tetrahedralizationTemp);

% Distance tolerance (radius*coeff)
%coeff = 0.5;

% Initialization of a temporary connectivity list and a distance array
countA = 0;
connectTemp = zeros(1,4);
distArray = zeros(1,1);

% Finding the tetrahedra that are inside the shape
for i=1:size(cirCenters,1)
    [distmin,vertmin] = min(sqrt((verticesM(:,1)-cirCenters(i,1)).^2 + (verticesM(:,2)-cirCenters(i,2)).^2 + (verticesM(:,3)-cirCenters(i,3)).^2));
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
%tetramesh(tetrahedralization.ConnectivityList,tetrahedralization.Points);
%pause;

end

