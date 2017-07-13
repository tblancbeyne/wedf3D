function [faces,vertices,faceClustering,pointClust] = computeFaceClustering2(clustering,faces,vertices,verticesSk,centroids,WEDF,faceClustering)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

mainShape = max(clustering(:));

pointClust = zeros(size(vertices,1),1);
medians = zeros(size(centroids,1),1);

for i=1:size(centroids,1)
    medians(i) = median(WEDF(find(clustering(:) == i)));
end
    
for j=1:size(vertices,1)
    [~,vert] = min(sqrt((vertices(j,1)-verticesSk(:,1)).^2+(vertices(j,2)-verticesSk(:,2)).^2+(vertices(j,3)-verticesSk(:,3)).^2)./power(medians(clustering(:)),1/4));
    if vert ~= -1
        pointClust(j) = clustering(vert);
    end
end

for i=1:size(faces,1)
    if (faceClustering(i) ~= mainShape)
    	% Finding the separation with precision  
        currClust = [0 0 0];
        for j=1:3
            currClust(j) = pointClust(faces(i,j));
        end
        if currClust(1) ~= currClust(2) || currClust(1) ~= currClust(3)
            [faces,vertices,faceClustering] = smoothClustering2(faces,i,vertices,verticesSk,clustering,faceClustering,medians,currClust);
        else
            faceClustering(i) = currClust(1);
        end
    end

end

end