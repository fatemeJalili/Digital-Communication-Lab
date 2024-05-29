function [detectedSymbolsIndex, rxSymbols] = pulseDemodulation(rxSamples, modulation,...
    M, fs, nSymbolSamples, pulseName , rxMode, varargin)
    switch modulation
        case 'fsk'
            m = (0 : M-1)';
            t = (0: 1/fs :(nSymbolSamples-1)/fs);
            S = exp(1j * 2 * pi * (fs/(2*nSymbolSamples)) * m * t);
            S = S ./ sqrt(sum(abs(S).^2, 2));
            C = real(reshape(rxSamples, [], nSymbolSamples)*S');
            [~, detectedSymbolsIndex] = max(C, [], 2);
            detectedSymbolsIndex = detectedSymbolsIndex-1;
            rxSymbols = [];
        otherwise
            p = pulseShape(pulseName, fs, nSymbolSamples);
            rxSymbols = symbolDetection(rxSamples, p, nSymbolSamples, rxMode);
            [cons, ~] = constellation(M, modulation);
            detectedSymbolsIndex = minDistanceDetector(rxSymbols, cons)-1;
    end
end