function Test_S_hat_Ker = GetEstimatedSignalUsingKernel(W_Ker_RE, Test_X, Train_X, params)
% Recover transmitted symbols using kernel method

    Test_X_RE  = [real(Test_X); imag(Test_X)];
    Train_X_RE = [real(Train_X); imag(Train_X)];

    [M_Double, ~] = size(W_Ker_RE);
    M = M_Double/2;

    [~, Test_L]   = size(Test_X);
    
    Test_S_hat_Ker = zeros(2*M, Test_L);
    for i = 1:Test_L
        Test_S_hat_Ker(:, i) = W_Ker_RE * varphi(Test_X_RE(:, i), Train_X_RE, params);
    end

    Gamma_M = [eye(M) eye(M)*1j];   % From real-space representation to complex-space; see Section I-B (Notations)
    Test_S_hat_Ker = Gamma_M*Test_S_hat_Ker;
end

