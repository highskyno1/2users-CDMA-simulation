%比较两个数组
%input1:数组1
%input2:数组2
%res:正确码元数量
%accuracy:正确率
function [res,accuracy] = compare(input1,input2)
    temp = (input1 == input2);
    res = length(find(temp == 1));
    sizeInput = max(length(input1),length(input2));
    accuracy = res/double(sizeInput);
end