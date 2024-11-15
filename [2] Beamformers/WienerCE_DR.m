function W = WienerCE_DR(P, H, R, mode, eps)
% Channel-Esitmation-Based Wiener Beamformer
% eps: radius of distributional ball

    [M, ~] = size(P);
    [N, ~] = size(R);

    mode = upper(mode);
    F = [];
    switch mode
        case 'GDL'   % Generalized Diagonal Loading; see Examples 5 and 6
            W = (P + eps*eye(M))*H'*(H*P*H' + R + eps*(H*H'))^(-1);

        case 'F-P'
            V  = sdpvar(M, M, 'hermitian', 'complex');
            U  = sdpvar(M, M, 'hermitian', 'complex');
            F = [F, trace(U) <= eps^2];
            F = [F, [U, (V - P)'; (V - P), eye(M)] >= 0];
            F = [F, U >= 0, V >= 0];

            option = sdpsettings('verbose', false);
            optimize(F, -trace(V), option);

            P = double(V);

            W = P*H'*(H*P*H' + R)^(-1);

        case 'F-R'
            V  = sdpvar(N, N, 'hermitian', 'complex');
            U  = sdpvar(N, N, 'hermitian', 'complex');
            F = [F, trace(U) <= eps^2];
            F = [F, [U, (V - R)'; (V - R), eye(N)] >= 0];
            F = [F, U >= 0, V >= 0];

            option = sdpsettings('verbose', false);
            optimize(F, -trace(V), option);

            R = double(V);
            
            W = P*H'*(H*P*H' + R)^(-1);

        otherwise
            error('WienerCE_DR_F :: Error in Mode :: Non-existing !');
    end
end

