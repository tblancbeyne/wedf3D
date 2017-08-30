function [] = printSkeleton(verticesS,facesS,verticesSk,WEDF)

fig = figure;
for i=1:size(verticesSk,1)
    hold on
    scatter3(verticesSk(i,1),verticesSk(i,2),verticesSk(i,3),8,WEDF(i),'LineWidth',10);
end
hold on
for i=1:size(facesS,1)
    fill3(verticesS(facesS(i,1:3),1),verticesS(facesS(i,1:3),2),verticesS(facesS(i,1:3),3),[0.8,0.8,0.8],'EdgeColor','none','FaceAlpha',0.1);
end