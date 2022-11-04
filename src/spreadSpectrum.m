%扩频函数
%userCode:需要扩频的用户码元
%PNseq:用于扩频的随机码
%gain:扩频增益
%phase:用户扩频码相位
function res = spreadSpectrum(userCode,PNseq,gain,phase)
    %首先对码元进行周期延拓
    [~,userCode2] = selfCopy(userCode,gain);
    %计算扩频码的行数
    [lineSize,~] = size(PNseq);
    %对扩频码进行重排行序,使初相位位于第一行
    PN = PNseq(phase:lineSize,:);
    PN = [PN;PNseq(1:phase-1,:)];
    res = bitMultiple(userCode2,PN(:)');
end