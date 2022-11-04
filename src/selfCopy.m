%本函数实现数组的周期延拓
%input:需要延拓的数组
%times-1:延拓的次数
%比如selfCopy([1,2,3],2) = [[1,2,3,1,2,3,1,2,3],[1 1 2 2 3 3]]
function [res,res2] = selfCopy(input,times)
    if times <= 1
        res = input;
    else
        res = zeros(length(input),times);
        for i = 1:times
            res(:,i) = input;
        end
        res2 = res';
        res2 = res2(:)';
        res = res(:)';
    end
end