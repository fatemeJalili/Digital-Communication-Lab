function [rxSymbols] = symbolDetection(rxSamples, p, nSymbolSamples, rxMode)

    switch rxMode
        case 'correlator'
            [r, lags] = xcorr(rxSamples, p);
            r = r(lags>=0);
            lags = lags(lags>=0);
            rxSymbols = r(mod(lags, nSymbolSamples) == 0);

        case 'matched_filter'
            p_prime = p(end:-1:1)';
            r = conv(rxSamples, p_prime);
            r = r(length(p):end);
            rxSymbols = r(1:nSymbolSamples:length(r));
    end
end