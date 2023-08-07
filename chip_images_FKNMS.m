%% Creating Chips via FKNMS SfM Orthomosaics
% mosaics are exported as tif files w/ 0.001m x 0.0001m resolution
% WORKING DATE: 22 DEC 2020
clear              
close all

filename = 'ESB_1mm_03272020.tif' %image file you want to chip
root_filename = 'KP2020' %filename you want to start each chip filename (ex: 'image1' will result in chips named 'image1_1.png, image1_2.png etc.)
chip_size = 3000 
% size of image chip you want (ex. 512 x 512 pixels chip_size = 512); 
% x-y pix size 0.001 = 3x3m res = 3000


%% Chip image
rgbImage = imread(filename);
rgbImage=rgbImage(:,:,1:3);
figure;imshow(rgbImage);
% Test code if you want to try it with a gray scale image.
% Uncomment line below if you want to see how it works with a gray scale image.
% rgbImage = rgb2gray(rgbImage);
% Display image full screen.
%imshow(rgbImage);
% Enlarge figure to full screen.
%set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
%drawnow;
% Get the dimensions of the image.  numberOfColorBands should be = 3.
[rows columns numberOfColorBands] = size(rgbImage);
%==========================================================================
% The first way to divide an image up into blocks is by using mat2cell().
blockSizeR = chip_size; % Rows in block.
blockSizeC = chip_size; % Columns in block.
% Figure out the size of each block in rows. 
% Most will be blockSizeR but there may be a remainder amount of less than that.
wholeBlockRows = floor(rows / blockSizeR);
blockVectorR = [blockSizeR * ones(1, wholeBlockRows), rem(rows, blockSizeR)];
% Figure out the size of each block in columns. 
wholeBlockCols = floor(columns / blockSizeC);
blockVectorC = [blockSizeC * ones(1, wholeBlockCols), rem(columns, blockSizeC)]; 
% Create the cell array, ca.  
% Each cell (except for the remainder cells at the end of the image)
% in the array contains a blockSizeR by blockSizeC by 3 color array.
% This line is where the image is actually divided up into blocks. % Use to ROW/COL to rebuild tiles
if numberOfColorBands > 1
  % It's a color image.
  ca = mat2cell(rgbImage, blockVectorR, blockVectorC, numberOfColorBands);
else
  ca = mat2cell(rgbImage, blockVectorR, blockVectorC);
end

%% Save chips as png files, create matrix of filenames to name txt files
fnum = 0;
for yi = 1:size(ca,1); % the first row and last column are kept in this working version
    for xi = 1:size(ca,2);
        imwrite(ca{yi,xi},strcat(root_filename,'_',string(fnum),'.png'))
        chipnames{yi,xi} = strcat(root_filename,'_',string(fnum));
        fnum = fnum +1;
    end
end
disp('LOOK AT THE PRETTY CORALS');

%% Rebuild the image to make sure it is correctly mapped. 

clear
imCell=cell(9,12);
currentFile=0;
for row=(1:9);
    for column=(1:12);
        currImage=imread(strcat('ESB2020_',string(currentFile),'.png'));
        imCell{row,column}=currImage;
        currentFile=currentFile +1;
    end
end
reTiledImage=cell2mat(imCell);
figure;imshow(reTiledImage);
        
        