%% Simulation Parameters
isHardware = 0;
dataTransferDuration = 100;
%% Receiver Parameters
fs = 10e6; % BasbitAverageEnergyand Sampling Rate (65105 to 61.44e6 Hz)
ts = 1/fs; % BasbitAverageEnergyand Sampling Time
nPacketSymbols = 10000; % Number of Symbol in Each Packet
rxReceiveMode = 'matched_filter';
% Receiver Detection Algorithm
equalizerMode = 0; % Compensate Mode (0: No Compensation, 1: Amplitude Compensation, 2: Phase Compensation, 3: Compensation)
%% Modulation Parameters
modulation = 'psk'; % Modulation Name ('psk', 'pam', 'qam', 'fsk')
k = 2; % Bit Per Symbol
M = 2^k; % Modulation Order
nSymbolSamples = 8; % Sample Per Symbol
Ts = nSymbolSamples*ts; % Symbol Time
isGray = 1; % Gray Code Usage Flag
detectionMode = 'coherent'; % Modulation Detection Option ('coherent', 'noncoherent')
% Pulse Shape Parameters
pulseName = 'triangular'; % Name of Pulse Shaping Function
beta = 0.99; % Parameter for RC, RRC and Gaussian Pulse Shape
spanInSymbol = 1; % Trunctation Length for RC, RRC and Gaussian Pulse Shape (Multiple of Symbol Time)
% Pulse Shaping Parameters
pulseShapingMode = 'conv';
% Header Option
isHeader = 0; % Flag For Having Packets with Header
% SNR Bound for BER Plots
snrMin = 10; % Minimum SNR (dB)
snrMax = 10; % Maximum SNR (dB)
snrStep = 0.5; % SNR Step (dB)
snrDb = snrMin:snrStep:snrMax; % SNR Vector (dB)
%% Channel Parameters
channelDelayInSample = round(0*nSymbolSamples); % Channel Delay in Sample
channelPhaseOffset = 30 * pi/180; % Channel Phase Offset
channelFrequencyOffset = 0; % Channel Frequency Offset
%% Hardware Parameters
% Transmitter Parameters
txFc = 2400e6; % Set Transmiter Center Frequency (AD9363: 325-3800MHz) (AD9364: 70-6000MHz)
txGain = 0; % Set Transmiter Attenutaion As a Negative Gain (-89.75 to 0 dB)
txAddress = 'usb:0'; % Set Transmiter Identification Number
% Receiver Parameters
rxFc = 2400e6; % Set Receiver Center Frequency (AD9363: 325-3800MHz) (AD9364: 70-6000MHz)
rxGain = 20; % Set Receiver Gain (-4dB to 71dB)
rxAddress = 'usb:0'; % Set Receiver Identification Number
% Initialize ADALM-PLUTO
if isHardware
    dev = sdrdev('Pluto'); % Create Radio Object for ADALM-PLUTO
    setupSession(dev)
    configurePlutoRadio('AD9364'); % Configure ADALM-PLUTO Radio Firmware
end