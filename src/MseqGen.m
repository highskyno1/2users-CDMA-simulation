%M序列发生器
%order:阶数
%setBakc:反馈系数
function res = MseqGen(order,feedBack)
    res = zeros(2^order-1,order);
    feedBack = Oct2Bin(feedBack);
    feedBack = feedBack(2:end);
    temp = rand(1,order);
    temp(temp < 0.5) = 0;
    temp(temp >= 0.5) = 1;
    res(1,:) = temp;
    for i = 2:2^order-1
        newBit = sum(res(i-1,feedBack == 1));
        newBit = mod(newBit,2);
        for j = 1:order-1
            res(i,j+1) = res(i-1,j);
        end
        res(i,1) = newBit;
    end
    res(res == 0) = -1;
end