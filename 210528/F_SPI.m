close all
clear all
clc

nStepPS = 4;                                                               % n阶相移
Phaseshift = 90;                                                           
Amplitude = 1;                                                             
SW_NOISE = 0;                                                              %噪音开关

InputImg = im2double(imread('cameraman.tif'));                             %目标图像
figure,imshow(InputImg);title('Input image'); axis image;   

[mRow, nCol] = size(InputImg);                                           

[fxMat, fyMat] = meshgrid([0:1:nCol-1]/nCol, [0:1:mRow-1]/mRow);           %拿频域坐标
fxMat = fftshift(fxMat);                                                   
fyMat = fftshift(fyMat);             

InitPhaseArr = [0, pi, pi/2, 3*pi/2];                                      %4步相移的相位矩阵
IntensityMat = zeros(mRow, nCol, nStepPS);                                 %模拟相机获取的光强矩阵，加一个相位维度              

if SW_NOISE
    ReponseNoise = rand(nCoeft * nStepPS) * 2;                             
end

cRan=1/3;                                                                  %用矩形压缩的比例
mRow_c=round(cRan*mRow);
nCol_c=round(cRan*nCol);
mRow_random=round(mRow/2-mRow_c/2):1:round(mRow/2+mRow_c/2)-1;
nCol_random=round(nCol/2-nCol_c/2):1:round(nCol/2+nCol_c/2)-1;

nCoeft=round(0.1*mRow*nCol) ;                                              %以0.1的取样率取样
mn_Random_value=round(sqrt(nCoeft))+1 ;

mn_Random=randperm(length(mRow_random),mn_Random_value) ;                   %随机取样，取得点行数与列数相同
for i_value=1:mn_Random_value
    mn_Random(i_value)=mRow_random(i_value);
end
OrderMat = zeros(nCoeft,2);                                                %将行与列存入一个[取样数，2]的矩阵
i_OrderMat=1;
for i_random = 1:mn_Random_value
    for j_random = 1:mn_Random_value
        OrderMat(i_OrderMat,:)=[mn_Random(i_random),mn_Random(j_random)];
        i_OrderMat = i_OrderMat+1;
    end
end


for iCoeft = 1:nCoeft                                                      %主循环，依次处理采样数据
    iRow = OrderMat(iCoeft,1);                                             
    jCol = OrderMat(iCoeft,2);                                             
    
    fx = fxMat(iRow,jCol);                                                 
    fy = fyMat(iRow,jCol);                                                    
    
     for iStep = 1:nStepPS                                                 %生成傅里叶基地图像，调制原数据
        
         Pattern  = F_Pattern( Amplitude, mRow, nCol, fx, fy, InitPhaseArr(iStep) );
  %%空间抖动      
%          Pattern  = imresize(Pattern, 1, 'bicubic');
%          Pattern = dither(Pattern);                                      
%          Pattern = imresize(Pattern, 0.5);
         
%%时间抖动        
% for i=8.00:-1.00:1.00
%     Pattern_bitplane= bitshift(bitget((Pattern.*100),8:-1:1),i-1);
%     subplot(3, 3, 9-i+1);
%    imshow(A_bitplane);
%     title(['位平面 ' num2str(i)]);
% end 
        IntensityMat(iRow, jCol, iStep) = sum(sum(InputImg .* Pattern));
     end
    fprintf('tryshot = %f\n',iCoeft);
end

[img, spec] = F_Reconstruction( IntensityMat );  %还原原图像

figure, imshow(img); caxis([0 1]); axis image;
title('Reconstructed Img');