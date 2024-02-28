function [corrOutput] = corrModified(x, y)
    L1 = length(x);
    L2 = length(y);
    L = (L1-L2)+1;
    corrOutput = zeros(L, 1);
    for n = 1:L
       corrOutput(n) = y' * x(n:L2+n-1);
    end
end

