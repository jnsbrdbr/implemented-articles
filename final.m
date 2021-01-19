clc;
clear;
close all;

% some samples:
% 'office_3.jpg'
% 'greens.jpg'
% 'hands1.jpg'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


mypic = imread('office_3.jpg');
subplot(4,2,2);
image(mypic);
title 'low contras picture';
axis off;        
axis image;


YCbCr = rgb2ycbcr(mypic);
subplot(4,2,1);
imshow(YCbCr);
title 'converting rgb to YCbCr';


subplot(4,2,3)
Y = YCbCr(:,:,1);
imshow(Y);
title ('picture of channel Y','fontsize',8);



subplot(4,2,4)
imhist(Y);
title ('histogram of channel Y','fontsize',8);

[pixelCounts grayLevels] = imhist(Y);

stdy=std(pixelCounts); %calculate standard deviation of each channel.

ABMy = stdy + double(pixelCounts); %as the article said:additional based histogram modification:hi+delta which delta is standard deviation


%calculate of Y-LBH

G=3/4*stdy;

Hm = compand(ABMy,G,max(ABMy(:)),'A/compressor');

%histogram Y-equalization
subplot(4,2,5) 
 Yeq = histeq(Y, Hm);
 imhist(Yeq);
title ('hisogram equalization of channel Y','fontsize',8);

subplot(4,2,6)
imshow(Yeq);
title ('Image of equalization of channel Y','fontsize',8);



%entropy of input image
ei=entropy(mypic);



%entropy of ago Y-image
Yent=entropy(Yeq);



%Y-alfa
Yent=Yent-ei;
Yalfa=1+sqrt(Yent);


%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%
%%%%%%%% DCT of channel Y %%%%%%
%%%%%%%%%%
[xxx,zzz]=size(Yeq);
B = dct2(Yeq,[xxx zzz]);
if abs(B)>0.01*B
    B;
else
    B=Yalfa*B;
end
U=idct2(B);


wq=cat(3,U,YCbCr(:,:,2),YCbCr(:,:,3));

subplot(4,2,7) 
 imshow(wq);
title ('image of concatenating of 3 channle','fontsize',8);

myfinalpic = ycbcr2rgb(wq);
subplot(4,2,8) 
 imshow(myfinalpic);
title ('final image','fontsize',8);
