%统计一个数字的位数,并返回每位的数字
function [Places,item] = getPalces(value)
    Places = 0;
    temp = abs(value);
    while temp ~= 0
        temp = floor(temp/10);
        Places = Places + 1;
    end
    item = uint8(zeros(1,Places));
    temp = value;
    for i = Places:-1:1
        item(i) = mod(temp,10);
        temp = floor(temp/10);
    end
end