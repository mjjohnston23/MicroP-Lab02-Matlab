%ECSE 426 - MicroP
%Lab 2 
%Choosing the depth of our moving average filter


%Dataset: temps in degC.  Start at 20, increase to 40 over a period of 10
%seconds, hold at 40 for 5 seconds, and then cool down to 20 over a period
%of 15 seconds.  We will also introduce Gaussian white noise to this
%pattern using the  awgn() function.

%We will play around with the filter depth.  If it's too small, the
%filtered signal will be noisy, but if it's too large, there will be major
%lag in the filtered output.

samplingFreq = 20; %in Hertz

heatTime = 10;
stableTime = 5;
coolTime = 15;
startTemp = 20;
stableTemp = 40;
endTemp = 20;

stepsHeat = samplingFreq*heatTime;
stepsStable = samplingFreq*stableTime;
stepsCool = samplingFreq*coolTime;

temp = 1:(samplingFreq*(heatTime + stableTime + coolTime));

for i = 1:stepsHeat
    temp(i) = (stableTemp - startTemp)/(stepsHeat)*i + startTemp;
end
for i = stepsHeat+1:stepsHeat+stepsStable
    temp(i) = stableTemp;
end
for i = stepsHeat+stepsStable+1:stepsHeat+stepsStable+stepsCool 
   temp(i) = (endTemp - stableTemp)/(stepsCool)*(i-(stepsHeat+stepsStable+1)) + stableTemp;
end
noisyTemp = awgn(temp, 5); %SNR = 5, makes the setup interesting

temp = int32(noisyTemp); %cast as integer

filterDepth = 30; %play with this figure

filter = zeros(filterDepth, 1);
filterResult = 1:(samplingFreq*(heatTime + stableTime + coolTime));

for i = 1:(samplingFreq*(heatTime + stableTime + coolTime))
    for j = filterDepth:-1:2
        filter(j) = filter(j-1);
    end
    filter(1) = temp(i);
    filterResult(i) = mean(filter);
end

%plot unfiltered and filtered
subplot(2,1,1)
plot(temp)
subplot(2,1,2)
plot(filterResult)

