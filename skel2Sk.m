function [] = skel2Sk(filename)

[vertices,edges] = parseSkel(filename);
writeSk(vertices,edges,strrep(filename,'.skel','.sk'));

end
