function [verticesEt] = parseEt(filename)
%PARSEET Parsing an et file to get the et value associated to each vertex.
%Et files have the following format:
% X // num of vertices
%0 0    // vertex 0 and its et
%1 0.25	// vertex 1 and its et
%....
%x 0.5   // vertex x and its et

% Initialization
verticesEt = [];

% Getting the file to opened if not given as argument
if nargin < 1
    filename = uigetfile('*.et');
end

% Opening the file
file = fopen(filename,'r');

% Checking that the file is correct
if (file == -1 || strcmp('ET',fgetl(file)) == 0)
    disp('Incorrect .et file. Aborted.');
    return
end

% Getting the line containing the number of vertices to parse
secondLine = fgets(file);
vertNum = sscanf(secondLine,'%u');

% Initializing the array of vertices' et
verticesEt = zeros(vertNum,1);

% Loop to parse the et of each vertex and store it in the array
for i=1:vertNum 
    vertLine = fgetl(file);
    curVertEt = sscanf(vertLine, '%u %lg');
    verticesEt(i) = curVertEt(2);
end

% Closing the file
if fclose(file) ~= 0
    disp('Unexpected error. Aborted.');
end

end

