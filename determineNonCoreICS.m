function [noncoreICS] = determineNonCoreICS(noncore,ics)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

noncoreICS = [];

for i=1:size(ics)
    noncoreICS = vertcat(noncoreICS,noncore(noncore(:,1) == ics(i),:));
end

end

