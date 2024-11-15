%% Basic Settings of Scenario 2
% The transmission signal model undergoes the impulse channel noises

%{
Note: The idea is to use normal Gaussian (i.e., non-impulsed) noisy pilot data to train beamformers; 
          that is, the outliers in the pilot data have been censored and removed (e.g., manually).
      Therefore, the beamformers are expected to have the ability to identify and suppress the outliers in the
          non-pilot communication data.
      In this sense, linear beamformers have no such ability, but nonlinear ones have.
          * This is the benefit of overfitting: in training stage, no outliers are present; so nonlinear beanformers
            believe that there are also NO outliers in testing stage.
%}

M = 4;              % Number of transmiting antenna        
N = 8;             % Number of receiving antenna (for fixed M, the larger N, the better due to receiver diversity or data diversity)
Train_L = 10;       % Default Pilot length; training data
Test_L  = 500;      % Data length; test data (NB: a frame is composed of [Pilot, Data])
Transmit_Power = 1; % Watt (this is not a sensitive parameter, no need to tune; only SNR matters)
SNR = 0.1;          % 0.1 (-10dB), 1 (0dB), 10 (10dB), 100 (20dB), 316 (25dB), 1000 (30dB)

Communication_Modulation_Mode   = 'Gaussian';       % 'QPSK', 'QAM' (i.e., QAM64), 'Gaussian'
Channel_Noise_Mode              = 'Epsilon-Gaussian';   % 'Gaussian', 'Laplacian', 'T' (i.e., Student T), 'Epsilon-Gaussian', 'Epsilon-Uniform'
Performance_Evaluation_Mode     = 'MSE';        % 'MSE', 'SER'

isExactSignalCov = 0;                    % is signal covariance "P" known a priori? or is it estimated using data?
isExactNoiseCov = 0;                     % is channel noise covariance "R" known a priori? or is it estimated using data? This is beneficial to Wiener-CE

Pilot_Size = 50;                   % Pilot Size Used for Training Beamformers
isPlot = true;                     % to plot visual figures?

% NB: Need to tune for different situations
Kernel_Params.mode  = 'Gaussian';         % Gaussian kernel
Kernel_Params.scale = 0.0001;             % Scale of kernel; Typical good values:  0.0005, 0.0001

isTestChannelDifferentFromTraining = false;     % is the channel at the test stage different from the one at the training stage?

%% Which Beamforming Method to Train and Test for This Scenario?
isTestMe = [
    1       % 1).  Wiener
    1       % 2).  Wiener-DL
    1       % 3).  Wiener-DR
    1       % 4).  Wiener-CE
    1       % 5).  Wiener-CE-DL
    1       % 6).  Wiener-CE-DR
    1       % 7).  Capon
    1       % 8).  Capon-DL
    1       % 9).  ZF
    1       % 10). Kernel
    1       % 11). Kernel-DL
];

%% Number of Monte-Carlo (MC) episodes in each simulation
MC_RUN = 100;     % No much differences in performances if use 250; to save running times, I use 100 here.              
