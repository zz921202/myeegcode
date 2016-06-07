%% comp sensing feature extraction

% I would not bet on it cause feature extraction is very time consuming, Moreover, 
% it is still a one-channel method, thus greatly limiting the prospective for finding 
% cross channel information 

% now just to make the feature work,  I am not pushing for performance, and I am not expecting great performance
eegcode_path = pwd;
cc = EEGStudyEmotiv();
cc.import_data([eegcode_path,'/processed_data/Vidya_june_6_Data/faster_1630.set'], 'faster_1630')

cc.set_window_params(2, 1, 'EEGWindowCompSensing')
% disp('finishing extracting all windows')
% c.plot_pca()
% disp('start to compute kmeans')
% c.k_means(10)
cc.plot_temporal_evolution()
ylim([0,1])



dd = EEGStudyEmotiv();
dd.import_data([eegcode_path,'/processed_data/Juarez_Data/faster_short.set'], 'faster_short.set')

%% shortened Juarez data
% set_window_params(obj, window_length, stride, window_generator)
% EEG band power distribution, distinctive separation between on-seizure and seizure 
% seizure states, parameters chosen to achieve very good separation

% TODO: compare with other interictal, preictal and postictal states
dd.set_window_params(2, 1, 'EEGWindowCompSensing')

% dd.set_window_params(2, 0.5, 'EEGWindowBandPower')
% disp('finishing extracting all windows')
% dd.plot_pca()
% disp('start to compute kmeans')
% dd.k_means(3)
dd.plot_temporal_evolution()
ylim([0,1])