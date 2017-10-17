function [facesColors] = crateSegColors(faceSeg)

colors = zeros(max(faceSeg)+1,3)

for i=1:size(colors,1)
    colors(i,:) = rand(1,3);
end

facesColors = zeros(length(faceSeg),3);

for i=1:length(faceSeg)
    facesColors(i,:) = colors(faceSeg(i)+1,:);
end

end
