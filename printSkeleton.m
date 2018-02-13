function [] = printSkeleton(verticesS,facesS,verticesSk,WEDF,filename)

fig = figure;
axes('XColor','none','YColor','none');
hold on
scatter3(verticesSk(:,1),verticesSk(:,2),verticesSk(:,3),50,WEDF(:),'o','filled','LineWidth',10);

hold on
for i=1:length(facesS)
    fill3(verticesS(facesS(i,1:3),1),verticesS(facesS(i,1:3),2),verticesS(facesS(i,1:3),3),[0.8,0.8,0.8],'EdgeColor','none','FaceAlpha',0.4);
end

axis equal;
