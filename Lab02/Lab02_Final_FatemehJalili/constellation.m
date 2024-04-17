function [cons, symbolEnergy] = constellation(M, modulationName)
switch modulationName
    case 'pam'
        cons = (-(M-1) : 2 :(M-1))';
        cons = cons / sqrt(abs(cons'*cons) / M);
        symbolEnergy = abs(cons'*cons) / M;
end
end