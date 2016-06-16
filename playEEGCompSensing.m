%% comp sensing feature extraction

% I would not bet on it cause feature extraction is very time consuming, Moreover, 
% it is still a one-channel method, thus greatly limiting the prospective for finding 
% cross channel information 

% now just to make the feature work,  I am not pushing for performance, and I am not expecting great performance
% eegcode_path = pwd;
% cc = EEGStudyEmotiv();
% cc.import_data([eegcode_path,'/processed_data/Vidya_june_6_Data/faster_1630.set'], 'faster_1630')

% cc.set_window_params(2, 1, 'EEGWindowCompSensing')
% % disp('finishing extracting all windows')
% % c.plot_pca()
% % disp('start to compute kmeans')
% % c.k_means(10)
% cc.plot_temporal_evolution()
% ylim([0,1])



% dd = EEGStudyEmotiv();
% dd.import_data([eegcode_path,'/processed_data/Juarez_Data/faster_short.set'], 'faster_short.set')

% %% shortened Juarez data
% % set_window_params(mit, window_length, stride, window_generator)
% % EEG band power distribution, distinctive separation between on-seizure and seizure 
% % seizure states, parameters chosen to achieve very good separation

% % TODO: compare with other interictal, preictal and postictal states
% dd.set_window_params(2, 1, 'EEGWindowCompSensing')


% dd.plot_temporal_evolution()
% ylim([0,1])

mit = EEGStudyInterface();
mit.import_data();
mit.set_window_params(1, 1, 'EEGWindowCompSensing')
mymax = 0;
mymin = 0;
for num = 1: length(mit.data_windows)
    cur_window = mit.data_windows(num);
    mymax = max(max(max(cur_window.feature)), mymax)
end

for num = 1: length(mit.data_windows)
    cur_window = mit.data_windows(num);
    figure;
    cur_window.plot_my_feature([mymin, mymax]);
    title( ['at time ', num2str(mit.start_locs(num))]);
end

