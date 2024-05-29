clc, clear, close all;
rng(1);

%% Section 3-1
%Part 1
dclInitialize;

%% Section 3-2

%Part 1
headerBits = repmat(reshape(de2bi(hex2dec(['1C6387FF5DA4FA325C895958DC5']'))', [], 1),1,k);
if(isHeader)
    txBit = [headerBits; bitGenerator(nPacketSymbols - size(headerBits, 1), k)];
else
    txBit = bitGenerator(nPacketSymbols, k);
end

%Part 2
if isGray
    matrix = grayMatrixGenerator(k);
    symbolIndex = zeros(nPacketSymbols, 1);
    for i = 1:nPacketSymbols
        symbolIndex(i) = find(all(matrix == txBit(i, :), 2)) - 1;
    end
else
    symbolIndex = bi2de(txBit, 'left-msb');
end

%Part 3
[txSamples, cons] = pulseModulation(symbolIndex,...
    modulation, M, fs, nSymbolSamples, pulseName , pulseShapingMode);
txSamples = txSamples + 1j*eps;
if(isHeader)
    headerSamples = txSamples(1 : size(headerBits, 1) * nSymbolSamples);
end

%% Section 3-3
figure
%Part 1
txSamplesDelayed = [zeros(channelDelayInSample, 1); txSamples];
if(rxMode == 0)
    txSamplesDelayed = txSamplesDelayed(1 : end - channelDelayInSample);
end
%Part 2
txSamplesDelayed = txSamplesDelayed .* exp(1j*channelPhaseOffset);

%Part 3-12
berList = [];
for snr = snrMin:snrStep:snrMax
    noiseVariance = (1/k) ./ 10^(0.1*snr);
%     noiseVariance = 0;
    noiseSamples = (randn(size(txSamplesDelayed)) + 1j*randn(size(txSamplesDelayed))) .* sqrt(noiseVariance/2);
    rxSamplesPlusNoise = noiseSamples + txSamplesDelayed;
    rxSamples = rxSamplesPlusNoise;
    
    if(isHeader)
        [corr, lags] = xcorr(rxSamples, headerSamples);
        corr = corr(lags>=0);
        lags = lags(lags>=0);
        [~, indx] = max(abs(corr));
%         startIndx = lags(indx) + length(headerSamples) + 1;
        rxSamples = rxSamples(indx : end);
        L = length(rxSamples);
        rxSamples = rxSamples(1:floor(L/nSymbolSamples)*nSymbolSamples);
        switch equalizerMode
            case 0
                alpha = 1;
                theta = 0;
            case 1
                val1 = abs(corr(indx)).^2;
                val2 = headerSamples'*headerSamples;
                alpha = val2/val1;
                theta = 0;
            case 2
                alpha = 1;
                theta = -angle(corr(indx));
            case 3
                val1 = abs(corr(indx)).^2;
                val2 = headerSamples'*headerSamples;
                alpha = val2/val1;
                theta = -angle(corr(indx));
        end
        rxSamples = alpha * rxSamples * exp(1j * theta);
    end
    
    [detectedSymbolsIndex, rxSymbols] = pulseDemodulation(rxSamples, modulation, M, fs, nSymbolSamples, pulseName , rxReceiveMode);
    
    if(isGray==1)
        detectedBits = matrix(detectedSymbolsIndex+1, :);
    else
        detectedBits = de2bi(detectedSymbolsIndex, k, 'left-msb');
    end
%     if(isHeader)
%         if(rxMode==0)
%             tempIndx = size(headerBits, 1) + channelDelayInSample/8 + 1;
%         else
%             tempIndx = size(headerBits, 1) + 1;
%         end
%         ser = sum(detectedSymbolsIndex~=symbolIndex(tempIndx : end)/size(symbolIndex(tempIndx : end),1));
%         ber = sum(sum(txBit(tempIndx : end, :)~=detectedBits))/(k*size(txBit(tempIndx : end, :),1));
%         berList = [berList, ber];
%     else
    L = length(detectedSymbolsIndex);
    ser = sum(detectedSymbolsIndex~=symbolIndex(1:L))/L;
    ber = sum(sum(txBit(1:L, :)~=detectedBits))/(k*L);
    berList = [berList, ber];
%     end
end
EbNo = (snrMin:snrStep:snrMax);
semilogy(EbNo, berList);
hold on
berQ = berawgn(EbNo, modulation, M, 'coherent');
semilogy(EbNo, berQ);
legend('Simulated', 'Matlab');
title([num2str(M), modulation, ' bit error rate']);
