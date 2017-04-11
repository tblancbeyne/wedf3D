function [vertices,edges] = parseCg(filename)
%% Parses .cg files (skeleton computed with mean curvature flow)

% Initialization
vertices = [];
edges = [];

% Choice of the file to open
if nargin < 1
    filename = uigetfile('*.cg');
end

% File is opened
file = fopen(filename,'r');

% First line is useless
line = fgetl(file);

while(~feof(file))
    line = fgetl(file);
    switch line(1)
        case 'v'
            vertices = vertcat(vertices,sscanf(line(2:end), '%lg %lg %lg')');
        case 'e'
            % Sorting if needed
            edge = sort(sscanf(line(2:end), '%u %u'));
            %edge = sscanf(line(2:end), '%u %u');
            
            % Storing the face
            edges = vertcat(edges,edge');
                        
        otherwise
            % Comment line or something not used here
    end
end

if fclose(file) ~= 0
    disp('Unexpected error. Aborted.');
end

edges = unique(edges,'rows');

end

