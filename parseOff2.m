function [vertices] = parseOff2(filename)
%%
%PARSEOFF2 Parses the vertices of an .off file.
%   [vertices] = PARSEOFF2() asks for a .off file to parse and
%   parses its vertices.
%   [vertices] = PARSEOFF2(filename) parses the vertices of the off file 
%   filename given as input.
%

% Initialization
vertices = [];
% Choice of the file to open
if nargin < 1
    filename = uigetfile('*.off');
end

% File is opened
file = fopen(filename,'r');

% Checking the file type
if (file == -1 || strcmp('OFF',fgetl(file)) == 0)
    disp('Incorrect .off file. Aborted.');
    if fclose(file) ~= 0
        disp('Unexpected error. Aborted.');
    end
    return
end


% get information numbers on the second line of the file:
%  - vertNum : number of vertices in the mesh,
%  - faceNum : number of faces in the mesh,
%  - edgeNum : number of edge in the mesh (often set to zero, not used
%  here).
secondLine = fgets(file);
secondLine = sscanf(secondLine,'%u %u %u');
vertNum = secondLine(1);


vertices = zeros(vertNum,3);


% get the vertices in the following vertNum lines and store them in a
% vertNum*3 matrix for easier access.
for i=1:vertNum 
    vertLine = fgetl(file);
    curVert = sscanf(vertLine, '%lg %lg %lg');
    curVert = transpose(curVert);
    vertices(i,:) = curVert;
end

if fclose(file) ~= 0
    disp('Unexpected error. Aborted.');
end

end






