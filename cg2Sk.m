function [] = cg2Sk(filename)

[vertices,edges] = parseCg(filename);
writeSk(vertices,edges,strrep(filename,'.cg','.sk'));

end
