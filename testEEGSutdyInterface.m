c = EEGStudyInterface();
c.import_data()

%% band power experiments
% set_window_params(obj, window_length, stride, window_generator)
% EEG band power distribution, distinctive separation between on-seizure and seizure 
% seizure states, parameters chosen to achieve very good separation

% TODO: compare with other interictal, preictal and postictal states

% c.set_window_params(8, 0.5, 'EEGWindowBandPower')
% disp('finishing extracting all windows')
% c.plot_pca()
% disp('start to compute kmeans')
% c.k_means(10)

%% comp sensing feature extraction

% I would not bet on it cause feature extraction is very time consuming, Moreover, 
% it is still a one-channel method, thus greatly limiting the prospective for finding 
% cross channel information 

% now just to make the feature work,  I am not pushing for performance, and I am not expecting great performance


% c.set_window_params(0.5, 5, 'EEGWindowCompSensing')
% disp('finishing extracting all windows')
% c.plot_pca()
% disp('start to compute kmeans')
% c.k_means(10)

%% gardern's energy implementation

c.set_window_params(2, 1, 'EEGWindowGardnerEnergy')
disp('finishing extracting all windows')
c.plot_pca()
disp('start to compute kmeans')
c.k_means(10)