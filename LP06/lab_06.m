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

%% Hardware
tx = sdrtx('Pluto','RadioID',txAddress); % CreateTransmitterSystem Object
tx.CenterFrequency = txFc; % Set Transmitter Center Frequency
tx.Gain = txGain; % Set Transmitter Gain
tx.BasebandSampleRate = fs; % Set Baseband Sampling Rate
% Define Receiver Object
rx = sdrrx('Pluto','RadioID',rxAddress); % Create Receiver System Object
rx.CenterFrequency = rxFc; % Set Receiver Center Frequency
rx.BasebandSampleRate = fs; % Set Baseband Sampling Rate
rx.SamplesPerFrame = 2 * nPacketSymbols * nSymbolSamples; % Samples per Each Frame (< 2^20)
rx.GainSource = 'Manual'; % AGC Settings
rx.Gain = rxGain; % Receiver Gain
rx.OutputDataType = 'double'; % Output Data Type
rx.ShowAdvancedProperties = true;
rx.EnableBasebandDCCorrection = false;

tx.transmitRepeat(txSamples);
pause(1);

%% Section 3-3
t0 = tic;
rxSamples = rx();
x = zeros(length(rxSamples), 1);
y = zeros(length(rxSamples), 1);
ln = scatter(x, y);
xlim([-1.5, 1.5])
ylim([-1.5, 1.5])
ln.XDataSource = 'x';
ln.YDataSource = 'y';
theta = 0:0.01:2*pi;
r = 1;
hold on
plot(r.*cos(theta), r.*sin(theta), '--')

while toc(t0) < dataTransferDuration
    
    rxSamples = rx();

    [corr, lags] = xcorr(rxSamples, headerSamples);
    corr = corr(lags>=0);
    lags = lags(lags>=0);
    corr = corr(1 : length(corr)/2);
%     lags = lags(1 : floor(length(lags) / 2));
    [~, startIndx] = max(abs(corr));
    rxSamples = rxSamples(startIndx : startIndx + nPacketSymbols * nSymbolSamples - 1);
    val1 = corr(startIndx);
    val2 = headerSamples'*headerSamples;
    switch equalizerMode
        case 0
            alpha = 1;
            theta = 0;
        case 1
            alpha = abs(val2/val1);
            theta = 0;
        case 2
            alpha = 1;
            theta = -angle(val1);
        case 3
            alpha = abs(val2/val1);
            theta = -angle(val1);
    end
    rxSamples = alpha * rxSamples * exp(1j * theta);

    [detectedSymbolsIndex, rxSymbols] = pulseDemodulation(rxSamples, modulation, M, fs, nSymbolSamples, pulseName , rxReceiveMode);

    if(isGray==1)
        detectedBits = matrix(detectedSymbolsIndex+1, :);
    else
        detectedBits = de2bi(detectedSymbolsIndex, k, 'left-msb');
    end
    x = abs(rxSymbols(:, 1));
    y = abs(rxSymbols(:, 2));
    refreshdata
    drawnow
end