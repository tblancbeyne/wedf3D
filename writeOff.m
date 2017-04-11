function [] = writeOff(vertices,faces,faceClustering,filename)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

faces = faces - 1;

if nargin <= 3
    fileID = fopen('mesh.off','w');
else
    fileID = fopen(filename,'w');
end

maxi = max(faceClustering(:));
color = zeros(maxi,3);
for i=1:max(faceClustering(:))
    color(i,:) = [rand(1) rand(1) rand(1)];
end

% Printing the head of the file
fprintf(fileID,'OFF\r\n');

% Printing the second line of the file to th format:
% number_of_vertices number_of_edges
fprintf(fileID,'%u ', size(vertices,1));
fprintf(fileID,'%u 0\r\n', size(faces,1));

for i=1:size(vertices,1)
    fprintf(fileID,'%f ',vertices(i,1:3));
    fprintf(fileID,'\r\n');
end

for i=1:size(faces,1)
    fprintf(fileID,'3 ');
    fprintf(fileID,'%u ',faces(i,1:3));
    fprintf(fileID,'%d',color(faceClustering(i),1:3));
    fprintf(fileID,'\r\n');
end

if fclose(fileID) ~= 0
    disp('Unexpected error. Aborted.');
end

end

