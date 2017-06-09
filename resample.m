function [] = resample(filename,ratio)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

[vertices,edges] = parseSk2(filename);

[vertices,edges] = resampleSkeleton(vertices,edges,ratio);

writeSk(vertices,edges,strrep(filename,'.sk','_resampled.sk'));


end

