function [Theta_t, Theta_r, Tau, Doppler] = GetDLChannelParasFromGeometry(Station, Scatters, Users, C, isExistLOS)
    [~, K]  = size(Users);
    [~, Np] = size(Scatters);

    if isExistLOS
        % Exist LOS path
        Theta_t = zeros(K, Np + 1);    % Transmit angle of departure
        Theta_r = zeros(K, Np + 1);    % Receive  angle of arrival
        Tau     = zeros(K, Np + 1);    % Time delay
        Doppler = zeros(K, Np + 1);    % Doppler shift
    
        %% Basic Channel Parameters when Users and Scatters are static
        for k = 1:K
            % The last column coresponds to the light-of-sight path
            Theta_r(k, :) = [GetAzimuth(Scatters, Users(:, k))                                  GetAzimuth(Station, Users(:, k))];
            Theta_t(k, :) = [GetAzimuth(Scatters, Station)                                      GetAzimuth(Users(:, k), Station)];
            Tau(k, :)     = [GetTau(Scatters, Users(:, k), C) + GetTau(Scatters, Station, C)    GetTau(Users(:, k), Station, C)];
        end
    else    
        % Does not exist LOS path
        Theta_t = zeros(K, Np);    % Transmit angle of departure
        Theta_r = zeros(K, Np);    % Receive  angle of arrival
        Tau     = zeros(K, Np);    % Time delay
        Doppler = zeros(K, Np);    % Doppler shift
    
        for k = 1:K
            Theta_r(k, :) = GetAzimuth(Scatters, Users(:, k));
            Theta_t(k, :) = GetAzimuth(Scatters, Station);
            Tau(k, :)     = GetTau(Scatters, Users(:, k), C) + GetTau(Scatters, Station, C);
        end
    end

    %% Doppler when Users and Scatters are moving
    % Scatters_v: velocity of scatters;
    % Users_v:  velocity of users;
end

