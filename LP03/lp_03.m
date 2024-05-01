clc, clear, close all;
%% Section 1
% Part 1
sdrdev('Pluto');

% Part 2
myPluto = findPlutoRadio;

% Part 3
%% Parameters
fs = 10e6; % Baseband Sampling Rate (65105 to 61.44e6 Hz)
samplesPerFrame = 4096; % Samples per Each Frame (< 2^20)
dataTransferDuration = 60;
% Transmitter Parameters
txFc = 325e6; % Set Transmitter Center Frequency
% (AD9363: 325-3800MHz) (AD9364: 70-6000MHz)
txGain = -30; % Set Transmitter Attenuation as a Negative Gain
% (-89.75 to 0 dB)
txAddress = 'usb:0'; % Set Transmitter Identification Number
% Receiver Parameters
rxFc = 325e6; % Set Receiver Center Frequency
% (AD9363: 325-3800MHz) (AD9364: 70-6000MHz)
rxGain = 20; % Set Receiver Gain (-4dB to 71dB)
rxAddress = 'usb:0'; % Set Receiver Identification Number
% Initialize ADALM-PLUTO
plutoObject = sdrdev('Pluto'); % Create Radio Object for ADALM-PLUTO
% setupSession(plutoObject)
% configurePlutoRadio('AD9363'); % Configure ADALM-PLUTO Radio Firmware
% Define Transmitter Object
tx = sdrtx('Pluto','RadioID',txAddress); % CreateTransmitterSystem Object
tx.CenterFrequency = txFc; % Set Transmitter Center Frequency
tx.Gain = txGain; % Set Transmitter Gain
tx.BasebandSampleRate = fs; % Set Baseband Sampling Rate
% Define Receiver Object
rx = sdrrx('Pluto','RadioID',rxAddress); % Create Receiver System Object
rx.CenterFrequency = rxFc; % Set Receiver Center Frequency
rx.BasebandSampleRate = fs; % Set Baseband Sampling Rate
rx.SamplesPerFrame = samplesPerFrame; % Samples per Each Frame (< 2^20)
rx.GainSource = 'Manual'; % AGC Settings
rx.Gain = rxGain; % Receiver Gain
rx.OutputDataType = 'double'; % Output Data Type

%% Part 4
% Transmit Repeat
offsetFrequency = 1e6;
signalDuration = 1;
nSamples = signalDuration*fs;
timeVector = (0:nSamples - 1)'/fs;
sineWaveSamples = exp(2j*pi*offsetFrequency*timeVector);
tx.transmitRepeat(sineWaveSamples);

% Part 5
t0 = tic;
subplot(2, 1, 1)
y1 = zeros(samplesPerFrame, 1);
ln1 = plot(y1);
ln1.YDataSource = 'y1';
subplot(2, 1, 2)
f2 = (-2048:2047)/samplesPerFrame*fs;
y2 = zeros(samplesPerFrame, 1) - inf;
ln2 = plot(f2, y2);
ln2.YDataSource = 'y2';

while toc(t0) < dataTransferDuration
   plutoData = blackmanharris(samplesPerFrame, 'periodic') .* rx();
   plutoDataFft = 20*log10(abs(fftshift(fft(plutoData))) / length(plutoData)) + 30;
   y1 = real(plutoData);
   y2 = max(y2, plutoDataFft);
   refreshdata
   drawnow
end

release(tx);
%% Section 2
fs = 250e3; % Baseband Sampling Rate (65105 to 61.44e6 Hz)
samplesPerFrame = 65536; % Samples per Each Frame (< 2^20)
dataTransferDuration = 60;
% Transmitter Parameters
txFc = 800e6; % Set Transmitter Center Frequency
% (AD9363: 325-3800MHz) (AD9364: 70-6000MHz)
txGain = -30; % Set Transmitter Attenuation as a Negative Gain
% (-89.75 to 0 dB)
txAddress = 'usb:0'; % Set Transmitter Identification Number
% Receiver Parameters
rxFc = 433.9e6 + 102100 +105.1789; % Set Receiver Center Frequency
% (AD9363: 325-3800MHz) (AD9364: 70-6000MHz)
rxGain = 45; % Set Receiver Gain (-4dB to 71dB)
rxAddress = 'usb:0'; % Set Receiver Identification Number
% Initialize ADALM-PLUTO
plutoObject = sdrdev('Pluto'); % Create Radio Object for ADALM-PLUTO
% setupSession(plutoObject)
% configurePlutoRadio('AD9363'); % Configure ADALM-PLUTO Radio Firmware
% Define Transmitter Object
% Define Receiver Object
rx = sdrrx('Pluto','RadioID',rxAddress); % Create Receiver System Object
rx.CenterFrequency = rxFc; % Set Receiver Center Frequency
rx.BasebandSampleRate = fs; % Set Baseband Sampling Rate
rx.SamplesPerFrame = samplesPerFrame; % Samples per Each Frame (< 2^20)
rx.GainSource = 'Manual'; % AGC Settings
rx.Gain = rxGain; % Receiver Gain
rx.OutputDataType = 'double'; % Output Data Type
 
t0 = tic;
subplot(2, 1, 1)
y1 = zeros(samplesPerFrame, 1);
ln1 = plot(y1);
ln1.YDataSource = 'y1';
ylim([-0.2, 0.2]);
subplot(2, 1, 2)
f2 = (-32768:32767)/samplesPerFrame*fs;
y2 = zeros(samplesPerFrame, 1) - inf;
ln2 = plot(f2, y2);
ln2.YDataSource = 'y2';

while toc(t0) < dataTransferDuration
   plutoData = rx();
   plutoDataFft = 20*log10(abs(fftshift(fft(plutoData))) / length(plutoData)) + 30;
   y1 = real(plutoData);
   y2 = max(y2, plutoDataFft);
   refreshdata
   drawnow
   if(max(y1)>0.02)
    break;
   end
end

