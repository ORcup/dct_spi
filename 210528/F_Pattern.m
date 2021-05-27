function [ Pattern ] = F_Pattern( amp, mRow, nCol, fx, fy, initPhase )

     fxArr = fftshift([0:nCol-1] / nCol);                           %����Ƶ���Ҷ��۱任
     fyArr = fftshift([0:mRow-1] / mRow);                           
            
     iRow = find(fyArr == fy);                                      %�ɶ�ӦƵ���������ҳ�ƥ���������
     jCol = find(fxArr == fx);                                      
            
     spec = zeros(mRow, nCol);                                      %����һ��mRow nCol��ȫ����󲢸�spec
     spec(iRow,jCol) = amp * mRow * nCol * exp(1i*initPhase);       %
     Pattern = (amp + amp * real(ifft2(ifftshift(spec)))) / 2;      %�õ�����Ҷ����ͼ����ʵ��
     
end

