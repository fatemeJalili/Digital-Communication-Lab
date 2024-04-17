clc, clear, close all;
nSymbolSamples = 8;
nPacketSamples = 10;
k = 2;
M = 4;
fs = 10e6;
rng(1);

%% Section 2-1-1
txBit = bitGenerator(nPacketSamples, k);

%% Section 2-1-2

% Part 1 & 2
grayMatrix = grayMatrixGenerator(2);
fprintf("Gray Matrix:\n");
disp(grayMatrix);

symbolIndex = zeros(nPacketSamples, 1);
for i = 1:nPacketSamples
    symbolIndex(i) = find(all(grayMatrix == txBit(i, :), 2)) - 1;
end
fprintf("Symbol Indices:\n");
disp(symbolIndex);

% Part 3
[cons, symbolEnergy] = constellation(M, 'pam');
symbolArray(:, 1) = cons(symbolIndex+1);
fprintf("Symbol Array:\n");
disp(symbolArray);

%% Section 2-1-3
figure

[txSamples, cons] = pulseModulation(symbolIndex, 'pam', M, fs, nSymbolSamples, 'triangular' , 'kron');
subplot(2, 1, 1)
stem(txSamples, 'filled');
xlabel('Samples')
title('Kron')

[txSamples, cons] = pulseModulation(symbolIndex, 'pam', M, fs, nSymbolSamples, 'triangular' , 'conv');
subplot(2, 1, 2)
stem(txSamples, 'filled');
xlabel('Samples')
title('Conv')

%% Section 2-2-1 
rxSamples = txSamples;
p = pulseCreator('triangular', nSymbolSamples);

rxSymbols = symbolDetection(rxSamples, p, nSymbolSamples, 'correlator');
fprintf("rxSymbols with correlator:\n");
disp(rxSymbols);

rxSymbols = symbolDetection(rxSamples, p, nSymbolSamples, 'matched_filter');
fprintf("rxSymbols with matched_filter:\n");
disp(rxSymbols);

%% Section 2-2-2
detectedSymbols = minDistanceDetector(rxSymbols, cons);
fprintf("Detected symbols indices:\n");
disp(detectedSymbols);

%% Section 2-2-3
[detectedSymbolsIndex, rxSymbols] = pulseDemodulation(rxSamples, 'pam', M, fs, nSymbolSamples, 'triangular' , 'matched_filter');
fprintf("Detected symbols indices and Rx symbols:\n");
disp(detectedSymbolsIndex);
disp(rxSymbols);

%% Section 2-2-4
detectedBits = grayMatrix(detectedSymbolsIndex, :);
detectedBitsDecimal = bi2de(detectedBits, 'left-msb');
fprintf("Detected bits in binary and decimal:\n");
disp(detectedBits)
disp(detectedBitsDecimal)