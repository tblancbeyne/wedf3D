function [currEDF] = computeEDF(currPt,prevPt,prevEDF)
%% Function to compute EDF of a pointgiven the previous point on the branch and its EDF.

currDist = sqrt((currPt(1)-prevPt(1))^2+(currPt(2)-prevPt(2))^2+(currPt(3)-prevPt(3))^2);

currEDF = prevEDF + currDist;

end

