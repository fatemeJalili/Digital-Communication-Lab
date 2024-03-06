clc, clear, close all;
%% Section 1-1
figure

% Part a
subplot(3, 1, 1)
x = randn(1000, 1)*10 + 10;
histogram(x, 100, 'Normalization', 'pdf');

% Part b
subplot(3, 1, 2)
x2 = rand(100001, 1);
x3 = x2(1:100000, 1) + x2(2:100001, 1);
histogram(x3, 100, 'Normalization', 'pdf');

% Part c
subplot(3, 1, 3)
x4 = sum(rand(100000, 4), 2);
histogram(x4, 100, 'Normalization', 'pdf');


%% Section 2-1

% Part a
figure

subplot(2, 1, 1)
n0 = 0:100;
y1 = zeros(104, 1);
x = zeros(104, 1);
x(4) = 1;
for n=(0:100)+4
    y1(n) = 0.5*y1(n-1) - 0.25*y1(n-2) + x(n) + 2*x(n-1) + x(n-3);
end
stem(n0, y1(4:end));
title('Calculated by us.')

subplot(2, 1, 2)
b = [1 2 0 1];
a = [1 -0.5 0.25];
y2 = filter(b, a, x(4:end));
stem(n0, y2);
title('Calculated by filter function.')

% Part b
figure
n0 = 0:200;
x = zeros(204, 1);
y = zeros(104, 1);
x(4:end) = 5 + 3*cos(0.2*pi*n0) + 4*sin(0.6*pi*n0);
for n=(0:200)+4
    y(n) = 0.5*y(n-1) - 0.25*y(n-2) + x(n) + 2*x(n-1) + x(n-3);
end
stem(n0, y(4:end));

%% Section 2-2
load('packets_and_header.mat');
corrOutput = corrModified(rx_smpl, hdr_smpl);
fs = 1e7;
t = (0:length(rx_smpl)-length(hdr_smpl))/fs;
figure;
plot(abs(corrOutput))
title('Absolute Corr')

c = 3*1e8;
distance = c * (100 / fs);
packet_time = 8000 / fs;
num_symbol = 8000/8;

figure;
subplot(2, 2, 1)
plot(real(rx_smpl))
title('rx_smpl real part');

subplot(2, 2, 2)
plot(imag(rx_smpl))
title('rx_smpl imaginary part');

subplot(2, 2, 3)
plot(real(hdr_smpl))
title('hdr_smpl real part');

subplot(2, 2, 4)
plot(imag(hdr_smpl))
title('hdr_smpl imaginary part');

%% Section 3-1
clc, clear, close all;

% Part a - g
fs = 250e6;
ts = 1/fs;
nFft = [256, 256, 512, 512, 512];
A = [2, 2, 2, 2, 4];
f0 = 250/256*1e6 * [51, 51.5, 51, -51, 153];
figure
for indx = 1 : 5
    t = (0:nFft(indx) - 1)*ts;
    freq = (0:nFft(indx) - 1)/nFft(indx)*fs - fs/2;
    x = A(indx)*exp(1j * 2*pi * f0(indx) * t);
    Xf = fftshift(fft(x, nFft(indx)));
    alpha = 1 / nFft(indx)^2;
    subplot(5, 1, indx)
    plot(freq, alpha * abs(Xf).^2)
    xlim([freq(1),freq(end)])
    Fans = sprintf('F Part answer : %f',nFft(indx) * f0(indx) * ts);
    title(Fans)
end

% Part h
f0 = f0 + fs./nFft;
figure
for indx = 1 : 5
    t = (0:nFft(indx) - 1)*ts;
    freq = (0:nFft(indx) - 1)/nFft(indx)*fs - fs/2;
    x = A(indx)*exp(1j * 2*pi * f0(indx) * t);
    Xf = fftshift(fft(x, nFft(indx)));
    alpha = 1 / nFft(indx)^2;
    subplot(5, 1, indx)
    plot(freq, alpha * abs(Xf).^2)
    xlim([freq(1),freq(end)])
    Fans = sprintf('F Part answer : %f',nFft(indx) * f0(indx) * ts);
    title(Fans)
end

% Part i
fs = 250e6;
ts = 1/fs;
nFft = [256, 256, 512, 512, 512];
A = [2, 2, 2, 2, 4];
f0 = 250/256*1e6 * [51, 51.5, 51, -51, 153];
for indx = 1 : 5
    t = (0:nFft(indx) - 1)*ts;
    freq = (0:nFft(indx) - 1)/nFft(indx)*fs - fs/2;
    x = A(indx)*exp(1j * 2*pi * f0(indx) * t);
    Xf = fftshift(fft(x, nFft(indx)));
    powerTime = sum(abs(x).^2)/ (nFft(indx));
    powerFreq = sum(Xf*Xf')/ (nFft(indx)^2);
    fprintf('Power in time domain: %f , Power in frequency domain: %f\n', powerTime, powerFreq);
end

% Part j
fs = 250e6;
ts = 1/fs;
nFft = [256, 256];
A = [2, 2];
f0 = 250/256*1e6 * [51, 51.5];
figure
for indx = 1 : 2
    t = (0:nFft(indx) - 1)*ts;
    freq = (0:nFft(indx) - 1)/nFft(indx)*fs - fs/2;
    x = A(indx)*exp(1j * 2*pi * f0(indx) * t);
    Xf = fftshift(fft(x, nFft(indx)));
    alpha = 1 / nFft(indx);
    subplot(2, 1, indx)
    Y = db(alpha * abs(Xf), 100) + 30;
    plot(freq, Y)
    xlim([freq(1),freq(end)])
    Fans = sprintf('F Part answer : %f',nFft(indx) * f0(indx) * ts);
    title(Fans)
end
