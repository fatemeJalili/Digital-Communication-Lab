clc, clear, close all;
rng(1);

%% Section 3-1
%Part 1
dclInitialize;

%% Section 3-2

%Part 1
txBit = bitGenerator(nPacketSymbols, k);

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

[cons, symbolEnergy] = constellation(M, 'psk');
symbolArray(:, 1) = cons(symbolIndex+1);

%Part 3
[txSamples, cons] = pulseModulation(symbolIndex,...
    'psk', M, fs, nSymbolSamples, pulseName , pulseShapingMode);

plot(real(txSamples))
hold on
plot(imag(txSamples))
legend('real', 'imag')

%% Section 3-3
figure
%Part 1
txSamplesDelayed = [zeros(channelDelayInSample, 1); txSamples];
%Part 2
rxSamples = txSamplesDelayed .* exp(1j*channelPhaseOffset);

%Part 3
for snr = snrMin:snrStep:snrMax
    noiseVariance = (symbolEnergy/k) / 10^(0.1*snr);
    noiseSamples = (randn(size(rxSamples)) + 1j*randn(size(rxSamples))) * sqrt(noiseVariance/2);
    rxSamplesPlusNoise = noiseSamples + rxSamples;
    rxSamples = rxSamplesPlusNoise(1 : end - channelDelayInSample);
    rxMode = 'matched_filter';
    [detectedSymbolsIndex, rxSymbols] = pulseDemodulation(rxSamples, 'psk', M, fs, nSymbolSamples, pulseName , rxMode);
    scatter(real(rxSymbols), imag(rxSymbols));
    
    %Part 6
    if(isGray==1)
        detectedBits = matrix(detectedSymbolsIndex+1, :);
    else
        detectedBits = de2bi(detectedSymbolsIndex, k, 'left-msb');
    end
    ser = sum(detectedSymbolsIndex~=symbolIndex)/size(symbolIndex,1);
    ber = sum(sum(txBit~=detectedBits))/(k*size(txBit,1));
end


