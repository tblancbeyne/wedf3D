function [verticesSk,edgesSk] = parseSk2(filename)
%%
%PARSESK Parses an skeleton (.sk) file, and cleans it if needed at 
%'filename-cleaned.sk'.
%   verticesSk,edgesSk = PARSESK() asks for a .sk file to parse and parses
%   it. It cleans it if needed (e.g if a vertex is repeated several times).
%   verticesSk,edgesSk = PARSESK(filename) same as above, but with the file
%   given as input.

% Initialization
verticesSk = [];
edgesSk = [];

% If a filename is not given, a windows open to choose an .sk file to parse
if nargin < 1
    filename = uigetfile('*.sk');
end
    
% Opens the chosen file and checks if it is a correct .sk file
file = fopen(filename,'r');
if (file == -1 || strcmp('SK',fgetl(file)) == 0)
    if file == -1
        disp('Cannot find the requested file. Aborted');
    else
        disp('Incorrect .sk file. Aborted.');
    end
    return
end

% get information numbers on the second line of the file:
%  - vertNumSk : number of vertices in the mesh,
%  - edgeNumSk : number of edges in the mesh,
secondLine = fgets(file);
secondLine = sscanf(secondLine,'%u %u %u');
vertNumSk = secondLine(1);
edgeNumSk = secondLine(2);

% Parse the vertices : first in the file
verticesSk = zeros(vertNumSk, 3);
for i=1:vertNumSk 
    vertLine = fgetl(file);
    curVertSk = sscanf(vertLine, '%f %f %f'); % coordinates are floats or doubles
    curVertSk = transpose(curVertSk);  % transpose bc sscanf gives a column vector
    verticesSk(i,:) = curVertSk; 
end

% Parse the edges : second in the file
edgesSk = zeros(edgeNumSk, 2);
for i=1:edgeNumSk
    edgeLine = fgetl(file);
    curEdgeSk = sscanf(edgeLine, '%u %u');
    curEdgeSk = [min(curEdgeSk(1),curEdgeSk(2)) max(curEdgeSk(1),curEdgeSk(2))];
    
    % Storing the edges
    edgesSk(i,:) = curEdgeSk;
end

% Upping the edge number for practical reasons (matlab array begins at 1)
edgesSk = edgesSk + 1;

% Closing the file and reporting erros
if fclose(file) ~= 0
    disp('Unexpected error. Aborted.');
end

end

