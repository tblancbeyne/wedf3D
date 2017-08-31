function [] = printHist(points,WEDF,clustering,height)

figure;
hold on;
histpoints = histogram(WEDF(points(:)));
histpoints.BinWidth = max(clustering(clustering(:,3) == 1,2)/4);
maxC = max(clustering(:,3));
for i=1:maxC-1
    maxCl = max(clustering(clustering(:,3) == i,2));
    maxCl2 = min(clustering(clustering(:,3) == i+1,2));
    line([(maxCl+maxCl2)/2 (maxCl+maxCl2)/2], [0 height], 'LineWidth',4);
end
line([maxCl2 maxCl2], [0 0], 'LineWidth',4);