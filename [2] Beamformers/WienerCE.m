function W = WienerCE(P, H, R, eps_DL)
% Channel-Esitmation-Based Wiener Beamformer
% eps_DL: epsilon coefficient of Diagonal Loading

    [N, ~] = size(R);
    W = P*H'*(H*P*H' + R + eps_DL*eye(N))^(-1);
end

