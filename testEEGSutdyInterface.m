c = EEGStudyInterface();
c.import_data()

% set_window_params(obj, window_length, stride, window_generator)
c.set_window_params(2, 1, 'EEGWindowInterface')
disp('finishing extracting all windows')
% c.plot_pca()
disp('start to compute kmeans')
c.k_means(20)