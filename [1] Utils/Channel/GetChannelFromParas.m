function [H0, Hc0] = GetChannelFromParas(Beta, Theta_t, Theta_r, Tau, Doppler, Nt, Nr, f, isExistLOS)
    if isExistLOS
        % Has no LOS path
        [K, Np] = size(Beta(:, 1:end-1));
        Hc0 = cell(K, Np + 1);       % K users, Np NLOS paths plus one LOS for each user 
        H0  = cell(K, 1);
        t = 0;
        for k = 1:K
            H0{k} = zeros(Nr, Nt);
            for ll = 1:Np+1
                Hc0{k, ll} = Beta(k, ll) * exp(1j*2*pi*Doppler(k, ll)*t) * exp(-1j*2*pi*Tau(k, ll)*f) * Steering(Nr, Theta_r(k, ll)) * (Steering(Nt, Theta_t(k, ll)))';
                H0{k} = H0{k} + Hc0{k, ll};
            end
        end
    else
        % No LOS path
        [K, Np] = size(Beta(:, 1:end));
        Hc0 = cell(K, Np);
        H0  = cell(K, 1);
        t = 0;
        for k = 1:K
            H0{k} = zeros(Nr, Nt);
            for ll = 1:Np
                Hc0{k, ll} = Beta(k, ll) * exp(1j*2*pi*Doppler(k, ll)*t) * exp(-1j*2*pi*Tau(k, ll)*f) * Steering(Nr, Theta_r(k, ll)) * (Steering(Nt, Theta_t(k, ll)))';
                H0{k} = H0{k} + Hc0{k, ll};
            end
        end
    end
end

