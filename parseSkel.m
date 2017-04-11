function [vertices,edges] = parseSkel(filename)
% Parsing .skel files

% Initialization
vertices = [];
edges = [];

% Choice of the file to open
if nargin < 1
    filename = uigetfile('*.skel');
end

% File is opened
file = fopen(filename,'r');

fgetl(file); % Useless first line
fgetl(file); % Useless second line

while(~feof(file))
    line = fgetl(file);
    sline = sscanf(line, '%lg');
    vertices = vertcat(vertices,sline(2:4)');
    neighbors = sline(6);
    for i=1:neighbors
        if sline(6+i) > sline(1)
            edges = vertcat(edges,[sline(1) sline(6+i)]);
        end
    end
end

if fclose(file) ~= 0
    disp('Unexpected error. Aborted.');
end

edges = unique(edges,'rows');
edges = edges + 1;

end


