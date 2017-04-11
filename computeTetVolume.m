function [volume] = computeTetVolume(vertices)
%%
%COMPUTETETVOLUME Computes the volume of a tetrahedron.
%   [volume] = computeTetVolume(vertices) computes the volume of a
%   tetrahedron given by its vertices following the determinant formula:
%   volume = 1/6*abs(det(V2-V1,V3-V2,V4-V3)).

% Computing the vertices' differences
vect1 = vertices(2,:) - vertices(1,:);
vect2 = vertices(3,:) - vertices(2,:);
vect3 = vertices(4,:) - vertices(3,:);

% Computing the volume thanks to the determinant formula
volume = 1/6*abs(det(vertcat(vect1,vect2,vect3)));

end

