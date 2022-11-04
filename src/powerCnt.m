%计算输入信号的平均功率(dBW)
function res = powerCnt(input)
    res = 10*log10(sum(input.*input));
end