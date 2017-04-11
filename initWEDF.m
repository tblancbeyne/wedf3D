function [WEDF] = initWEDF(nbVertices)
%%
%INITWEDF Initializes the WEDF value of the skeleton points to infinity.
%   INITWEDF(nbVertices) creates and returns a column vector of size
%   nbVertices, with all components set to realmax.

WEDF(1:nbVertices,1:1) = realmax('double');