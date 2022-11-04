function res = demodulate(input,carrier)
%本函数实现对接收信号的解调
%原理:极性比较
%input:被解调的信号
%carrier:载波信号

%按位循环相乘
res_bitMultiple = bitMultiple(input,carrier);
%分组相加
res_arrayGroupSum = arrayGroupSum(res_bitMultiple,length(carrier));
%{
    以上处理后，结果正负侧近似于泊松分布，为了处理方便，根据大数定理，
    近似地视为正态分布，从而计算阈值。按照正态分布，-1,1,0平分概率，每一个分得1/3的概率。
%}
%计算标准差
res_std = std(res_arrayGroupSum);
%计算平均数
res_mean = mean(res_arrayGroupSum);
%解算阈值
syms temp;
%以下计算时会有一个"Unable to solve symbolically. Returning a numeric solution using
%vpasolve"的警告,让系统不显示
warning off;
threshhold_negative = double(solve(normcdf(temp,res_mean,res_std)==1/3));
%计算概率为2/3时的阈值，也就是判决为1的阈值
threshhold_postive = double(solve(normcdf(temp,res_mean,res_std)==2/3));
res = zeros(1,length(res_arrayGroupSum));
for i = 1:length(res_arrayGroupSum)
    if res_arrayGroupSum(i) > threshhold_postive
        res(i) = 1;
    elseif res_arrayGroupSum(i) < threshhold_negative
        res(i) = -1;
    end
end
end