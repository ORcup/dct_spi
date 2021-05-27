function [ Pattern ] = F_Pattern( amp, mRow, nCol, fx, fy, initPhase )

     fxArr = fftshift([0:nCol-1] / nCol);                           %产生频率且对折变换
     fyArr = fftshift([0:mRow-1] / mRow);                           
            
     iRow = find(fyArr == fy);                                      %由对应频域坐标中找出匹配的行列数
     jCol = find(fxArr == fx);                                      
            
     spec = zeros(mRow, nCol);                                      %产生一个mRow nCol的全零矩阵并给spec
     spec(iRow,jCol) = amp * mRow * nCol * exp(1i*initPhase);       %
     Pattern = (amp + amp * real(ifft2(ifftshift(spec)))) / 2;      %得到傅里叶基底图案的实部
     
end

