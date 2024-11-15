clf;
hold on;

legend_label = cell(length(isTestMe), 1);

% Wiener
if isTestMe(1)
    plot(Pilot_Size, nanmean(Test_error_Wiener, 2), 'r', 'linewidth', 2);
    legend_label{1} = 'Wiener';
end

if isTestMe(2)
    plot(Pilot_Size, nanmean(Test_error_Wiener_DL, 2), 'linewidth', 2);
    legend_label{2} = 'Wiener-DL';
end

% Test_S_hat_WienerDR_W  = W_WienerDR_W*Test_X;
% Test_error_WienerDR_W(Pilot_Size_Iter, mc) = Performance(Test_S, Test_S_hat_WienerDR_W, EvaluationParams);

if isTestMe(3)
    plot(Pilot_Size, nanmean(Test_error_Wiener_DR_F, 2), 'linewidth', 2);
    legend_label{3} = 'Wiener-DR';
end

% Channel-Estimation-Based Wiener
if isTestMe(4)
    plot(Pilot_Size, nanmean(Test_error_Wiener_CE, 2), '--', 'linewidth', 2);
    legend_label{4} = 'Wiener-CE';
end

if isTestMe(5)
    plot(Pilot_Size, nanmean(Test_error_Wiener_CE_DL, 2), 'linewidth', 2);
    legend_label{5} = 'Wiener-CE-DL';
end

if isTestMe(6)
    plot(Pilot_Size, nanmean(Test_error_Wiener_CE_DR, 2), 'linewidth', 2);
    legend_label{6} = 'Wiener-CE-DR';
end

% Capon
if isTestMe(7)
    plot(Pilot_Size, nanmean(Test_error_Capon, 2), 'linewidth', 2);
    legend_label{7} = 'Capon';
end

if isTestMe(8)
    plot(Pilot_Size, nanmean(Test_error_Capon_DL, 2), 'linewidth', 2);
    legend_label{8} = 'Capon-DL';
end

% ZF
if isTestMe(9)
    plot(Pilot_Size, nanmean(Test_error_ZF, 2), 'linewidth', 2);
    legend_label{9} = 'ZF';
end

% Kernel
if isTestMe(10)
    plot(Pilot_Size, nanmean(Test_error_Kernel, 2), 'linewidth', 2);
    legend_label{10} = 'Kernel';
end

if isTestMe(11)
    plot(Pilot_Size, nanmean(Test_error_Kernel_DL, 2), 'linewidth', 2);
    legend_label{11} = 'Kernel-DL';
end

legend_label = legend_label(~cellfun('isempty',legend_label)); 
legend(legend_label);

xlabel('Pilot Size');
ylabel(Performance_Evaluation_Mode);
set(gca, 'fontsize', 16);
box on;

if strcmp(Performance_Evaluation_Mode, 'SER')
    % axis([Pilot_Size(1), Pilot_Size(end), -0.05 0.8]);
elseif strcmp(Performance_Evaluation_Mode, 'MSE')
    % axis([10, 80, 13 45]);
end