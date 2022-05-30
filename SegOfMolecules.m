%% Segmention of each particle in a frame across all frames in a video
% The script will read the video file and split each frame.
% Create a binary mask of all the particle by global threshold that is computed using OTSU's method.
% Compute the shape measurment (area) and pixel measurement (mean intensity) of each particle in a frame.
%  The above process is repeated to all the frames in the video. 
%  The area and mean intensity of the particle is stored in a single file.

%% Steps
% 1) Each RGB frame is converted to gray scale --> it is unit8
% 2) Compute the OTSU threshold and generate a binary mask. 
% 3) Computer the Area and Mean Intensity of each particle.
% 4) Create label mask and find the total number of blobs from bwlabel structure.
% 5) Sort the measurements value based on the AREA in descending order.
% 6) Get the top rows in each frame based on the minimum counts of the particle in each frame.
% 7) Store the area and mean intensity of all particle in a frame.

%% How to Use
% Input
%   -- Give the complete path of the video file at line 37
% Output 
%   -- Area and mean intensity of each particle in a frame across the video length.

%% Acknowledge
% CREATED: Sajid Ali, Sungkyunkwan University, Suwon, South Korea
% Data: |May 31, 2022|
% Contact: sajidali@skku.edu
%% Initialization
clc;    % Clear command window.
clear;    % Delete all variables.
close all;    % Close all figure windows except those created by imtool.
imtool close all;    % Close all figure windows created by imtool.
workspace;    % Make sure the workspace panel is showing.
fontSize = 16; % Font size of any text used in the figure

%% Load the video and read it frame by frame
% Provide the full file path to videoFileName
videoFileName = '...\Recent_May27,2022_E_FRET\Merged-aligned-001.avi.mp4'; % change this

% Read the movie file from the given path
video = VideoReader(videoFileName);

% Read the total number of frames
num_frames = video.NumFrames;
numberOfBlobs = zeros(num_frames,1);
AreaMeanIntensityOfeachParticle = table();

for i = 1:num_frames
    % Convert to the gray image
    grayImage = rgb2gray((read(video,i)));
    
    % Creates a binary image from 2-D grayscale image by replacing all values above a globally determined 
    % threshold with 1 and setting all other values to 0
    % The global threshold is computed using OTSU's method. 
    OTSU_thr = graythresh(grayImage);
    mask = imbinarize(grayImage, OTSU_thr);
    
    % Computer the Area and Mean Intensity of each particle.
    % Shape Measurement --> AREA in pixels^square (units)
    % Pixel Measurement --> Mean intensity
    measurements = regionprops('table', mask, grayImage, 'Area','MeanIntensity');
    
    % Find connected components in binary image.
    % Create label mask from bwlabel structure. Each label has a unique numeric index.
    % Also find the total number of blobs. This value indicates the number of detected objects.
    [labeledMask, numberOfBlobs(i)] = bwlabel(mask);
    
    % Sort the measurements value based on the AREA in descending order.
    % Get the top rows in each frame based on the minimum counts of the particle in each frame. 
    toprow = min(numberOfBlobs);
    measurements = topkrows(measurements, toprow);
    
    % Store the area and mean intensity of all particle in a frame.
    % Rows represents the frame coount and column denotes the Area and mean intensity with respect to the frame.
    col1 = strcat("Area", "_", string(i));
    col2 = strcat("MeanIntensity", "_", string(i));
    AreaMeanIntensityOfeachParticle(:,col1) = table(measurements.Area);
    AreaMeanIntensityOfeachParticle(:,col2) = table(measurements.MeanIntensity);
    
    % Display the gray image and mask side-by-side
    subplot(1,2,1)
    imshow(grayImage,[])
    title('Gray Image')
    subplot(1,2,2)
    imshow(mask)
    title('Binary Mask')
    pause(0.2)
end
writetable(AreaMeanIntensityOfeachParticle,'AreaMeanIntensityOfeachParticle.csv')
