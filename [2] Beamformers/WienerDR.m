function W = WienerDR(Train_X, Train_S, mode, eps)
% Distributionally Robsut Wiener Beamformer
% mode: F (F-Norm), W (Wasserstein)
% eps: radius of distributional ball

    [N, Train_L] = size(Train_X);
    Rx_hat  = Train_X*Train_X'/Train_L;
    Rxs = Train_X*Train_S'/Train_L;

    [~, M] = size(Rxs);

    % Hermitian complex matrices
    Rx = sdpvar(N, N, 'hermitian', 'complex');      
    V  = sdpvar(M, M, 'hermitian', 'complex');
    U  = sdpvar(N, N, 'hermitian', 'complex');

    mode = upper(mode);
    F = [];
    switch mode
        case 'F'
            % F-Norm Quantification
            F = [F, [V, Rxs'; Rxs, Rx] >= 0];
            F = [F, trace(U) <= eps^2];
            F = [F, [U, (Rx - Rx_hat)'; (Rx - Rx_hat), eye(N)] >= 0];
            F = [F, V >= 0, U >= 0, Rx >= 0];

            option = sdpsettings('verbose', false);
            optimize(F, -(trace(-V + Rx)), option);

        case 'F2'   % Because "trace(Rs - Rxs' * Rx^-1 * Rxs)" is increasing in "Rx". Why not find the "largest" "Rx"?
            % F-Norm Quantification
            F = [F, trace(U) <= eps^2];
            F = [F, [U, (Rx - Rx_hat)'; (Rx - Rx_hat), eye(N)] >= 0];
            F = [F, U >= 0, Rx >= 0];

            option = sdpsettings('verbose', false);
            optimize(F, -trace(Rx), option);
        
        case 'W'
            % Wasserstein Quantification
            F = [F, [V, Rxs'; Rxs, Rx] >= 0];
            F = [F, trace(Rx + Rx_hat - 2*U) <= eps^2];
            F = [F, [Rx, (sqrtm(Rx_hat))^-1*U; U*(sqrtm(Rx_hat))^-1, eye(N)] >= 0];
            F = [F, V >= 0, U >= 0, Rx >= 0];

            option = sdpsettings('verbose', false);
            optimize(F, -(trace(-V + Rx)), option);

        case 'W2'   % Because "trace(Rs - Rxs' * Rx^-1 * Rxs)" is increasing in "Rx". Why not find the "largest" "Rx"?
            % Wasserstein Quantification
            F = [F, trace(Rx + Rx_hat - 2*U) <= eps^2];
            F = [F, [Rx, (sqrtm(Rx_hat))^-1*U; U*(sqrtm(Rx_hat))^-1, eye(N)] >= 0];     % because "sqrtm(Rx_hat)" is positive definite
            F = [F, U >= 0, Rx >= 0];

            option = sdpsettings('verbose', false);
            optimize(F, -trace(Rx), option);

        otherwise
            error('WienerDR :: Error in Mode :: Non-existing !');
    end

    W = Rxs'*double(Rx)^(-1);
end

