function W = Kernel(Train_X, Train_S, params, eps_DL)
% Kernel Beamformer
% params: specifications of the kernel such as the kernel type and its scale parameter
% eps_DL: epsilon coefficient of Kernel Diagonal Loading

    [~, Train_L] = size(Train_X);

    Train_S_RE = [real(Train_S); imag(Train_S)];       % real-space representation
    Train_X_RE = [real(Train_X); imag(Train_X)];       % real-space representation
    
    K = zeros(Train_L, Train_L);    % kernel matrix (See Proposition 3)
    for i = 1:Train_L
        for j = 1:Train_L
            K(i, j) = ker(Train_X_RE(:, i), Train_X_RE(:, j), params);
        end
    end

    W = Train_S_RE*(K + eps_DL*eye(Train_L))^-1;   % equal to (S*K)*(K*K)^-1 = S*K^-1; note that Rz = K*K/L, Rzs = K*S'/L;
end

