%产生双极性码
%num:双极性码的规模
%res:满载双极性码的数组
function res = genBipolar(num)
    res = rand(1,num);
    res = value2Bipolar(res);
end