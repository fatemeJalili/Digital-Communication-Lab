function [txBit] = bitGenerator(nPacketSymbols, k)
    txBit = randi([0 1],nPacketSymbols,k);              
end