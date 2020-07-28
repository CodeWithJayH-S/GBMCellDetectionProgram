%***___________Dissertation_MATLAB_Project:_GBM_CELL_DETECTION___________***
%***                                                            ***
%***_______________Jayden Heanue-Smith_14558987_________________***

%******************************************************************
%_______________________________________________________________***


clear; close all; clc;


%First step: Reading the image into the MATLAB script using imread.
%The image is now named as the variable name 'cell'. This can now
%be recognised as cell when I need to use further in the project.

%Cell represents the image. This function reads a colour/gray image
%This can be read from directory or being in the same folder as the
%program
cell = imread("9 15.jpg"); 
%This allows the author to create a figure window for the current
%image being read
figure; imshow(cell);
%This allows the figure to have a title for the author to 
%understand exactly what is being displayed
title('Reading in file: Display original cell image');

%***____________________________________________________________***


%BW = imbinarize(CELL);
%MATLAB suggested to use imbinarize in place of im2bw as it was 
%approriate for this MATLAB project.

%***Step 2: Converting rgb to lab_______________________________***
%rgb2lab gives the author more conversion choices. For example:
%colour space for the rgb img. 
cell = rgb2lab(cell);
figure; imshow(cell);
title('Converted image: Display rgb2lab colours');

%***____________________________________________________________***


%***_Step 3: K-means clustering to succsefull segment all areas_***
%The colon is used to index a range of elements in the
%specified dimensions below. The dimensions are set and the array
%indices must be logical values or positive integers. 
dim = cell(:,:,0.6:3);
%im2single will allow the author to convert the image to "single".
%This will offset and rescale the data as required.
dim = im2single(dim);
%This means that the k-means will attempt three seperate segmentations.
nColors = 3;
%imsegkmeans allows the author to segment the 9 15.jpg image into 
%a requested amount of clusters. This is achieved from performing
%k-means clustering. This then returns the labelled segmentations.
pixel = imsegkmeans(dim,nColors,'NumAttempts',3);

%***____________________________________________________________***



%Inspired by https://ch.mathworks.com/help/images/color-based-segmentation-
%using-k-means-clustering.html
%To define the colours they must be labelled as numbers.
%Therefore it can be used in the following code representing
%the clusters.
%The variable pink represents the first cluster.
% == returns a logical array in which pixel and 1 are equal.
Pink = pixel==1;
White = pixel==2;
Brown = pixel==3;
%cluster1(c) equals the multiplication of cell(a) and the elements
%of pink(b). This is known as element wise multiplication.
%This multiplies arrays such as this element by element. The 
%result is then returned in the cluster.
cluster1 = cell .* (Pink);
cluster2 = cell .* (White);
cluster3 = cell .* (Brown);

figure; imshow(cluster1); title('Objects(pink cells detected): Displaying Cluster 1');

figure; imshow(cluster2); title('Objects(background) Displaying Cluster 2');

figure; imshow(cluster3); title('Objects(Brown cells detected): Displaying Cluster 3');

%***_Step 3: K-means clustering to succsefull segment all areas_***
%Next step segmenting the nuclei________________________________***

%The colon is used to index a range of elements in the
%specified dimensions below. The dimensions are set and the array
%indices must be logical values or positive integers. 
segnuclei = cell(:,:,1);
%nuclei(c) equals the multiplication of segnuclei(a) and the elements
%of Brown(b) The double used stores all values as double-precision float
%points.This is known as element wise multiplication.
%This multiplies arrays such as this element by element. The 
%result is then returned in the cluster.
nuclei = segnuclei .* double(Brown);
%Rescale allows the author to scale the entry of arrays. The output 
%is the same size as the input.
nuclei = rescale(nuclei);
%imbinarize creates the binary image. The function replaces all values
%above a threshold with 1s. Then the rest of the values are set to 0.
%Non zeros is used to return a full column vector of elements from the
%nuclei.
n = imbinarize(nonzeros(nuclei));
%returning vector including linear indices. This is the nonzero elements in
%Brown
b = find(Brown);

d = Brown;
%parenthesis is used to enclose function input, index in arrays and
%precendence of operations
d(b(n)) = 0;

bnuclei = cell .* (d);

figure; imshow(bnuclei)

title('Finding the nuclei: Displaying nuclei of cluster3');

%***____________________________________________________________***

%Edge detection: Canny detection 
%This variable is equal to cluster3
e = cluster3;
%e1 equals a converted to gray version of cluster3
e1 = rgb2gray(e);
%This function helps detect the edges in the image succesfully.
cannyed = edge(e1, 'canny');

figure; imshow(cannyed)
%Inspired by https://www.youtube.com/watch?v=L6F8DgmV8Io
title('Edge detection: Displaying canny detection');

%Inspired by https://ch.mathworks.com/help/images/correcting-nonuniform-illumination.html
%Counting the cells in the image using correct nonuniform illumination
%and morphological operations.

se = strel('disk',15);
%strel is an object that displays a flat morphological element.
%This is considered essential for dilation and erosion.
reduce = imopen(cluster3, se);
%The author has learnt that this applys morphological opening
%on the image. Further returning the open image.
imshow(reduce)

cc = bwconncomp(reduce, 8);
%This will output the connected componnents from the image. This
%will be cells that have been found from cluster3.






