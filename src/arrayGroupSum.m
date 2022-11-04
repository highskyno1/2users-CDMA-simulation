function res = arrayGroupSum(input,group_num)
%arrayGroupSum 数组分组求和,如果数组长度除去group_num无法整除，则截短input数组
%input 目标数组
%group_num 分组数
len = floor(length(input)/group_num);
res = zeros(1,len);
for i = 1:len
    res(i) = sum(input((i-1)*group_num+1:i*group_num));
end
end

