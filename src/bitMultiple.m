%按bit循环相乘函数,如果信号长度不一致,则较短的信号被循环使用
%signal1:相乘信号1
%signal2:相乘信号2
%res:相乘结果
function res = bitMultiple(signal_1,signal_2)
    sizeSource = length(signal_1);
    sizePNCode = length(signal_2);
    %如果长度不满足条件时,调换顺序递归调用
    if sizeSource < sizePNCode
        res = bitMultiple(signal_2,signal_1);
        return;
    end
    res = zeros(1,sizeSource);
    for i = 1:sizeSource
        res(i) = signal_1(i) * signal_2(mod(i-1,sizePNCode)+1);
    end
end