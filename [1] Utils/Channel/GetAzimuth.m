function Azi = GetAzimuth(Points, RefPoint)
    [D1, D2] = size(RefPoint);
    [D3, D4] = size(Points);
    assert(D1 == 2 && D2 == 1 && D3 == 2);

    Azi = atan2((Points(2,:) - RefPoint(2)), (Points(1,:) - RefPoint(1)));

    % for i = 1:D4
    %     if isnan(Azi(i))
    %         Azi(i) = (2*rand-1)*pi/2;
    %     end
    % end

    % return;
    if max(isnan(Azi))
        error('GetAzimuth :: Error in Position Configuration :: Singular');
    end
end

