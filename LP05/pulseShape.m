function PS = pulseShape(pulseName, fs, nSymbolSamples)
    t = transpose(0: 1/fs :(nSymbolSamples-1)/fs);
    Ts = nSymbolSamples/fs;
    switch pulseName
        case 'triangular'
            PS = max((Ts/2)-abs(t-(Ts/2)), 0);
            PS = PS / sqrt(sum(abs(PS).^2));    
    end
end

