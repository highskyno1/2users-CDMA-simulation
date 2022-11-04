%本函数用于去封装
%userCode:被用于脱壳的码元
%trueGain:加壳前的真正的扩频增益
function res = deTurb(userCode,trueGain)
    userCode = userCode(:)';
    sizeCode = length(userCode);
    userCode = reshape(userCode,trueGain,sizeCode/trueGain);
    userCode = userCode';
    res = int8(ones(1,sizeCode/trueGain));
    for i = 1:sizeCode/trueGain
        temp = sum(userCode(i,:));
        if temp < 0
            res(i) = -1;
        end
    end
end