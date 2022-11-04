%八进制转二进制,返回一个二进制数组
function res = Oct2Bin(value)
    [bitNum,bit] = getPalces(value);
    res = int8(zeros(1,bitNum*3));
    for i = 1:bitNum*3
        bitMain = bit(floor((i-1)/3)+1);
        switch mod(i-1,3)
            case 0
                if bitMain >= 4
                    res(i) = 1;
                end
            case 1
                if bitMain == 2 || bitMain == 3 || bitMain == 6 || bitMain == 7
                   res(i) = 1;
                end
            case 2
                if mod(bitMain,2) ~= 0
                    res(i) = 1;
                end
        end
    end
    for i = 1:bitNum*3
        if res(i) ~= 0
            break;
        end
    end
    res = flip(res(i:end));
end