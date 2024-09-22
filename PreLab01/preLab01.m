clc, clear, close all;

%% Part 3-1
fs = 1;
nSymbolSamples = 8;

% Raised-Cosine
figure
i = 0;
for beta = [0.1, 0.2, 0.5, 0.9, 1]
    spanInSymbols = 6;
    [p, t] = pulseShape('raisedCosine', fs, nSymbolSamples, beta, spanInSymbols);
    subplot(5, 2, 2*i+1);
    plot(t, p);
    hold on
    stem(t, p, 'Color', 'r');
    title(['Time Domain, beta = ', num2str(beta)]);
    subplot(5, 2, 2*i+2);
    f = -fs/2 : fs/256 : fs/2-fs/256;
    plot(f, abs(fftshift(fft(p, 256)))/256);
    hold on;
    xline(fs/(2*nSymbolSamples), 'Color', 'r');
    xline(-fs/(2*nSymbolSamples), 'Color', 'r');
    title(['Frequency Domain, beta = ', num2str(beta)]);
    i = i+1;
end
sgtitle('Raised Cosine')

% Root-Raised-Cosine
figure
i = 0;
for beta = [0.1, 0.2, 0.5, 0.9, 1]
    spanInSymbols = 6;
    [p, t] = pulseShape('rootRaisedCosine', fs, nSymbolSamples, beta, spanInSymbols);
    subplot(5, 2, 2*i+1);
    plot(t, p);
    hold on
    stem(t, p, 'Color', 'r');
    title(['Time Domain, beta = ', num2str(beta)]);
    subplot(5, 2, 2*i+2);
    f = -fs/2 : fs/256 : fs/2-fs/256;
    plot(f, abs(fftshift(fft(p, 256)))/256);
    hold on;
    xline(fs/(2*nSymbolSamples), 'Color', 'r');
    xline(-fs/(2*nSymbolSamples), 'Color', 'r');
    title(['Frequency Domain, beta = ', num2str(beta)]);
    i = i+1;
end
sgtitle('Root Raised Cosine')

% Gaussian
figure
i = 0;
for beta = [0.1, 0.3, 0.5]
    spanInSymbols = 6;
    [p, t] = pulseShape('gaussian', fs, nSymbolSamples, beta, spanInSymbols);
    subplot(3, 2, 2*i+1);
    plot(t, p);
    hold on
    stem(t, p, 'Color', 'r');
    title(['Time Domain, beta = ', num2str(beta), ', beta*T = ', num2str(beta*(nSymbolSamples/fs))]);
    subplot(3, 2, 2*i+2);
    f = -fs/2 : fs/256 : fs/2-fs/256;
    plot(f, abs(fftshift(fft(p, 256)))/256);
    hold on;
    title(['Frequency Domain, beta = ', num2str(beta), ', beta*T = ', num2str(beta*(nSymbolSamples/fs))]);
    i = i+1;
end
sgtitle('Gaussian')

%% Part 3-2

% Part 3-2-1
PeDerivedPSK = @(M, EbNo) 2*qfunc(sqrt(2*log2(M)*sin(pi/M)^2*(10.^(EbNo/10))))/log2(M);

% Part 3-2-2
figure
EbNo = 0:0.1:10;
colors = get(groot,'defaultAxesColorOrder');
i = 1;
for M = [4, 8, 16]
    ber = PeDerivedPSK(M, EbNo);
    semilogy(EbNo, ber, 'Color', colors(i, :));
    hold on;
    i = i+1;
end

% Part 3-2-3
i = 1;
for M = [4, 8, 16]
    ber = berawgn(EbNo,'psk',M,'nondiff');
    semilogy(EbNo, ber, 'Color', colors(i, :), 'LineStyle', '--');
    hold on;
    i = i+1;
end

legend('4PSK-Derived', '8PSK-Derived', '16PSK-Derived', '4PSK-berawgn', '8PSK-berawgn', '16PSK-berawgn');
title('Bit Error Rate')


%% Part 3-3

figure
ASigma = 4;
T = 1;
alpha = 0.1:0.05:1;
phi = 0:pi/10:2*pi;
[Alpha, Phi] = meshgrid(alpha, phi);
ser = qfunc(Alpha.*cos(Phi)*sqrt(T)*ASigma);
surf(Alpha, Phi, ser);
colormap summer
set(gca, 'ZScale', 'log');
xlabel('Alpha');
ylabel('Phi');
title('Symbol Error Rate')