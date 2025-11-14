clear all

% Define Image Database directory and images filename prefix
ImDB_path = 'C:\Users\biel.sala\Downloads\Prog1\UKentuckyDatabase\';
ImDB_name_prefix = 'ukbench';
% Parameters for feature extraction
hist_bins = 256;

tic;

for i = 0:1999
	filename = [ImDB_path, ImDB_name_prefix, sprintf('%05d.jpg',i)];
   % Read color image, convert color image to gray scale and get the histogram
	I = rgb2gray(imread(filename));
	H(i+1,:) = imhist(I, hist_bins);
end

toc

save("H.mat","H")        % Inverse operation: load("H.mat","H") 

% Draw DB histograms as a 3D matrix
% figure(1); mesh(H); colormap('parula'); colorbar; axis('tight');
% title(['Image histograms (with ',sprintf('%03d',hist_bins),' bins)']);
% xlabel('Histogram Bins (Pixel Values)'); ylabel('Image Filename Index');
% zlabel('Number of pixels');
