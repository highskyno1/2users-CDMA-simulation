%{
    本函数是整个仿真的主函数，用于研究在移动通信时，信噪比对误码率的影响
首先生成随机双极性码，然后经过扩频，加扰，BPSK调制，加高斯白噪声，混合
然后模拟接收端的解调，去扰，解扩，判决。
    通过比较接收端判决输出与原来的码元，计算出误码率，首先通信系统的仿真
以及误码率-信噪比的变化曲线的绘制.
2019/11/22(以上)
    在当前版本中，添加了对信噪比&误码率曲线随BPSK调制载波振幅变化而变化
的相关研究功能。因为实际发现，之前的代码中曲线会在-20dB到0dB处出现平缓现象，
实际排查发现是载波的振幅导致的。振幅研究结果发现：振幅小于0.4时，系统无法正常
工作！其误码率曲线在后期随着信噪比的增加呈现反常膨胀！
^-^想要得到抛物线，只有在载波振幅为1的时候。^-^,不然随着振幅的增加，曲线曲线趋于平缓的信噪比范围会越大；
同时发现大于0.6的曲线会近似相交于某一点，交点前同等信噪比下振幅高的误码率低，但在交点后
***同等的信噪比下振幅小的误码率反而低！！！***
    在本版本中，walsh矩阵的所有码元都被用于扩频，没有使用前一版的矩阵截取方法，
规避了鬼魅版的非严格正交问题，但前面的截取版本恰恰说明非严格正交对本系统影响曲线
的影响并不是很大，但却可以使得系统能在更低的误码率下工作。
    至此，代码已经经历10次版本迭代。
2019/12/1(以上)
    第二次答辩，仍出现部分平滑问题，并且老师说系统性能太好了，与实际系统不符，并且
曲线不应该受振幅的影响，基于此再对代码做修改，计算了输入信号的平均功率，作为第3
个参数传给awgn，否则awgn会把输入信号的功率视为0dBW！现在曲线基本重合。但0.2与0.4
的问题仍未解决！
    至此，程序第11次版本迭代
2019/12/2(以上)
    第十二次迭代。
    发现了为什么振幅是0.2和0.4时，系统无法正常工作的原因，是因为
bitMultiple函数把运算结果格式转换成了int8，导致精度大量失真！当时转换格式是为
内存空间与运行速度做打算，结果今天发现做了负优化！修改后，发现载波振幅对于系统
的误码率曲线几乎无影响。
    另外，解调函数也做了修改，会根据输入自动计算判决阈值，解决了之前人为设定阈值
的局限，阈值采用正态分布解算法，详见demodulate函数内注释。
2020/7/1(以上)
    i7-4790:实测速率9.8秒/轮回 @1280*2&1280码元20&10扩频增益
    第十三次迭代。
    解决加扰函数只使用了M序列第一行的问题。
2022/1/21(以上)
    i7-12700K:实测速率 2.4秒/轮回 @1280*2&1280码元20&10扩频增益
    Module函数名改名为myModule，防止与Matlab内建函数重名的bug
    修改testModulate函数，增加row码元长度，防止码元与扩频码被交换的bug
2022/4/28(以上)
    i7-12700K:实测速率 0.91秒/轮回 @1280*2&1280码元20&10扩频增益 12线程
    修复解调模块阈值解算的Bug，改为利用"norminv"解算阈值，
    可见运行速度显著提高，同时改为var计算方差，感谢网友的提醒。
2022/12/17(以上)
%}
clear variable;
close all;

mulTimes = 5;  %轮回次数

walshOrder = 64;    %walsh码的阶数，必须大于扩频增益

N1 = 1280*2;   %用户1码元数量
N2 = 1280;   %用户2码元数量

user1SPgain = 10;  %用户1的扩频增益
user2SPgain = 20;  %用户2的扩频增益

%记录两个用户的walsh相位,注意相位必须在1到64之间取值
%两个用户的取值不能一样
user1Phase = 2; %用户1的相位
user2Phase = 16; %用户2的相位

%加扰使用的m序列的参数
mOrder = 5; %级数5级
feedBack = 67;%反馈系数67

%调整时，半个周期的采样点数
samplePiont = 4;

%生成需要使用的walsh码
walshCode = walsh(walshOrder);

%针对低性能电脑做优化，采取以时间换取空间的思路
maxSnr = 40;    %尝试的最大信噪比
minSnr = -20;   %尝试的最小信噪比
div = 1;      %信噪比的尝试步进
maxTime = (maxSnr-minSnr)/div;  %尝试次数
timesUser1Acc = zeros(mulTimes,maxTime);
timesUser2Acc = zeros(mulTimes,maxTime);

