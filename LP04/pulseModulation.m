function [txSamples, cons] = pulseModulation(symbolIndex,...
    modulation, M, fs, nSymbolSamples, pulseName , pulseShapingMode, varargin)
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
