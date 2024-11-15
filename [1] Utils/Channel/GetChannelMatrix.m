function H0 = GetChannelMatrix(N, M, isExistLOS)
% Simulate (N, M)-Channel State Information with multi-path propagation
% isExistLOS (bool) : Does exist Light-Of-Sight path?
    
    %% Default value is true: There eixst LOS pathes
    if nargin < 3
        isExistLOS = true;      
    end

    %% Constants
    C = 299792458;      % Speed of light
    
    %% Geometry Configuration
    Users = [         %% Location of the receiving entity. It can have more than one user (columns). This paper consider only one user (i.e., point-to-point MIMO transmission).
        500   % 350   %%--- X1  X2  X3 ...
        450   % 368   %%--- Y1  Y2  Y3 ...
    ];
    
    Station = [     % Lcoation of Base Station (transmitting entity)
        0
        0
    ];

    Nt = M;     % Number of transmit antenna
    Nr = N;     % Number of receive antenna
    
    %% Channel Model
    f = 20e9;      % Carrier frequency; 20G
    Np = 25;       % Number of scattering paths
    Scatters = rand(2, Np) * 400;      % Scatters are within the square of 400*400

    % Channel Parameters---True channel parameters are labelled with "0"
    if isExistLOS
        Beta0 = ones(1, Np + 1) * 0.5*exp(-1j*0.1);   % Complex Channel Gain (Attenuation: 0.5, Phase Delay: 0.1)
    else
        Beta0 = ones(1, Np)     * 0.5*exp(-1j*0.1);
    end

    % Theta0_t: Angle of Departure (transmitter)
    % Theta0_r: Angle of Arrival (receiver)
    % Tau0    : Path Propagation Delay
    % Doppler0: (Doppler Frequency Shift) If Scatters and Users Are Moving, Doppler effect exists
    [Theta0_t, Theta0_r, Tau0, Doppler0] = GetDLChannelParasFromGeometry(Station, Scatters, Users, C, isExistLOS);

    % The k'th element in the cell "H0" denotes the channel of the k'th user, if more than one user exist.
    [H0, ~] = GetChannelFromParas(Beta0, Theta0_t, Theta0_r, Tau0, Doppler0, Nt, Nr, f, isExistLOS);

    %% This paper considers only one user (i.e., point-to-point MIMO transmission).
    % For multi-user scenarios, comment out the following statement.
    H0 = H0{1};     
end

