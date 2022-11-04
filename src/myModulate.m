function res = myModulate(source,carrier)
%调制函数
%source:被调制信号
%carrier:载波信号
    sizeSource = length(source);
    sizeCarrier = length(carrier);
    res = zeros(sizeSource,sizeCarrier);
    for i = 1:sizeSource
        res(i,:) = double(source(i))*carrier;
    end
    %把res按行拼接成一行
    res = res';
    res = res(:);
end