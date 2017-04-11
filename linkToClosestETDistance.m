function [links,skelET] = linkToClosestETDistance(verticesM,verticesSk)
%% The function linking the skeleton points to the medial axis points 
%% and to the tetrahedra (medial axis points and tetrahedra were 
%% previously linked in DelaunayTetrahedralization)

links = cell(size(verticesSk,1),1);
skelET = zeros(size(verticesSk,1),1);
%skelST = zeros(size(verticesSk,1),1);

% Giving a ET value to the skeleton points
for j=1:size(verticesSk,1)
    minDist = realmax;
    vert = -1;  
    for i=1:size(verticesM,1)
        dist = sqrt(double(verticesM(i,1)-verticesSk(j,1))^2+(verticesM(i,2)-verticesSk(j,2))^2+(verticesM(i,3)-verticesSk(j,3))^2);
        if dist < minDist
            minDist = dist;
            vert = i;
        end
    end
    skelET(j) = verticesM(vert,4);
%    skelST(j) = verticesM(vert,4)/(verticesM(vert,4)+verticesM(vert,5));
end

% Linking the skeleton points to the medial axis points thanks to the
% equation : D(m; s) = ||MBT(m) - MBT(s)| - d(m; s)|.
% Taking the minimum D value for each medial axis point
for i=1:size(verticesM,1)
    minDist = realmax;
    vert = -1;
    for j=1:size(verticesSk,1)
        dist = abs(abs(skelET(j)-verticesM(i,4)) - (sqrt((verticesM(i,1)-verticesSk(j,1))^2+(verticesM(i,2)-verticesSk(j,2))^2+(verticesM(i,3)-verticesSk(j,3))^2)));
        %dist = abs(sqrt((verticesM(i,1)-verticesSk(j,1))^2+(verticesM(i,2)-verticesSk(j,2))^2+(verticesM(i,3)-verticesSk(j,3))^2));
        if dist < minDist
            minDist = dist;
            vert = j;
        end
    end
    if vert ~= -1
        links{vert} = vertcat(links{vert},i);
    end
end

end