%生成双极性码片
user1 = genBipolar(N1);
user2 = genBipolar(N2);   

%扩频
spread1 = spreadSpectrum(user1,walshCode,user1SPgain,user1Phase);
spread2 = spreadSpectrum(user2,walshCode,user2SPgain,user2Phase);

%加扰
Mseq1 = MseqGen(mOrder,feedBack); %用户1加扰用的m序列
Mseq1 = Mseq1(:);
Mseq2 = MseqGen(mOrder,feedBack); %用户2加扰用的m序列
Mseq2 = Mseq2(:);
user1scarm = scarmbling(spread1,Mseq1);
user2scarm = scarmbling(spread2,Mseq2);

maxAmp = 1.2;    %尝试的最大载波振幅
minAmp = 0.2;   %尝试的最小载波振幅
divAmp = 0.2;      %载波振幅的尝试步进
maxTimesAmp = floor((maxAmp-minAmp)/divAmp);  %振幅尝试次数

ampRecords1 = zeros(maxTimesAmp,maxTime);
ampRecords2 = zeros(maxTimesAmp,maxTime);

for amp = 1:maxTimesAmp %测试不同的载波振幅下的曲线
    
    fprintf('目前正在第%d个振幅\n',amp);

    %调制BPSK
    %生成载波,两用户使用同一个载波
    carrier = (minAmp + divAmp*(amp-1))*sin(0:(pi/samplePiont):(2*pi-2*pi/samplePiont));
    user1modulate = myModulate(user1scarm,carrier);
    user2modulate = myModulate(user2scarm,carrier);
    
    for times = 1:mulTimes

        fprintf('目前正在第%d个轮回\n',times);

        user1Acc = zeros(1,maxTime);
        user2Acc = zeros(1,maxTime);

        parfor index = 1:maxTime 
            snr = minSnr + (index-1)*div; %加在发送信号上的高斯噪声的信噪比(dBW)
                        
            %通过高斯信道，添加高斯噪声
            user1send = awgn(user1modulate,snr);
            user2send = awgn(user2modulate,snr);

            %接收方
            receive = user1send + user2send; %收到混合起来的信号

            %解调
            demodulateRes = demodulate(receive,carrier);

            %去扰
            user1Descarm = deScarmbling(demodulateRes,Mseq1);
            user2Descarm = deScarmbling(demodulateRes,Mseq2);

            %解扩
            user1deDS = deSpreadSpectrum(user1Descarm,walshCode,user1SPgain,user1Phase);
            user2deDS = deSpreadSpectrum(user2Descarm,walshCode,user2SPgain,user2Phase);

            %计算误码率
            [~,user1Accuracy] = compare(user1,user1deDS);
            [~,user2Accuracy] = compare(user2,user2deDS);
            user1Acc(index) = 1-user1Accuracy;
            user2Acc(index) = 1-user2Accuracy;
        end
        timesUser1Acc(times,:) = user1Acc;
        timesUser2Acc(times,:) = user2Acc;
    end
    %总结统计多次实验的结果
    for i = 1:maxTime
        user1Acc(i) = mean(timesUser1Acc(:,i));
        user2Acc(i) = mean(timesUser2Acc(:,i));
    end
    ampRecords1(amp,:) = user1Acc;
    ampRecords2(amp,:) = user2Acc;
end

%误码率随信噪比的变化曲线
figure(1);
X1 = (minSnr:div:maxSnr-div);
semilogy(X1,ampRecords1(5,:),'b');
xlabel('信噪比(dB)');
ylabel('误码率');
title('误码率随信噪比的变化曲线');
hold on;
semilogy(X1,ampRecords2(5,:),'g');
legend('用户1(扩频增益10)','用户2(扩频增益20)');

%用户1振幅不同的误码率随信噪比的变化曲线
figure(2);
for i = 1:maxTimesAmp
    semilogy(X1,ampRecords1(i,:));
    hold on;
end
xlabel('信噪比(dB)');
ylabel('误码率');
title('用户1振幅不同的误码率随信噪比的变化曲线');
legend('0.2','0.4','0.6','0.8','1.0');

%用户2振幅不同的误码率随信噪比的变化曲线
figure(3);
for i = 1:maxTimesAmp
    semilogy(X1,ampRecords2(i,:));
    hold on;
end
xlabel('信噪比(dB)');
ylabel('误码率');
title('用户2振幅不同的误码率随信噪比的变化曲线');
legend('0.2','0.4','0.6','0.8','1.0');
