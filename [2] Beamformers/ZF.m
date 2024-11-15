function W = ZF(H)
% Zero-Forcing Beamformer
    
    W = (H'*H)^(-1)*H';
end

