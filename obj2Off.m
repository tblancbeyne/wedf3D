function [] = obj2Off(filename)

[vertices,faces] = parseObj(filename);
writeOff(vertices,faces,strrep(filename,'.obj','.off'));

end