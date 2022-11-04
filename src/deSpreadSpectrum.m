%本函数用于解扩
%userCode:需要解扩的用户码元
%PNseq:用于扩频的随机码
%gain:扩频增益
%phase:用户扩频码相位
function res = deSpreadSpectrum(userCode,PNseq,gain,phase)
    [lineSize,~] = size(PNseq);
    PN = PNseq(phase:lineSize,:);
    PN = [PN;PNseq(1:phase-1,:)];
    temps = bitMultiple(userCode,PN(:)');
    %这里是matlab的一个小bug,重排序以列作为索引,我的要求是以行
    %作为索引,所以要行列反写再取转置矩阵
    temps = reshape(temps,gain,length(temps)/gain);
    temps = temps';
    %解扩第二步,码元判决
    res = ones(1,length(temps(:))/gain);
    for i = 1:length(temps(:))/gain
        if sum(temps(i,:)) < 0
            res(i) = -1;
        end
    end
end