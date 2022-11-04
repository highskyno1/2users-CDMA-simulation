%本代码用于测试加扰，去扰模块能否正常工作
function testScarmbling()
    %M序列发生器可以自定义阶数和反馈系数
    Mseq = MseqGen(5,67); %产生加扰用的m序列
    raw = tripleGen(1e6);
    afterScarmb = scarmbling(raw,Mseq);
    res = deScarmbling(afterScarmb,Mseq);
    [trueNum,accuracy] = compare(raw,res);
    fprintf("正确码元数量:%d\n正确率:%f\n",trueNum,accuracy);    
end