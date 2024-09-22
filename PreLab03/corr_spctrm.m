function [X] = corr_spctrm(x, n_psd)
    [Rx, n] = xcorr(x);
    Wn = exp(-1j*2*pi/n_psd).^((0:n_psd-1).'*n);
    X = Wn*(Rx.');
end