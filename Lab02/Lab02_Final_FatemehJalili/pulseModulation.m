function [txSamples, cons] = pulseModulation(symbolIndex,...
    modulation, M, fs, nSymbolSamples, pulseName , pulseShapingMode, varargin)
    [cons, ~] = constellation(M, modulation);
    symbolArray = zeros(size(symbolIndex));
    for indx = 1 : size(symbolIndex, 1)
        symbolArray(indx, 1) = cons(symbolIndex(indx, 1));
    end
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
