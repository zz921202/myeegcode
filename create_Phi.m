function Phi=create_Phi(m, n, k)
    % m number of rows
    % n number of columns
    % k number of binary "1" insicde each column

    Phi = zeros(m,n);
    for j = 1: n
        index = datasample(1:m, k, 'Replace', false);
        Phi(index, j) = 1;
    end
