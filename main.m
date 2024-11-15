%{
    Online Supplementary Materials of the paper titled:
        "Distributionally Robust Receive Beamforming"
    By
        Shixiong Wang, Wei Dai, and Geoffrey Ye Li
    From 
        Intelligent Transmission and Processing Laboratory, Imperial College London
    
    @Author: Shixiong Wang (s.wang@u.nus.edu; wsx.gugo@gmail.com)
    @Date  : 28 December 2023
    @Site  : https://github.com/Spratm-Asleaf/Beamforming
%}


rng(27);    % To guarantee my results are reproducible; just because I am 27 year old this year; no other reasons.

clear all;
clc;


%% Load Dependencies
%  Remember to install the YALMIP solver
addpath('[1] Utils\Channel\');
addpath('[1] Utils\Tools\');
addpath('[1] Utils\Tools\Random Variables\');
addpath('[1] Utils\YALMIP\');
addpath('[1] Utils\YALMIP\extras\');
addpath('[1] Utils\YALMIP\solvers\');
addpath('[1] Utils\YALMIP\modules\');
addpath('[1] Utils\YALMIP\modules\parametric\');
addpath('[1] Utils\YALMIP\modules\moment\');
addpath('[1] Utils\YALMIP\modules\global\');
addpath('[1] Utils\YALMIP\modules\sos\');
addpath('[1] Utils\YALMIP\operators\');

addpath('[2] Beamformers\');            % Implementation of beamformers
addpath('[2] Beamformers\Kernel\');     % Dependencies of the Kernel beamformer

%% Basic Settings
Scenario = 2;
switch Scenario
    case 1    % Gaussian Channel (see Appendix)
        BasicSettings_Scenario_1_ContinuousSignal;          % Continuous-valued transmitting signal
        % BasicSettings_Scenario_1_DiscreteSignal;            % Discrete-valued transmitting signal

    case 2    % Non-Gaussian Impulse-Noise Channel (see Main Body)
        BasicSettings_Scenario_2;

    otherwise
        error('main :: Error in Scenario :: Non-existing !');
end

Pilot_Size_Cnt = length(Pilot_Size);
Pilot_Size_Iter = 0;

% Check and warn potential issues in basic settings 
assert(length(isTestMe) == 11);
if N < M
    % NB: For M transmitted signals, at least M receiving signals are requried to recover the transmitted.
    warning('main :: Rx is smaller than Tx: Due to receiver diversity, this seems ill-conditioned. Transmitted signal may not be estimated!');
    disp('If you think that this is not an issue, press any key to proceed! But unexpected errors may occur!');
    pause;
end

%% Data Space
% Test Errors on Test Data
Test_error_Wiener          = zeros(Pilot_Size_Cnt, MC_RUN);  % For each pilot size, run Monte-Carlo (MC) episodes
Test_error_Wiener_DL       = zeros(Pilot_Size_Cnt, MC_RUN);
Test_error_Wiener_DR_F     = zeros(Pilot_Size_Cnt, MC_RUN);
% Test_error_Wiener_DR_W   = zeros(Pilot_Size_Cnt, MC_RUN);
Test_error_Wiener_CE       = zeros(Pilot_Size_Cnt, MC_RUN);
Test_error_Wiener_CE_DL    = zeros(Pilot_Size_Cnt, MC_RUN);
Test_error_Wiener_CE_DR    = zeros(Pilot_Size_Cnt, MC_RUN);
Test_error_Capon           = zeros(Pilot_Size_Cnt, MC_RUN);
Test_error_Capon_DL        = zeros(Pilot_Size_Cnt, MC_RUN);
Test_error_ZF              = zeros(Pilot_Size_Cnt, MC_RUN);
Test_error_Kernel          = zeros(Pilot_Size_Cnt, MC_RUN);
Test_error_Kernel_DL       = zeros(Pilot_Size_Cnt, MC_RUN);
% Training Times on Training (i.e., Pilot) Data
Train_Time_Wiener          = zeros(Pilot_Size_Cnt, MC_RUN);
Train_Time_Wiener_DL       = zeros(Pilot_Size_Cnt, MC_RUN);
Train_Time_Wiener_DR_F     = zeros(Pilot_Size_Cnt, MC_RUN);
% Train_Time_Wiener_DR_W   = zeros(Pilot_Size_Cnt, MC_RUN);
Train_Time_Wiener_CE       = zeros(Pilot_Size_Cnt, MC_RUN);
Train_Time_Wiener_CE_DL    = zeros(Pilot_Size_Cnt, MC_RUN);
Train_Time_Wiener_CE_DR    = zeros(Pilot_Size_Cnt, MC_RUN);
Train_Time_Capon           = zeros(Pilot_Size_Cnt, MC_RUN);
Train_Time_Capon_DL        = zeros(Pilot_Size_Cnt, MC_RUN);
Train_Time_ZF              = zeros(Pilot_Size_Cnt, MC_RUN);
Train_Time_Kernel          = zeros(Pilot_Size_Cnt, MC_RUN);
Train_Time_Kernel_DL       = zeros(Pilot_Size_Cnt, MC_RUN);

%% Monte-Carlo Loop
isChannelChangedOverEachMC = true;        % is channel state changed over each Monte-Carlo episode?
for Train_L = Pilot_Size
    disp(['Pilot Size: ' num2str(Train_L)]);
    Pilot_Size_Iter = Pilot_Size_Iter + 1;

    for mc = 1:MC_RUN
        disp(['    MC: ' num2str(mc)]);
        
        % True channel: we are using the frame-flat channel assumption
        if isChannelChangedOverEachMC || mc == 1
            % H = randn(N, M) + 1j*randn(N, M);  % This type of channel simulator is overly naive. But you can still use it if you want.
            H = GetChannelMatrix(N, M);          % Let's simulate channels using the multi-path propagation model
        end
        
        % Transmitting power covariance
        P = sqrt(Transmit_Power) * eye(M);       % GetPSDMat(M, 'Complex');     % It does not really matter whichever P you use: eye or GetPSDMat
        
        % Channel noise covariance
        Noise_Power = Transmit_Power/SNR;
        R = sqrt(Noise_Power)    * eye(N);       % GetPSDMat(M, 'Complex');     % It does not really matter whichever R you use: eye or GetPSDMat
        
        %% Beamforming (Training Stage)
        % Transmitted pilot
        Train_S = (chol(P))' * GetCommSymbols(Communication_Modulation_Mode, M, Train_L);
        
        % Channel noise
        Train_V = (chol(R))' * GetChannelNoise(N, Train_L, 'Gaussian');  %Channel_Noise_Mode, 'Gaussian'
        
        % Signal transmission (Frame-Flat Channel Assumption)
        Train_X = H*Train_S + Train_V;
        
        % Wiener Beamformer
        if isTestMe(1)
            tic;
            W_Wiener = Wiener(Train_X, Train_S, 0);
            Train_Time_Wiener(Pilot_Size_Iter, mc) = toc;
        end
        
        % Wiener Beamformer - Diagonal Loading
        if isTestMe(2) 
            epsilon = 0.1;  % NB: As a diagonal loading parameter, it cannot be overly large. Otherwise, the performance significantly reduces as Train_L gets larger.
            tic;
            W_Wiener_DL = Wiener(Train_X, Train_S, epsilon);
            Train_Time_Wiener_DL(Pilot_Size_Iter, mc) = toc;
        end
    
        % % Wiener Beamformer - Distributionally Robust (Wasserstein)
        % NB: I found that the F-norm-based method below is computationally more efficient
        % epsilon = 1;
        % tic;
        % W_WienerDR_W = WienerDR(Train_X, Train_S, 'W', epsilon);      % Choose 'W2' or 'W'
        % Train_Time_WienerDR_W(Pilot_Size_Iter, mc) = toc;
    
        % Wiener Beamformer - Distributionally Robust (F-Norm)
        if isTestMe(3)
            epsilon = 0.01;  % Cannot be overly large as well. Otherwise, the beamformer becomes overly conservative.
            tic;
            W_WienerDR_F = WienerDR(Train_X, Train_S, 'F2', epsilon);      % Choose 'F2' or 'F'
            Train_Time_Wiener_DR_F(Pilot_Size_Iter, mc) = toc;
        end
        
        % Channel Estimation (CE)
        if isExactSignalCov
            Rs = P; % This information is helpful
        else
            Rs  = Train_S*Train_S'/Train_L;                                       % Rs ~ P; NB: There exists estimation error in Transmitting Signal Covariance   
        end

        tic;
        H_hat = Train_X*Train_S'*(Train_S*Train_S')^(-1);                         % Least-square channel estimation
        time_CE = toc;

        if isExactNoiseCov
            Rv = R; % This information is helpful
        else
            Rv = (Train_X - H_hat*Train_S)*(Train_X - H_hat*Train_S)'/Train_L;    % Rv ~ R; NB: There exists estimation error in Channel Noise Covariance
        end
    
        % Channel-Estimation-Based Wiener Beamformer
        if isTestMe(4)
            tic;
            W_WienerCE = WienerCE(Rs, H_hat, Rv, 0);
            Train_Time_Wiener_CE(Pilot_Size_Iter, mc) = toc + time_CE;
        end
        
        % Channel-Estimation-Based Wiener Beamformer - Diagonal Loading
        if isTestMe(5)
            epsilon = 0.05;  % NB: As a diagonal loading parameter, it cannot be overly large. Otherwise, the performance significantly reduces as Train_L gets larger.
            tic;
            W_WienerCE_DL = WienerCE(Rs, H_hat, Rv, epsilon);
            Train_Time_Wiener_CE_DL(Pilot_Size_Iter, mc) = toc + time_CE;
        end
    
        % Channel-Estimation-Based Wiener Beamformer - Distributionally Robust
        if isTestMe(6)
            epsilon = 0.01;  % Cannot be overly large as well. Otherwise, the beamformer becomes overly conservative.
            tic;
            W_WienerCE_DR = WienerCE_DR(Rs, H_hat, Rv, 'GDL', epsilon);
            Train_Time_Wiener_CE_DR(Pilot_Size_Iter, mc) = toc + time_CE;
        end
    
        % Capon Beamformer
        if isTestMe(7)
            tic;
            W_Capon = Capon(Train_X, H_hat, 0);
            Train_Time_Capon(Pilot_Size_Iter, mc) = toc + time_CE;
        end
        
        % Capon Beamformer - Diagonal Loading
        if isTestMe(8)
            epsilon = 0.05;  % NB: As a diagonal loading parameter, it cannot be overly large. Otherwise, the performance significantly reduces as Train_L gets larger.
            tic;
            W_Capon_DL = Capon(Train_X, H_hat, epsilon);
            Train_Time_Capon_DL(Pilot_Size_Iter, mc) = toc + time_CE;
        end
        
        % Zero-Forcing
        if isTestMe(9)
            tic;
            W_ZF = ZF(H_hat);
            Train_Time_ZF(Pilot_Size_Iter, mc) = toc + time_CE;
        end
        
        % NB: Large pilot size L is not always good for kernel-based methods because large numerical errors may occur when calculating K^-1
        % NB: K's dimension is L by L
        % Kernel Receiver
        if isTestMe(10)
            epsilon = 0.001;  % In principle, this one should be zero; but for numerical stability in inversion of K, do not use zero
            tic;
            W_Ker_RE = Kernel(Train_X, Train_S, Kernel_Params, epsilon);
            Train_Time_Kernel(Pilot_Size_Iter, mc) = toc;
        end
        
        % Kernel Receiver - Diagonal Loading
        if isTestMe(11)
            epsilon = 0.05;  % NB: As a diagonal loading parameter, it cannot be overly large. Otherwise, the performance significantly reduces as Train_L gets larger.
            tic;
            W_Ker_RE_DL = Kernel(Train_X, Train_S, Kernel_Params, epsilon);
            Train_Time_Kernel_DL(Pilot_Size_Iter, mc) = toc;
        end
        
        %% Communication (Testing Stage)
        % Transmitted pilot
        Test_S = (chol(P))' * GetCommSymbols(Communication_Modulation_Mode, M, Test_L);
        
        % Channel noise
        Test_V = (chol(R))' * GetChannelNoise(N, Test_L, Channel_Noise_Mode);
        
        % Signal transmission
        if isTestChannelDifferentFromTraining
            H = H + 0.05*(rand(N, M) + 1j*rand(N, M));
        end
        Test_X = H*Test_S + Test_V;
    
        % Evaluation mode (MSE, SINR)
        EvaluationParams.mode = Performance_Evaluation_Mode;
        EvaluationParams.demod_mode = Communication_Modulation_Mode;
        EvaluationParams.channel_noise = Rv;
        
        % Beamforming and Signal Estimation
        % Wiener
        if isTestMe(1)
            Test_S_hat_Wiener = W_Wiener*Test_X;
            Test_error_Wiener(Pilot_Size_Iter, mc) = Performance(Test_S, Test_S_hat_Wiener, EvaluationParams);
        end
        
        if isTestMe(2)
            Test_S_hat_Wiener_DL = W_Wiener_DL*Test_X;
            Test_error_Wiener_DL(Pilot_Size_Iter, mc) = Performance(Test_S, Test_S_hat_Wiener_DL, EvaluationParams);
        end
    
        % Test_S_hat_WienerDR_W  = W_WienerDR_W*Test_X;
        % Test_error_WienerDR_W(Pilot_Size_Iter, mc) = Performance(Test_S, Test_S_hat_WienerDR_W, EvaluationParams);
    
        if isTestMe(3)
            Test_S_hat_WienerDR_F  = W_WienerDR_F*Test_X;
            Test_error_Wiener_DR_F(Pilot_Size_Iter, mc) = Performance(Test_S, Test_S_hat_WienerDR_F, EvaluationParams);
        end
        
        % Channel-Estimation-Based Wiener
        if isTestMe(4)
            Test_S_hat_WienerCE = W_WienerCE*Test_X;
            Test_error_Wiener_CE(Pilot_Size_Iter, mc) = Performance(Test_S, Test_S_hat_WienerCE, EvaluationParams);
        end
        
        if isTestMe(5)
            Test_S_hat_WienerCE_DL = W_WienerCE_DL*Test_X;
            Test_error_Wiener_CE_DL(Pilot_Size_Iter, mc) = Performance(Test_S, Test_S_hat_WienerCE_DL, EvaluationParams);
        end
    
        if isTestMe(6)
            Test_S_hat_WienerCE_DR = W_WienerCE_DR*Test_X;
            Test_error_Wiener_CE_DR(Pilot_Size_Iter, mc) = Performance(Test_S, Test_S_hat_WienerCE_DR, EvaluationParams);
        end
    
        % Capon
        if isTestMe(7)
            Test_S_hat_Capon = W_Capon*Test_X;
            Test_error_Capon(Pilot_Size_Iter, mc) = Performance(Test_S, Test_S_hat_Capon, EvaluationParams);
        end
        
        if isTestMe(8)
            Test_S_hat_Capon_DL = W_Capon_DL*Test_X;
            Test_error_Capon_DL(Pilot_Size_Iter, mc) = Performance(Test_S, Test_S_hat_Capon_DL, EvaluationParams);
        end
        
        % ZF
        if isTestMe(9)
            Test_S_hat_ZF = W_ZF*Test_X;
            Test_error_ZF(Pilot_Size_Iter, mc) = Performance(Test_S, Test_S_hat_ZF, EvaluationParams);
        end
        
        % Kernel
        % NB: Large pilot size L is not always good for kernel-based methods because large numerical errors may occur when calculating K^-1
        % NB: K's dimension is L by L
        if isTestMe(10)
            Test_S_hat_Ker = GetEstimatedSignalUsingKernel(W_Ker_RE, Test_X, Train_X, Kernel_Params);
            Test_error_Kernel(Pilot_Size_Iter, mc) = Performance(Test_S, Test_S_hat_Ker, EvaluationParams);
        end
        
        if isTestMe(11)
            Test_S_hat_Ker_DL = GetEstimatedSignalUsingKernel(W_Ker_RE_DL, Test_X, Train_X, Kernel_Params);
            %Test_S_hat_Ker_DL = Test_S_hat_Ker_DL - mean(Test_S_hat_Ker_DL);
            Test_error_Kernel_DL(Pilot_Size_Iter, mc) = Performance(Test_S, Test_S_hat_Ker_DL, EvaluationParams);
        end
    end
end

%% Visualization
if isPlot
    set(groot,'defaultfigureposition', [1000 500 450 350]);
    
    % PlotResults;

    switch Scenario
        case 1
            PlotResults_Scenario_1;     
            % PlotResults;              % If you want to plot all beamformers including nonlinear ones
        case 2
            % Generate Tables for Scenario 2, not plots
    end
end

%% Export Data
switch Scenario
    case 1
        % Generate plots for Scenario 1, not plots Tables
    case 2
        GenerateLatexTables_Scenario_2;
end


