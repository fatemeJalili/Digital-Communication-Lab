function [grayMatrix] = grayMatrixGenerator(k)
    grayMatrix = [0; 1];
    for indx = 1:k-1
        grayMatrix = [cat(2, zeros(2^indx, 1), grayMatrix); cat(2, ones(2^indx, 1), flip(grayMatrix))];
    end
end
