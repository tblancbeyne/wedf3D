function [faces,vertices] = divideFace(faces,index,vertices)

face = faces(index,:);

newVertices = zeros(3,3);

newVertices(1,:) = (vertices(face(1),:) + vertices(face(2),:)) / 2;
newVertices(2,:) = (vertices(face(2),:) + vertices(face(3),:)) / 2;
newVertices(3,:) = (vertices(face(1),:) + vertices(face(3),:)) / 2;

vertices = [vertices;newVertices];

faces(index,:) = [size(vertices,1)-2,size(vertices,1)-1, size(vertices,1)];

newFaces = zeros(3,3);

newFaces(1,:) = [face(1),size(vertices,1)-2,size(vertices,1)];
newFaces(2,:) = [size(vertices,1)-2,face(2),size(vertices,1)-1];
newFaces(3,:) = [size(vertices,1),size(vertices,1)-1,face(3)];

faces = [faces;newFaces];