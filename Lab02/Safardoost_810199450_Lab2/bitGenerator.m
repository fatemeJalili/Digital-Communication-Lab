function txBit = bitGenerator(nPacketSamples, k)
    txBit = randi([0 1], [nPacketSamples, k]);
end

