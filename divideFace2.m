function [faces,vertices] = divideFace2(faces,index,vertices,verticesSk,clustering,medians,clust)

% Getting the face, edges and clustering of the face and face vertices
face = faces(index,:);
edges = [face(1),face(2);face(2),face(3);face(1),face(3)];
clusts = [clust(1),clust(2);clust(2),clust(3);clust(1),clust(3)];

newVertices = [];

% Dichotomy
for i=1:size(edges,1)
    if clusts(i,1) == clusts(i,2)
        newVertices = [newVertices;(vertices(edges(i,1),:) +  vertices(edges(i,2),:)) / 2];
        continue;
    end
    upClust = clusts(i,1);
    botClust = clusts(i,2);
    upVert = vertices(edges(i,1),:);
    botVert = vertices(edges(i,2),:);
    for j=1:10
        currVert = (upVert + botVert) / 2;
        newClust = 0;
        [~,vert] = min(sqrt((currVert(1)-verticesSk(:,1)).^2+(currVert(2)-verticesSk(:,2)).^2+(currVert(3)-verticesSk(:,3)).^2)./power(medians(clustering(:)),1/4));
        if vert ~= -1
            newClust = clustering(vert);
        end
        if newClust == upClust
            upVert = currVert;
        elseif newClust == botClust
            botVert = currVert;
        end
    end
    newVertices = [newVertices;(upVert + botVert) / 2];
end
    
vertices = [vertices;newVertices];

faces(index,:) = [size(vertices,1)-2,size(vertices,1)-1, size(vertices,1)];

newFaces = zeros(3,3);

newFaces(1,:) = [face(1),size(vertices,1)-2,size(vertices,1)];
newFaces(2,:) = [size(vertices,1)-2,face(2),size(vertices,1)-1];
newFaces(3,:) = [size(vertices,1),size(vertices,1)-1,face(3)];

faces = [faces;newFaces];