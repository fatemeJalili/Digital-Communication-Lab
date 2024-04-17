function [detectedSymbolsIndex, rxSymbols] = pulseDemodulation(rxSamples, modulation, M, fs, nSymbolSamples, pulseName , rxMode, varargin)
    [cons, ~] = constellation(M, modulation);
    
    p = pulseCreator(pulseName, nSymbolSamples);

    rxSymbols = symbolDetection(rxSamples, p, nSymbolSamples, rxMode);

    detectedSymbolsIndex = minDistanceDetector(rxSymbols, cons);
end