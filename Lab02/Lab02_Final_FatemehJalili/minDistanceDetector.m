function [detectedSymbols] = minDistanceDetector(rxSymbols, constellation)
compare1 = rxSymbols == transpose(constellation);
detectedSymbolsValue = compare1 * constellation;
compare2 = detectedSymbolsValue == transpose(constellation);
[~,detectedSymbols] = max(compare2, [], 2);
end