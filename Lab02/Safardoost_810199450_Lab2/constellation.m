function [cons, symbolEnergy] = constellation(M, modulationName)
    switch modulationName
        case 'pam'
            cons = -(M-1):2:(M-1);
        case 'psk'
        case 'qam'
    end
    cons = cons/sqrt((cons*cons')/M);
    symbolEnergy = (cons*cons')/M;
end

