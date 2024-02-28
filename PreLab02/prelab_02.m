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
fs = ...;
ts = 1/fs;
nFft = ...;
t = [0:nFft - 1]*ts;
freq = [0:nFft - 1]/nFft*fs - fs/2;
x = ...;
Xf = fftshift(fft(x, nFft));
plot(freq, abs(Xf).^2)
xlim([freq(1),freq(end)])