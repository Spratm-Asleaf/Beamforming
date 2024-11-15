function W = Wiener(Train_X, Train_S, eps_DL)
% Wiener Beamformer
% eps_DL: epsilon coefficient of Diagonal Loading

    [N, Train_L] = size(Train_X);
    Rx  = Train_X*Train_X'/Train_L;
    Rxs = Train_X*Train_S'/Train_L;
    W = Rxs'*(Rx + eps_DL*eye(N))^(-1);
end

