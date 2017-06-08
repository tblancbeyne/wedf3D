function [] = writeSk(verticesSk,edgesSk,filename)
%WRITESK writes an .sk file named filename with vertices verticesSk and
%edges edgesSk. The .sk format looks like the .off format to be able to
%read it easily.

% Opening the file
if nargin < 3
    fileID = fopen('skeleton.sk','w');
else
    fileID = fopen(filename,'w');
end

% Printing the head of the file
fprintf(fileID,'SK\r\n');

% Printing the second line of the file to th format:
% number_of_vertices number_of_edges
fprintf(fileID,'%u ', size(verticesSk,1));
fprintf(fileID,'%u 0\r\n', size(edgesSk,1));

% Print the vertices, identified by their coordinates
for i=1:size(verticesSk,1)
    fprintf(fileID,'%f ',verticesSk(i,1:3));
    fprintf(fileID,'\r\n');
end

% Print the edges
for i=1:size(edgesSk,1)
    fprintf(fileID,'%u %u\r\n',edgesSk(i,1:2)-1);
end

if fclose(fileID) ~= 0
    disp('Unexpected error. Aborted.');
end

end