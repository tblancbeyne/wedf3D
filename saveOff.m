function [] = saveOff(vertices,faces,colors,filename)

if nargin < 4
    filename = 'save.off';
end

file = fopen(filename,'w');

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
    fprintf(fileID,'%u ',colors(i,1:3));
    fprintf(fileID,'\r\n');
end

if fclose(fileID) ~= 0
    disp('Unexpected error. Aborted.');
end

end

