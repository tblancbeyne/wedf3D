function [faces,vertices,faceSeg] = cutClusters(clustering,skelSeg,faces,vertices,verticesSk,faceClustering)

% Find mainshape
mainshapeVal = max(faceClustering(:));
mainshape = find(faceClustering == mainshapeVal);

faceSeg = zeros(size(faces,1),1);

% For other clusters
for i=1:max(faceClustering(:))-1

    % Find corresponding skeleton points
    SkVerts = verticesSk(find(clustering(:) == i),:);
    currSkSeg = skelSeg(find(clustering(:) == i));

    % Find corresponding faces
    indexFaces = find(faceClustering(:) == i);
    currFaces = faces(indexFaces,:);

    % Find corresponding vertices
    shapeVerts = unique(currFaces(:));

    % Find clustering
    pointSeg = zeros(size(vertices,1),1);
    for j=1:size(shapeVerts,1);
        [~,vert] = min(sqrt((vertices(shapeVerts(j),1)-SkVerts(:,1)).^2+(vertices(shapeVerts(j),2)-SkVerts(:,2)).^2+(vertices(shapeVerts(j),3)-SkVerts(:,3)).^2));
        if vert ~= -1
            pointSeg(shapeVerts(j)) = currSkSeg(vert);
        end
    end

    % For each face, find the segmentation
    for j=1:length(currFaces);
        currSeg = [0;0;0];
        for k=1:3
            currSeg(k) = pointSeg(currFaces(j,k));
        end
        if currSeg(1) ~= currSeg(2) || currSeg(1) ~= currSeg(3)
            [faces,vertices,faceSeg] = smoothClustering3(faces,indexFaces(j),vertices,SkVerts,currSkSeg,faceSeg,currSeg);
        else
            faceSeg(indexFaces(j)) = currSeg(k);
        end

    end
end

