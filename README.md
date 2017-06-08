# Geometric Shape Decomposition 3D

This project aims to compute a salience measure for 3D shape
Decomposition and Sub-parts Classification.

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

# How to use the software

## Mesh data

The shape we are using are **.OFF** shapes. We provide code to parse **.OBJ**
shapes. You can use our code to convert **.OBJ** shapes to **.OFF** shapes to be
able to use these shapes to perform the prerequired operations and our software.

## Prerequirements

First, you need to compute a **3D medial axis**, its **erosion thickness**and a 
**curve skeleton** of the shape you want to decompose.

The 3D medial axis can be obtained thanks to the Scale Axis Transform from :
*Balint Miklos, Joachim Giesen, Mark Pauly: Discrete Scale Axis Representations* 
*for 3D Geometry. ACM Transactions of Graphics, SIGGRAPH 2010*

The software ~~is~~ was until recently available [HERE](http://www.balintmiklos.com/mesecina/).
It works only on Windows.

The erosion thickness on the medial axis and  curve skeleton can then be obtained using :
*Yajie Yan, Kyle Sykes, Erin Chambers, David Letscher and Tao Ju: Erosion Thickness*
*on Medial Axes of 3D Shapes.*

The software is available [HERE](http://students.cec.wustl.edu/~yajieyan/).
Note that you will need to slightly modify these files by adding an header for 
parsing :
* "ET" as first line of the erosion thickness file (**.ET** file),
* "SK" as first line of the skeleton file (**.SK** file).

## Using the software

You are ready to compute our salience measure and 3D shape Decomposition.
The only thing you need to go is to go in the source code and modify the files 
that will be used when parsing the shape, parsing the medial axis (both **.OFF** files),
parsing the erosion thickness (**.ET** file obtained previously) and the skeleton 
(**.SK** file obtained previously).

