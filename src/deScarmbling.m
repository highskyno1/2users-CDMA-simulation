%本函数用于对信号做去扰处理,实际操作与加扰完全一致
%input:需要去扰的信号
%PNseq:用于去扰的随机序列
function res = deScarmbling(input,PNseq)
    res = bitMultiple(input,PNseq);
end