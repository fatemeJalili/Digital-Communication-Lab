function [detectedSymbols] = minDistanceDetector(rxSymbols, constellation)
    [Rx, Cons] = meshgrid(rxSymbols, constellation);
    diff2 = (Cons-Rx).^2;
    [~, detectedSymbols] = min(diff2, [], 1);
    detectedSymbols = detectedSymbols.';
end