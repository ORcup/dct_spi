%%DCT-spi
close all
clear all
clc

InputImg = im2double(imread('cameraman.tif'));                             %目标图像
%InputImg=round(rand(4)*100);
%figure,imshow(InputImg);title('Input image'); axis image;   

[m, n] = size(InputImg); 
C=zeros(m);
%C=dct_C(m);
%%
for i=0:m-1
    for j=0:n-1
        if i==0
            c=sqrt(1/m);
        else
            c=sqrt(2/m);
        end
        C(i+1,j+1)=c*cos(pi*(j+0.5)*i/m);
    end
end

%C=round(C*100)/100;

%%
dct_spec=C'*InputImg*C;
%%频域分割
cr=0.15;

for i=1:m
    for j=1:m
        %圆形采样
         cr_len=2*round(256*sqrt(cr/pi));
        if sqrt((i-1)^2+(j-1)^2)>cr_len
            dct_spec(i,j)=0;
        end
%         %三角采样
%         cr_len=round(256*sqrt(2*cr));
%         if i+j-2>cr_len
%             dct_spec(i,j)=0;
%         end
%         %正方形采样
%          cr_len=round(256*sqrt(cr));
%         if i-1>cr_len || j-1>cr_len
%             dct_spec(i,j)=0;
%         end
    end
end

%          Pattern  = imresize(Pattern, 1, 'bicubic');
%          Pattern = dither(Pattern);                                      
%          Pattern = imresize(Pattern, 0.5);

%%
Out_img=C*dct_spec*C';
figure,imshow(dct_spec); axis image;   
figure,imshow(Out_img);title('cr = 0.15'); axis image;   

fprintf('psnr = %f\n',psnr(Out_img,InputImg));
fprintf('ssim = %f\n',ssim(Out_img,InputImg));