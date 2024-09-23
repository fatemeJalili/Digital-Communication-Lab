function [detectedSymbolsIndex, rxSymbols] = pulseDemodulation(rxSamples, modulation, detectionMode,...
    M, fs, nSymbolSamples, pulseName , rxMode, varargin)
    switch modulation
        case 'fsk'
            if detectionMode == 'noncoherent'
                m = (0 : M-1)';
                t = (0: 1/fs :(nSymbolSamples-1)/fs);
                S = exp(1j * 2 * pi * (fs/(nSymbolSamples)) * m * t);
                S = S ./ sqrt(sum(abs(S).^2, 2));
                C = abs(reshape(rxSamples, nSymbolSamples, []).'*S');
                [~, detectedSymbolsIndex] = max(C, [], 2);
                detectedSymbolsIndex = detectedSymbolsIndex-1;
            rxSymbols = C;
            else
                m = (0 : M-1)';
                t = (0: 1/fs :(nSymbolSamples-1)/fs);
                S = exp(1j * 2 * pi * (fs/(2*nSymbolSamples)) * m * t);
                S = S ./ sqrt(sum(abs(S).^2, 2));
                C = real(reshape(rxSamples, nSymbolSamples, []).'*S');
                [~, detectedSymbolsIndex] = max(C, [], 2);
                detectedSymbolsIndex = detectedSymbolsIndex-1;
                rxSymbols = C;
            end
        otherwise
            p = pulseShape(pulseName, fs, nSymbolSamples);
            rxSymbols = symbolDetection(rxSamples, p, nSymbolSamples, rxMode);
            [cons, ~] = constellation(M, modulation);
            detectedSymbolsIndex = minDistanceDetector(rxSymbols, cons)-1;
    end
end