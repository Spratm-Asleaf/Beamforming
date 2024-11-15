function ret = varphi(x, X, params)
% @func: feature vector of "x", with bases being "columns of X"
%
% @note: varphi(x, X) is a function of the argument "x". By definition in Section II-A (RKHS), 
%        varphi(x, X) := [ker(x, x_1); ker(x, x_2); ..., ker(x, x_L)],
%            where X  := [x_1, x_2, ..., x_L]

    [N, L] = size(X);
    assert(N==length(x));
    ret = zeros(L, 1);

    for i = 1:L
        ret(i) = ker(x, X(:, i), params);
    end
end

