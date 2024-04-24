clc, clear;
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

[cons, symbolEnergy] = constellation(M, modulation);
symbolArray(:, 1) = cons(symbolIndex+1);

%Part 3
[txSamples, cons] = pulseModulation(symbolIndex,...
    modulation, M, fs, nSymbolSamples, pulseName , pulseShapingMode);

% plot(real(txSamples))
% hold on
% plot(imag(txSamples))
% legend('real', 'imag')

%% Section 3-3
figure
%Part 1
txSamplesDelayed = [zeros(channelDelayInSample, 1); txSamples];
txSamplesDelayed = txSamplesDelayed(1 : end - channelDelayInSample);
%Part 2
txSamplesDelayed = txSamplesDelayed .* exp(1j*channelPhaseOffset);

%Part 3-12
berList = [];
for snr = snrMin:snrStep:snrMax
    noiseVariance = (symbolEnergy/k) ./ 10^(0.1*snr);
    noiseSamples = (randn(size(txSamplesDelayed)) + 1j*randn(size(txSamplesDelayed))) .* sqrt(noiseVariance/2);
    rxSamplesPlusNoise = noiseSamples + txSamplesDelayed;
    rxSamples = rxSamplesPlusNoise;
    [detectedSymbolsIndex, rxSymbols] = pulseDemodulation(rxSamples, modulation, M, fs, nSymbolSamples, pulseName , rxReceiveMode);
    scatter(real(rxSymbols), imag(rxSymbols));
    
    if(isGray==1)
        detectedBits = matrix(detectedSymbolsIndex+1, :);
    else
        detectedBits = de2bi(detectedSymbolsIndex, k, 'left-msb');
    end
    ser = sum(detectedSymbolsIndex~=symbolIndex)/size(symbolIndex,1);
    ber = sum(sum(txBit~=detectedBits))/(k*size(txBit,1));
    berList = [berList, ber];
end
% subplot(2, 1, 1)
% EbNo = (snrMin:snrStep:snrMax);
% semilogy(EbNo, berList);
% hold on
% berQ = berawgn(EbNo, modulation, M, 'nondiff');
% semilogy(EbNo, berQ);
% legend('Simulated', 'Matlab');
% title([num2str(M), modulation, ' bit error rate']);

% subplot(2, 1, 2)
scatter(real(rxSymbols), imag(rxSymbols))
axis equal
