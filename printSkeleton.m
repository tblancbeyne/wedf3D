function [] = printSkeleton(verticesS,facesS,verticesSk,WEDF)

fig = figure;
hold on
scatter3(verticesSk(:,1),verticesSk(:,2),verticesSk(:,3),8,WEDF(:),'LineWidth',10);

hold on
for i=1:length(facesS)
    fill3(verticesS(facesS(i,1:3),1),verticesS(facesS(i,1:3),2),verticesS(facesS(i,1:3),3),[0.8,0.8,0.8],'EdgeColor','none','FaceAlpha',0.1);
end
