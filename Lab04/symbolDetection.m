function [rxSymbols] = symbolDetection(rxSamples, p, nSymbolSamples, rxMode)
rxSymbols = zeros(length(rxSamples) / nSymbolSamples, 1);
switch rxMode
    case 'correlator'
        for indx = 1 : length(rxSymbols)
            samples = rxSamples(((indx - 1) * nSymbolSamples) + 1 : indx * nSymbolSamples);
            rxSymbols(indx) = sum(p .* conj(samples));
        end
    case 'matched_filter'
        for indx = 1 : length(rxSymbols)
            samples = rxSamples((indx - 1) * nSymbolSamples + 1 : indx * nSymbolSamples);
            rxSymbols(indx) = conv(flip(conj(p)), samples, 'valid');
        end
end
end

