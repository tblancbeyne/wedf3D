function [vertices,faces,edges] = parseOff(filename)
%%
%PARSEOFF Parses an off file.
%   [vertices,faces,edges] = PARSEOFF() asks for a .off file to parse and
%   parses it.
%   [vertices,faces,edges] = PARSEOFF(filename) parses the off file named
%   filename given as input.
%

% Initialization
vertices = [];
faces = [];
edges = [];

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
faceNum = secondLine(2);
edgeNum = secondLine(3);


vertices = zeros(vertNum,3);
faces = zeros(faceNum,3);
edges = zeros(faceNum*3,2);


% get the vertices in the following vertNum lines and store them in a
% vertNum*3 matrix for easier access.
for i=1:vertNum 
    vertLine = fgetl(file);
    curVert = sscanf(vertLine, '%lg %lg %lg');
    curVert = transpose(curVert);
    vertices(i,:) = curVert;
end

% Get the face in the following faceNum lines and store them in a
% faceNum*3 matrix for easier access. 
% Then, we compute the edge of the faces and store it into a faceNum*3*2 matrix,
% 3*2 represent the three edges of a triangular face: [1:2] [2,3] [3,1].
% It is a bit more tricky.
for i=1:faceNum 
    faceLine = fgetl(file);
    curFace = sscanf(faceLine, '%u %u %u %u');
    
    % verify that we have triangular faces
    if (curFace(1) ~= 3)
        disp('Incorrect face format. Aborted.');
        return
    end
    
    curFace = sort(transpose(curFace(2:4)));
    
    
    % Storing the face
    faces(i,:) = curFace;
    
    % Putting edges in the [1,2] [2,3] [1,3] format
    curEdge1 = [curFace(1),curFace(2)];
    curEdge2 = [curFace(2),curFace(3)];
    curEdge3 = [curFace(1),curFace(3)];

    % Storing the edges
    edges(3*i-2,:) = curEdge1;
    edges(3*i-1,:) = curEdge2;
    edges(3*i,:) = curEdge3;
end

% Increasing all the values by 1 to fit with matlab arrays
edges = edges +1;
faces = faces +1;
edges = unique(edges);

if fclose(file) ~= 0
    disp('Unexpected error. Aborted.');
end

end






