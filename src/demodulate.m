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
    假设两个用户发1和-1概率一样(即先验概率相等)，
    则合起来为1或-1的概率为1/4，0的概率为1/2，
    为了处理方便，根据大数定理，近似地视为正态分布，
    从而利用正态分布概率密度计算阈值。
%}
%计算方差
res_var = var(input);
%计算平均数
res_mean = mean(input);
%计算概率为1/4时的阈值，小于该阈值判决为-1的阈值
threshhold_negative = norminv(1/4,res_mean,res_var);
%计算概率为3/4时的阈值，大于该阈值判决为1的阈值
threshhold_postive = norminv(3/4,res_mean,res_var);
res = zeros(1,length(res_arrayGroupSum));
for i = 1:length(res_arrayGroupSum)
    if res_arrayGroupSum(i) > threshhold_postive
        res(i) = 1;
    elseif res_arrayGroupSum(i) < threshhold_negative
        res(i) = -1;
    end
end
end