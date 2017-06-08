Geometric Shape Decomposition 3D

This project aims to compute a salience measure calle

We present a method for decomposing 3D shapes into sub-parts and classifying 
those parts according to their level of salience. Such an analysis is important 
for many applications including shape comparison, editing, and compression. Key 
to our approach is the use of a function defined on a curve-skeleton centered 
within the 3D shape. Specifically, we introduce a 3D generalization of a 
skeleton-based salience measure previously defined for 2D shapes, the weighted 
extended distance function (WEDF). We provide robust algorithms for computing 
the WEDF in 3D along curve-skeletons and deduce a corresponding salience 
function defined on the 3D mesh representing the shape. We use the salience 
values on mesh points to perform an unsupervised decomposition of closed 3D 
meshes into visually meaningful sub-parts that are clustered according to their 
degree of perceptual salience.