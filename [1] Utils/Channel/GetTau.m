function Tau = GetTau(Points, RefPoint, C)
    [D1, D2] = size(RefPoint);
    [D3, K] = size(Points);
    assert(D1 == 2 && D2 == 1 && D3 == 2);
    
    Tau = zeros(1, K);
    for k = 1:K
        Tau(k) = norm(Points(:, k) - RefPoint)/C;
    end
end

