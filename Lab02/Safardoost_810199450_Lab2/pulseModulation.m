function [txSamples, cons] = pulseModulation(symbolIndex, modulation, M, fs, nSymbolSamples, pulseName , pulseShapingMode, varargin)
    [cons, ~] = constellation(M, modulation);
    symbolArray(:, 1) = cons(symbolIndex+1);
    
    p = pulseCreator(pulseName, nSymbolSamples);
    
    switch pulseShapingMode
        case 'kron'
            txSamples = kron(symbolArray, p);
        case 'conv'
            symbolArrayZeroPad = upsample(symbolArray, nSymbolSamples);
            symbolArrayZeroPad = symbolArrayZeroPad(1:end-nSymbolSamples+1);
            txSamples = conv(symbolArrayZeroPad, p);
    end
end

