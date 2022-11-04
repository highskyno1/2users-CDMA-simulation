%本函数用于生成指定数量的随机三极性码,主要用于做模块测试
%num:数量
%res:满载结果的数组
function res = tripleGen(num)
    raw = rand(1,num);
    for i = 1:num
        if raw(i) >= 0.75
            raw(i) = 1;
        elseif raw(i) <= 0.25
            raw(i) = -1;
        else
            raw(i) = 0;
        end
    end
    res = int8(raw);
end