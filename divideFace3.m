function [faces,vertices] = divideFace3(faces,index,vertices,verticesSk,skelSeg,seg)

% Getting the face, edges and skelSeg of the face and face vertices
face = faces(index,:);
edges = [face(1),face(2);face(2),face(3);face(1),face(3)];
segs = [seg(1),seg(2);seg(2),seg(3);seg(1),seg(3)];

newVertices = [];

% Dichotomy
for i=1:size(edges,1)
    if segs(i,1) == segs(i,2)
        newVertices = [newVertices;(vertices(edges(i,1),:) +  vertices(edges(i,2),:)) / 2];
        continue;
    end
    upSeg = segs(i,1);
    botSeg = segs(i,2);
    upVert = vertices(edges(i,1),:);
    botVert = vertices(edges(i,2),:);
    for j=1:10
        currVert = (upVert + botVert) / 2;
        newSeg = 0;
        [~,vert] = min(sqrt((currVert(1)-verticesSk(:,1)).^2+(currVert(2)-verticesSk(:,2)).^2+(currVert(3)-verticesSk(:,3)).^2));
        if vert ~= -1
            newSeg = skelSeg(vert);
        end
        if newSeg == upSeg
            upVert = currVert;
        elseif newSeg == botSeg
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
