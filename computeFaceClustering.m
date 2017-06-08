function [faces,vertices,faceClustering,pointClust] = computeFaceClustering(clustering,faces,vertices,verticesSk,centroids,WEDF)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

pointClust = zeros(size(vertices,1),1);
medians = zeros(size(centroids,1),1);

for i=1:size(centroids,1)
    medians(i) = median(WEDF(find(clustering(:) == i)));
end
    
for j=1:size(vertices,1)
    minDist = realmax;
    vert = -1;  
    for i=1:size(verticesSk,1)
        dist = sqrt((vertices(j,1)-verticesSk(i,1))^2+(vertices(j,2)-verticesSk(i,2))^2+(vertices(j,3)-verticesSk(i,3))^2)/power(medians(clustering(i)),1/4);
        if dist < minDist
            minDist = dist;
            vert = i;
        end
    end
    if vert ~= -1
        pointClust(j) = clustering(vert);
    end
end

% for i=1:size(endpoints,1);
%     currVerts = links{endpoints(i)};
%     for j=1:size(currVerts,1)
%         tetrahedronVert = tetrahedralization.ConnectivityList(tetrahedralization.LinkTetMedial(:,1) == currVerts(j),:);
%         if ~isempty(tetrahedronVert)
%             for l=1:4
%                 pointClust(tetrahedronVert(l)) = clustering(endpoints(i));
%             end
%         end
%     end
% end

faceClustering = ones(size(faces,1),1)*max(pointClust);

for i=1:size(faces,1)
    % Avoid shaky boundaries between parts
    currClust = [0 0 0];
    for j=1:3
        currClust(j) = pointClust(faces(i,j));
    end
    if currClust(1) ~= currClust(2) || currClust(1) ~= currClust(3)
        [faces,vertices,faceClustering] = smoothClustering(faces,i,vertices,faceClustering,currClust);
    end

    % Mean
%     currClust = 0;
%     for j=1:3
%         currClust = currClust + pointClust(faces(i,j));
%     end
%     faceClustering(i) = currClust/3;

    % Median
%    currClust = [0 0 0];
%    for j=1:3
%        currClust(j) = pointClust(faces(i,j));
%    end
%    faceClustering(i) = median(currClust);

    % Max
%     faceClustering(i) = 0;
%     for j=1:3
%          currClust = pointClust(faces(i,j));
%          if currClust > faceClustering(i)
%                  faceClustering(i) = currClust;
%          end
%     end

end

% figure;
% scatter3(vertices(:,1),vertices(:,2),vertices(:,3),100,pointClust,'filled');

end