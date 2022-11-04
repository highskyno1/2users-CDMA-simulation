% 本函数用户把随机生成的0~1之间的double数转换成双极性码
function res = value2Bipolar(input)
    res = zeros(1,length(input));
    for index = 1:length(input)
        if(input(index) < 0.5)
            res(index) = -1;
        else
            res(index) = 1;
        end
    end
    res = int8(res);
end