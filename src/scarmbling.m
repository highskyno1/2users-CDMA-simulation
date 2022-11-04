%加扰函数
%source:被加扰的信号
%PNCode:用于加扰的扰码
%按1:1的数据加扰
function res = scarmbling(source,PNCode)
    res = bitMultiple(source,PNCode);
end