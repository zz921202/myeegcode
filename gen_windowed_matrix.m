% obj = MyEEG()
% obj.pop_load_set()
% begin_time, end_time, window_length, step_size)
obj.normalize_channels();
[ica, mytitle, data_mat] = obj.raw_data_chunks();

% function for normalize a vector 
data_mat = row_mean_std_normalization(data_mat);
result = arrayfun(@(idx) norm(data_mat(idx,:)), 1:size(data_mat,1));

figure()
k = 20;
[idx, C] = kmeans(data_mat, k) ;

subplot(131)
plot(data_mat')
title('data distribution')

subplot(132)
plot(C')
title('kmeans vectors')

subplot(133)
hist(idx)
plot(idx)
title('group disribution')


obj.plot_pca(C, sprintf('%d kmeans', k))

for i = 0:1:(k/5-1)
    
    figure()
    for j = 1:5
        curidx = 5 * i + j;
        subplot(1, 5, j)
        plot(C(curidx, :)')
        title(sprintf('%d th compoenent',curidx))
    end
end