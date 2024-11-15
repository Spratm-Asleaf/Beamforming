function mat = RemoveMatNaN(mat)
% Remove NaN values in a Mattrix, replacing them with wor-medians

    row_len = size(mat, 1);

    % Replace NaN values with median for each row
    for i = 1:row_len
        row = mat(i, :);
        median_value = median(row);
        nan_indices = isnan(row);
        row(nan_indices) = median_value;
        mat(i, :) = row;
    end
end

