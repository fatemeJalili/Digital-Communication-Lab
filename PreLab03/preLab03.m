clc, clear, close all;
%% Question 3-1-2
N = 8;
Wn = exp(-1j*2*pi/N).^((0:N-1).'*(0:N-1));
fs = 100e6;

for k = [1, 2, 6]
    b = Wn(k, end:-1:1);
    a = 1;
    [H, f] = freqz(b, a, 128^2, 'whole', fs);
    f = f - 50e6;
    H = fftshift(H);
    plot(f, 20*log10(abs(H)));
    xlabel('frequency(Hz)')
    ylabel('Magnitude(dB)')
    hold on;
end
legend('k=1', 'k=2', 'k=6');
hold off;

%% Question 3-1-3
figure;
fs = 250e6;
A = 2;
n_psd = 512;
n_fft = 512;
n = 0:n_fft-1;
indx = 1;
for f0 = [250*51.5/256, 250*51/256]*1e6
    x = A*exp(1j*n*2*pi*f0/fs);
    subplot(2, 1, indx);
    X1 = 10*log10(abs(fftshift(fft(x))).^2)+30;
    f1 = ((-n_fft/2):(n_fft/2-1))*fs/n_fft;
    plot(f1, X1);
    hold on;
    X2 = 10*log10(abs(fftshift(corr_spctrm(x, n_psd))))+30;
    f2 = ((-n_psd/2):(n_psd/2-1))*fs/n_psd;
    plot(f2, X2);
    indx = indx+1;
    title(['f0=', num2str(f0)]);
    xlabel('frequency(Hz)')
    ylabel('Magnitude(dBm)')
    legend('fft', 'xcor')
end

%% Question 3-2-2
figure;
phi = -pi:pi/10:pi;
alpha = 0:0.05:1;
[Alpha, Phi] = meshgrid(alpha, phi);
R = abs((1-exp(1j*Phi).*(1+Alpha))./(1+exp(-1j*Phi).*(1+Alpha)));
surf(Alpha, Phi, 20*log10(R));
xlabel('alpha')
ylabel('phi')
zlabel('Ratio(dB)')