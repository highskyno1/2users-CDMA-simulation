%本代码用于测试扩频，解扩模块是否正常工作
%注意扩频与解扩针对的是双极性码
%function testSpreadSpectrum()
    raw = genBipolar(1e4);
    walshCode = walsh(64);
    afterDSSS = spreadSpectrum(raw,walshCode,4,2);
    res= deSpreadSpectrum(afterDSSS,walshCode,4,2);
    [trueNum,accuracy] = compare(raw,res);
    fprintf("正确码元数量:%d\n正确率:%f\n",trueNum,accuracy); 
%end