%% Basic Settings of Scenario 1
% Continuous-Valued Transmitting Signal

M = 4;              % Number of transmiting antenna        
N = 16;             % Number of receiving antenna (for fixed M, the larger N, the better due to receiver diversity or data diversity)
Train_L = 10;       % Default Pilot length; training data
Test_L  = 500;      % Data length; test data (NB: a frame is composed of [Pilot, Data])
Transmit_Power = 1; % Watt (this is not a sensitive parameter, no need to tune; only SNR matters)
SNR = 0.1;          % 0.1 (-10dB), 1 (0dB), 10 (10dB), 100 (20dB), 316 (25dB), 1000 (30dB)

Communication_Modulation_Mode   = 'Gaussian';   % 'QPSK', 'QAM' (i.e., QAM64), 'Gaussian'
Channel_Noise_Mode              = 'Gaussian';   % 'Gaussian', 'Laplacian', 'T' (i.e., Student T), 'Epsilon-Gaussian', 'Epsilon-Uniform'
Performance_Evaluation_Mode     = 'MSE';        % 'MSE', 'SER'

isExactSignalCov = 0;                    % is signal covariance "P" known a priori? or is it estimated using data?
isExactNoiseCov = 0;                     % is channel noise covariance "R" known a priori? or is it estimated using data? This is beneficial to Wiener-CE

Pilot_Size = 10:2:80;                    % Pilot Size Used for Training Beamformers

isPlot = true;                           % to plot visual figures?

Kernel_Params.mode  = 'Gaussian';        % Gaussian kernel
Kernel_Params.scale = 0.005;             % Scale of kernel

isTestChannelDifferentFromTraining = false;     % is the channel at the test stage different from the one at the training stage?

%% Which Beamforming Method to Train and Test for This Scenario?
isTestMe = [
    1       % 1).  Wiener
    0       % 2).  Wiener-DL
    0       % 3).  Wiener-DR
    1       % 4).  Wiener-CE
    0       % 5).  Wiener-CE-DL
    0       % 6).  Wiener-CE-DR
    1       % 7).  Capon
    0       % 8).  Capon-DL
    1       % 9).  ZF
    1       % 10). Kernel
    0       % 11). Kernel-DL
];

%% Number of Monte-Carlo (MC) episodes in each simulation
MC_RUN = 250;                   
