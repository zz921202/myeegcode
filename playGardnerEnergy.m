cc = EEGStudyEmotiv();
cc.import_data('/Users/Zhe/Documents/seizure/myeegcode/processed_data/Vidya_june_6_Data/faster_1630.set', 'faster_1630')
cc.set_window_params(1, 0.5, 'EEGWindowGardnerEnergy')
disp('finishing extracting all windows')
%cc.plot_pca()
disp('start to compute kmeans')
cc.k_means(3)

dd = EEGStudyEmotiv();
% %% Juarez Data
dd.import_data('/Users/Zhe/Documents/seizure/myeegcode/processed_data/Juarez_Data/faster_short.set', 'faster_short.set')
dd.set_window_params(1, 0.5, 'EEGWindowGardnerEnergy')
disp('finishing extracting all windows')
%dd.plot_pca()
disp('start to compute kmeans')

dd.k_means(3)