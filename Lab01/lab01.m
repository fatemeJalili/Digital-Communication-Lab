clc, clear, close all;
load Num.mat
%% Section 3-1
rng(1)
% Part a
fprintf('Part a:\n')
fs = 28.8e6;
freq = (0:4095)/4096*fs - fs/2;
xi = sqrt(1/2)*randn(4096, 1);
xq = sqrt(1/2)*randn(4096, 1);
x = xi + 1j*xq;
y = conv(x, Num, 'same');
X = fftshift(fft(x)/length(x));
Y = fftshift(fft(y)/length(y)); 

figure
subplot(2, 1, 1)
plot(freq/1e6, db(abs(X), 100) + 30)
ylabel('X(dbm)')
xlabel('freq(MHz)')
fprintf('Power of x: %f\n', x'*x/length(x));
subplot(2, 1, 2)
plot(freq/1e6, db(abs(Y), 100) + 30)
ylabel('Y(dbm)')
xlabel('freq(MHz)')
fprintf('Power of y: %f\n', y'*y/length(y));
fprintf('Noise equivalent bandwidth: %d\n', noisebw(Num, 1, 4096, fs));

% Part b
fprintf('\nPart b:\n')
fc = 3.57e6;
t = reshape((0 : 4095) / fs, 4096, 1);
z = real(y) .* cos(2*pi * fc * t) - imag(y) .* sin(2*pi * fc * t); 
Z = fftshift(fft(z)/length(z));

figure
subplot(3, 1, 1)
plot(freq/1e6, db(abs(X), 100) + 30)
ylabel('X(dbm)')
xlabel('freq(MHz)')
title('White Noise Signal')
fprintf('Power of x: %f\n', x'*x/length(x));
subplot(3, 1, 2)
plot(freq/1e6, db(abs(Y), 100) + 30)
ylabel('Y(dbm)')
xlabel('freq(MHz)')
title('Base Band Signal')
fprintf('Power of y: %f\n', y'*y/length(y));
subplot(3, 1, 3)
plot(freq/1e6, db(abs(Z), 100) + 30)
ylabel('Z(dbm)')
xlabel('freq(MHz)')
title('Intermediate Band Signal')
fprintf('Power of z: %f\n', z'*z/length(z));

% Part c
fprintf('\nPart c:\n')
figure
Wn = [0.7, 1.4, 2.8]*1e6*2/fs;
for indx = 1 : 3
    filter = fir1(120, Wn(indx));
    wi = conv(z.*(2*cos(2*pi*fc*t)), filter, 'same');
    wq = conv(z.*(-2*sin(2*pi*fc*t)), filter, 'same');
    w = wi + 1j*wq;
    W = fftshift(fft(w)/length(w)); 
    subplot(4, 1, indx)
    plot(freq/1e6, db(abs(W), 100) + 30)
    ylabel('W(dbm)')
    xlabel('freq(MHz)')
    fprintf('Power of w: %f\n', w'*w/length(w));
end
subplot(4, 1, 4)
plot(freq/1e6, db(abs(Y), 100) + 30)
ylabel('Y(dbm)')
xlabel('freq(MHz)')
fprintf('Power of y: %f\n', y'*y/length(y));