% Uses Matlab imreducehaze

close all
clear, clc

base = '../night_images/';
f = dir([base,'*.png']);
f = f(1:end);
N = length(f);
ksc = 0.07;
w = 0.9;

for k = 1
    image = imread([base, f(k).name]);
    image = im2double(image);
    % This does well with preserving color.
    % Could remove it if so desire.
    imr = sqrt(image);

    % Load nighttime image
    image_lab = rgb2lab(image);
    
    % Invert and Enhance image   
    lum_invert = imcomplement(image_lab(:,:,1) ./ 100);
    lum_enhance = imcomplement(imreducehaze(lum_invert,'ContrastEnhancement','none'));
    
    % Convert back to nighttime image
    [row,col] = size(lum_enhance);
    image_lab_invert = zeros(row,col,3);
    image_lab_invert(:,:,1) = lum_enhance .* 100;
    image_lab_invert(:,:,2:3) = image_lab(:,:,2:3) * 2;
    image_invert = lab2rgb(image_lab_invert);

%     % Reduce noise
%     image_denoise = imguidedfilter(image_invert);
%     figure, montage({image, image_denoise});
%     output_file = sprintf('../night_images_enhanced_matlab/night_enhanced_%d.png',k);
%     imwrite(image_denoise, output_file);
    
end
