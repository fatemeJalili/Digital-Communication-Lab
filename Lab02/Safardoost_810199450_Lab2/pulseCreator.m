function [p] = pulseCreator(pulseName, nSymbolSamples)
    t = (0:nSymbolSamples-1);
    switch pulseName
        case 'triangular'
                p = (max(nSymbolSamples/2 - abs(t - nSymbolSamples/2), 0)/nSymbolSamples)';
    end
    p = p./(norm(p));
end