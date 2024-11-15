clf;
hold on;

if sum(isTestMe) ~= 5
    warning('PlotResults_Scenario_1 :: Settings of Scenario 1 Changed !');
    disp('If you think that this is OK, press any key to proceed...');
    pause;
end

% Capon
if isTestMe(7)
    plot(Pilot_Size, nanmean(Test_error_Capon, 2), 'g', 'linewidth', 2);
end

% Kernel
if isTestMe(10)
    plot(Pilot_Size, nanmean(Test_error_Kernel, 2), 'color', [0.30,0.75,0.93], 'linewidth', 2);
end

% Wiener
if isTestMe(1)
    plot(Pilot_Size, nanmean(Test_error_Wiener, 2), 'r', 'linewidth', 2);
end

% Channel-Estimation-Based Wiener
if isTestMe(4)
    plot(Pilot_Size, nanmean(Test_error_Wiener_CE, 2), 'b--', 'linewidth', 2.5);
end

% ZF
if isTestMe(9)
    plot(Pilot_Size, nanmean(Test_error_ZF, 2), 'm', 'linewidth', 2);
end


legend_label = {'Capon', 'Kernel', 'Wiener', 'Wiener-CE', 'ZF'};
legend(legend_label);

xlabel('Pilot Size');
ylabel(Performance_Evaluation_Mode);
set(gca, 'fontsize', 16);
box on;

if strcmp(Performance_Evaluation_Mode, 'SER')
    axis([Pilot_Size(1), Pilot_Size(end), -0.05 0.8]);
elseif strcmp(Performance_Evaluation_Mode, 'MSE')
    axis([10, 80, 0 1]);
end