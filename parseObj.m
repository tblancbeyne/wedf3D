function [vertices,faces,edges] = parseObj(filename)
%% Parses simple .obj files (vertices and faces)

% Initialization
vertices = zeros(1,3);
faces = zeros(1,3);
edges = zeros(1,2);

% Choice of the file to open
if nargin < 1
    filename = uigetfile('*.obj');
end

% File is opened
file = fopen(filename,'r');
counter = 0;
countV = 0;
countF = 0;
%countE = 0;

% Parsing the file
while(~feof(file))
    counter = counter + 1;
    line = fgetl(file);
    if isempty(line)
        continue;
    end
    switch line(1)
        % Parsing the vertices
        case 'v'
            if line(2) == ' '
                countV = countV+1;
                if countV > size(vertices,1)
                    vertices = vertcat(vertices,zeros(size(vertices,1),size(vertices,2)));
                end
                vertices(countV,:) = sscanf(line(3:end), '%lg %lg %lg')';
            end
            
        % Parsing the faces
        case 'f'
            % Sorting if needed
            face = sscanf(line(2:end),'%d / %d');
            if size(face,1) < 3
                face = sscanf(line(2:end),'%d');
            end
            if size(face,1) > 4
                for i=size(face,1):-2:2
                    face(i) = [];
                end
            end
            face = face';
            if length(face) == 3
                % Storing the face
                countF = countF+1;
                if countF > size(faces,1)
                    faces = vertcat(faces,zeros(size(faces,1),size(faces,2)));
                end
                faces(countF,:) = face;
            
            elseif length(face) == 4 % Two triangle faces
                % Storing the faces
                countF = countF+2;
                if countF > size(faces,1)
                    faces = vertcat(faces,zeros(size(faces,1),size(faces,2)));
                end
                faces(countF-1,:) = [face(1) face(2) face(3)];
                faces(countF,:) = [face(1) face(3) face(4)];
              
            else % Unknown triangulation
                disp('Too complicated face. Aborted.');
                return;
            end
            
        otherwise
            % Comment line or something not used here
    end
end

vertices = vertices(1:countV,:);
faces = faces(1:countF,:);

if fclose(file) ~= 0
    disp('Unexpected error. Aborted.');
end

% edges = unique(edges,'rows');

end

