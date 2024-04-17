%% Section 1
clc, clear 
rng(1)

% Part 1
nSymbolSamples = 8;
nPacketSymbols = 10;
M = 4;
k = log2(M);

txBit = bitGenerator(nPacketSymbols, k);
fprintf("txBit=\n");
disp(txBit)

% Part 2
grayMatrix = grayMatrixGenerator(k);
fprintf("grayMatrix=\n");
disp(grayMatrix)

symbolIndex = zeros(nPacketSymbols, 1);
for indx = 1 : nPacketSymbols
    symbolIndex(indx,1) = find(sum(grayMatrix == txBit(indx,:),2) == 2);
end
fprintf("symbolIndex=\n");
disp(symbolIndex - 1)

modulationName = 'pam';
[cons, symbolEnergy] = constellation(M, modulationName);
symbolArray = zeros(nPacketSymbols, 1);
for indx = 1 : nPacketSymbols
    symbolArray(indx, 1) = cons(symbolIndex(indx, 1));
end
fprintf("symbolArray=\n");
disp(symbolArray)
fprintf("symbolEnergy=\n");
disp(symbolEnergy)

% Part 3
pulseName = 'triangle';
pulseShapingMode1 = 'kron';
pulseShapingMode2 = 'conv';
fs = 1;

[txSamples1, cons1] = pulseModulation(symbolIndex,...
    modulationName, M, fs, nSymbolSamples, pulseName , pulseShapingMode1);
fprintf("cons using kron=\n");
disp(cons1)
subplot(2, 1, 1)
stem(txSamples1, 'filled')
title('tx out Entries using kron')
xlabel('Samples')

[txSamples2, cons2] = pulseModulation(symbolIndex,...
    modulationName, M, fs, nSymbolSamples, pulseName , pulseShapingMode2);
fprintf("cons using conv=\n");
disp(cons2)
subplot(2, 1, 2)
stem(txSamples1, 'filled')
title('tx out Entries using conv')
xlabel('Samples')

%% Section 2
% Part 1
p = pulseShape(pulseName, fs, nSymbolSamples);
rxSamples = txSamples1;
% using correlator:
rxMode1 = 'correlator';
rxSymbols1 = symbolDetection(rxSamples, p, nSymbolSamples, rxMode1);
fprintf("rxSymbols using correlator=\n");
disp(rxSymbols1)

%using matched_filter:
rxMode2 = 'matched_filter';
rxSymbols2 = symbolDetection(rxSamples, p, nSymbolSamples, rxMode2);
fprintf("rxSymbols using matched_filter=\n");
disp(rxSymbols2)

% Part 2
detectedSymbols = minDistanceDetector(rxSymbols1, cons);
fprintf("detectedSymbols=\n");
disp(detectedSymbols)

% Part 3
% using correlator:
rxMode1 = 'correlator';
[detectedSymbolsIndex1, rxSymbols1] = pulseDemodulation(rxSamples, modulationName,...
    M, fs, nSymbolSamples, pulseName , rxMode1);
fprintf("detectedSymbolsIndex using correlator=\n");
disp(detectedSymbolsIndex1)
fprintf("rxSymbols using correlator=\n");
disp(rxSymbols1)


%using matched_filter:
rxMode2 = 'matched_filter';
[detectedSymbolsIndex2, rxSymbols2] = pulseDemodulation(rxSamples, modulationName,...
    M, fs, nSymbolSamples, pulseName , rxMode2);
fprintf("detectedSymbolsIndex using matched_filter=\n");
disp(detectedSymbolsIndex2)
fprintf("rxSymbols using matched_filter=\n");
disp(rxSymbols2)

% Part 4
detectedBits = grayMatrix(detectedSymbolsIndex1, :);
detectedBitsDecimal = bi2de(detectedBits, 'left-msb');
fprintf("detectedBits=\n");
disp(detectedBits)
fprintf("detectedBitsDecimal=\n");
disp(detectedBitsDecimal)





