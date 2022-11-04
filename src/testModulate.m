%本代码用于测试BPSK调制与解调模块能否正常工作
function testModulate()
    carrier = 10*sin(0:pi/32:2*pi-pi/32);
    raw = tripleGen(1e6);
    afterModu = myModulate(raw,carrier);
    res = demodulate(afterModu,carrier);
    [trueNum,accuracy] = compare(raw,res);
    fprintf("正确码元数量:%d\n正确率:%f\n",trueNum,accuracy);   
end