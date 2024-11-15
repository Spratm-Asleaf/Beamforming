function Symbols = GetCommSymbols(mode, rows, cols)
    % Get transmitted signals, the average power of which is unity, that is, Symbols*Symbols'/cols = eye(rows)
    mode = upper(mode);
    switch mode
        case 'QPSK'
            Q = 4;
            data    = randi([0 Q-1], rows, cols);    % Binary data
            Symbols = pskmod(data, Q, pi/Q);         % QPSK symbols

        case 'QAM'
            No      = 64;                            % Number of points in a QAM constellation, typical values are 16, 64
            data    = randi([0 No-1], rows, cols);   % Generate random QAM symbols
            Symbols = qammod(data, No, 'UnitAveragePower', true);              % Modulate the symbols to QAM signal

        case 'GAUSSIAN'
            Symbols = (sqrt(2)/2) * (randn(rows, cols) + 1j*randn(rows, cols));

        otherwise
            error('GetCommuSymbols :: Error in Modulation Mode :: Non-existing !');
    end
end