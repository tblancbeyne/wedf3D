function [faces,vertices,faceSeg] = smoothClustering3(faces,index,vertices,verticesSk,skelSeg,faceSeg,seg);

[faces,vertices] = divideFace3(faces,index,vertices,verticesSk,skelSeg,seg);

faceSeg = [faceSeg;[0;0;0]];

faceSeg(index) = median(seg);
faceSeg(size(faceSeg,1)-2) = seg(1);
faceSeg(size(faceSeg,1)-1) = seg(2);
faceSeg(size(faceSeg,1)) = seg(3);

end

