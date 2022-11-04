function testTurb()
    user1 = genBipolar(1000);
    [user1new,~] = selfCopy(user1,5);
    res = deTurb(user1new,5);
    [trueNum,accuracy] = compare(user1,res);
    fprintf("正确码元数量:%d\n正确率:%f\n",trueNum,accuracy); 
end