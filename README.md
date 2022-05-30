# Segmentation of each particle in a frame across all frames in a video
- The script will read the video file and split each frame.
- Create a binary mask of all the particle by global threshold that is computed using OTSU's method.
- Compute the shape measurment (area) and pixel measurement (mean intensity) of each particle in a frame.
- The above process is repeated to all the frames in the video. 
- The area and mean intensity of the particle is stored in a single file.



# Steps
1) Each RGB frame is converted to gray scale --> it is unit8
2) Compute the OTSU threshold and generate a binary mask. 
3) Computer the Area and Mean Intensity of each particle.
4) Create label mask and find the total number of blobs from bwlabel structure.
5) Sort the measurements value based on the AREA in descending order.
6) Get the top rows in each frame based on the minimum counts of the particle in each frame.
7) Store the area and mean intensity of all particle in a frame.

# How to Use
- Input
   -- Give the complete path of the video file at line 37
- Output 
   -- Area and mean intensity of each particle in a frame across the video length.
