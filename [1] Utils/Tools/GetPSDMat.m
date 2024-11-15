function mat = GetPSDMat(N, mode)
% Randamly Generate Positive Semi-Definite (PSD) Matrix
% mode: real PSD or complex PSD

    mode = upper(mode);
    switch mode
        case 'REAL'
            dat = rand(N, N);
            mat = zeros(N, N);

            %%{{ % The below is just one of the possibilities to generate a real PSD matrix.
                 % Please try other methods if you want.
                params.mode  = 'Gaussian';      % Gaussian kernel
                params.scale = 1;               % scale of kernel
                for i = 1:N
                    for j = 1:N
                        mat(i, j) = ker(dat(:, i), dat(:, j), params);
                    end
                end
            %%}}

        case 'COMPLEX'
            mat = rand(N, N) + 1j*rand(N, N);
            mat = mat'*mat;
            mat = mat + 5*eye(N);
            coeff = max(max(abs(mat)));     % Maximum absolute value is unity
            mat = mat/coeff;
            for i = 1:N
                mat(i, i) = 1;
            end

        otherwise
            error('GetPSDMat :: Error in Mode :: Non-existing !');
    end
end

