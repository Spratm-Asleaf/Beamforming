function W = Capon(Train_X, H, eps_DL)
% Capon Beamformer, which knows the (estimated) channel state information
% eps_DL: epsilon coefficient of Diagonal Loading
    [N, Train_L] = size(Train_X);
    Rx  = Train_X*Train_X'/Train_L;
    
    W = (H'*(Rx + eps_DL*eye(N))^(-1)*H)^(-1)*H'*(Rx + eps_DL*eye(N))^(-1);
end

