function [] = writeOff(vertices,faces,filename)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

faces = faces - 1;

if nargin == 2
    fileID = fopen('mesh.off','w');
else
    fileID = fopen(filename,'w');
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
    fprintf(fileID,'\r\n');
end

if fclose(fileID) ~= 0
    disp('Unexpected error. Aborted.');
end

end

