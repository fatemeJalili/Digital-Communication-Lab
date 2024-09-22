clc, clear, close all;
rng(1);

%% Section 3-1
%Part 1
dclInitialize;

%% Section 3-2

%Part 1
headerBits = repmat(reshape(de2bi(hex2dec(('1C6387FF5DA4FA325C895958DC5')'))', [], 1),1,k);
txBit = [headerBits; bitGenerator(nPacketSymbols - size(headerBits, 1), k)];

%Part 2
if(isGray==1)
    matrix = grayMatrixGenerator(k);
    symbolIndex = zeros(nPacketSymbols, 1);
    for i = 1:nPacketSymbols
        symbolIndex(i) = find(all(matrix == txBit(i, :), 2)) - 1;
    end
else
    symbolIndex = bi2de(txBit, 'left-msb');
end

[cons, symbolEnergy] = constellation(M, modulation);
symbolArray(:, 1) = cons(symbolIndex+1);

%Part 3
[txSamples, cons] = pulseModulation(symbolIndex,...
    modulation, M, fs, nSymbolSamples, pulseName , pulseShapingMode);

headerSamples = txSamples(1 : size(headerBits, 1) * 8);
subplot(2, 1, 1);
plot(real(txSamples))
hold on
plot(imag(txSamples))
legend('real', 'imag')
title('TX Sampels');
subplot(2, 1, 2);
plot(real(headerSamples))
hold on
plot(imag(headerSamples))
legend('real', 'imag')
title('Header Sampels');

%% Section 3-3
figure
%Part 1
txSamplesDelayed = [zeros(channelDelayInSample, 1); txSamples];
if(rxMode==0)
    txSamplesDelayed = txSamplesDelayed(1 : end - channelDelayInSample);
end
%Part 2
txSamplesDelayed = txSamplesDelayed .* exp(1j*channelPhaseOffset);

%Part 3-12
berList = [];
for snr = snrMin:snrStep:snrMax
    noiseVariance = (symbolEnergy/k) ./ 10^(0.1*snr);
    noiseSamples = (randn(size(txSamplesDelayed)) + 1j*randn(size(txSamplesDelayed))) .* sqrt(noiseVariance/2);
    rxSamplesPlusNoise = noiseSamples + txSamplesDelayed;
    rxSamples = rxSamplesPlusNoise;
    
    
    [corr, lags] = xcorr(rxSamples, headerSamples);
    [~, indx] = max(abs(corr));
    startIndx = lags(indx) + length(headerSamples) + 1;
    rxSamples = rxSamples(startIndx : end);
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
    
    [detectedSymbolsIndex, rxSymbols] = pulseDemodulation(rxSamples, modulation, M, fs, nSymbolSamples, pulseName , rxReceiveMode);
%     scatter(real(rxSymbols), imag(rxSymbols));
    
    if(isGray==1)
        detectedBits = matrix(detectedSymbolsIndex+1, :);
    else
        detectedBits = de2bi(detectedSymbolsIndex, k, 'left-msb');
    end
    if(rxMode==0)
        tempIndx = size(headerBits, 1) + channelDelayInSample/8 + 1;
    else
        tempIndx = size(headerBits, 1) + 1;
    end
    ser = sum(detectedSymbolsIndex~=symbolIndex(tempIndx : end)/size(symbolIndex(tempIndx : end),1));
    ber = sum(sum(txBit(tempIndx : end, :)~=detectedBits))/(k*size(txBit(tempIndx : end, :),1));
    berList = [berList, ber];
end
subplot(2, 1, 1)
EbNo = (snrMin:snrStep:snrMax);
semilogy(EbNo, berList);
hold on
berQ = berawgn(EbNo, modulation, M, 'nondiff');
semilogy(EbNo, berQ);
legend('Simulated', 'Matlab');
title([num2str(M), modulation, ' bit error rate']);

subplot(2, 1, 2)
scatter(real(rxSymbols), imag(rxSymbols))
axis equal
