function [txSamples, cons] = pulseModulation(symbolIndex,...
    modulation, M, fs, nSymbolSamples, pulseName , pulseShapingMode, varargin)
    switch modulation
        case 'fsk'
            m = (0 : M-1)';
            t = (0: 1/fs :(nSymbolSamples-1)/fs);
            S = exp(1j * 2 * pi * (fs / (2*nSymbolSamples)) * m * t);
            S = S ./ sqrt(sum(abs(S).^2, 2));
            
            txSamples = S(symbolIndex+1, :).';
            txSamples = txSamples(:);
            cons = [];
        otherwise
            [cons, ~] = constellation(M, modulation);
            symbolArray = zeros(size(symbolIndex));
            symbolArray(:, 1) = cons(symbolIndex+1);

            PS = pulseShape(pulseName, fs, nSymbolSamples);
            switch pulseShapingMode
                case 'kron'
                    txSamples = kron(symbolArray, PS);
                case 'conv'
                    symbolArrayZeroPad = upsample(symbolArray, nSymbolSamples);
                    symbolArrayZeroPad = symbolArrayZeroPad(1 : end-(nSymbolSamples-1), 1);
                    txSamples = conv(symbolArrayZeroPad, PS);
            end
    end
end
