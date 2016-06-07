function result = row_mean_std_normalization(A)
%row majored aplication

%TODO chaned scaling to min max for visual inspection
normalize_vec = @(x) (x - mean(x))/ (std(x));
result = zeros(size(A));
for row_num = 1: size(A, 1)
    result(row_num, :) = normalize_vec(A(row_num, :));
end
