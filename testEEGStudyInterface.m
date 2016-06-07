% c = EEGStudyInterface();
% c.import_data()

cc = EEGStudyEmotiv();
cc.import_data('/Users/Zhe/Documents/seizure/myeegcode/processed_data/Vidya_june_6_Data/faster_1630.set', 'faster_1630')

%% band power experiments
% set_window_params(obj, window_length, stride, window_generator)
% EEG band power distribution, distinctive separation between on-seizure and seizure 
% seizure states, parameters chosen to achieve very good separation

% TODO: compare with other interictal, preictal and postictal states

% cc.set_window_params(2, 0.5, 'EEGWindowBandPower')
% disp('finishing extracting all windows')
% % cc.plot_pca()
% disp('start to compute kmeans')

% % cc.k_means(6)
% % cc.EEGData.raw_electrodes()
% cc.plot_temporal_evolution();

%% comp sensing feature extraction

% I would not bet on it cause feature extraction is very time consuming, Moreover, 
% it is still a one-channel method, thus greatly limiting the prospective for finding 
% cross channel information 

% now just to make the feature work,  I am not pushing for performance, and I am not expecting great performance


cc.set_window_params(2, 2, 'EEGWindowCompSensing')
% disp('finishing extracting all windows')
% c.plot_pca()
% disp('start to compute kmeans')
% c.k_means(10)
cc.plot_temporal_evolution()

%% gardern's energy implementation

% c.set_window_params(2, 1, 'EEGWindowGardnerEnergy')
% disp('finishing extracting all windows')
% c.plot_pca()
% disp('start to compute kmeans')
% c.k_means(10)




% dd = EEGStudyEmotiv();
% %% Juarez Data
% dd.import_data('/Users/Zhe/Documents/seizure/myeegcode/processed_data/Juarez_Data/faster_short.set', 'faster_short.set')

% % band power experiments
% % set_window_params(obj, window_length, stride, window_generator)
% % EEG band power distribution, distinctive separation between on-seizure and seizure 
% % seizure states, parameters chosen to achieve very good separation

% % TODO: compare with other interictal, preictal and postictal states

% dd.set_window_params(2, 0.5, 'EEGWindowBandPower')
% disp('finishing extracting all windows')
% % dd.plot_pca()
% disp('start to compute kmeans')

% dd.k_means(6)
% cc.EEGData.raw_electrodes()