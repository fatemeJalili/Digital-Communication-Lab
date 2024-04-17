function [cons, symbolEnergy] = constellation(M, modulationName)
    switch modulationName
        case 'pam'
            cons = -(M-1):2:(M-1);
        case 'psk'
            k = 0:(M-1);
            cons = exp(1j*2*pi.*k/M);
        case 'qam'
    end
    cons = (cons/sqrt((cons*cons')/M));
    symbolEnergy = (cons*cons')/M;
end

