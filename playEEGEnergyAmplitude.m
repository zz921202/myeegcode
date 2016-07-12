% matlabpool open
% cc = EEGStudyEmotiv();
% cc.import_data('/Users/Zhe/Documents/seizure/myeegcode/processed_data/Vidya_june_6_Data/faster_1639.set', 'faster_1639')

%% band power experiments
% set_window_params(obj, window_length, stride, window_generator)
% EEG band power distribution, distinctive separation between on-seizure and seizure 
% seizure states, parameters chosen to achieve very good separation

% TODO: compare with other interictal, preictal and postictal states

% cc.set_window_params(2, 2, 'EEGWindowBandCoherence')
% disp('finishing extracting all windows')
% % cc.plot_pca()
% disp('start to compute kmeans')

% cc.k_means(6)
% % % cc.EEGData.raw_electrodes()
% figure
% cc.plot_temporal_evolution()
% % ylim([0,3])
% title('patient')



% %
% dd = EEGStudyEmotiv();
% %% Juarez Data
% dd.import_data('/Users/Zhe/Documents/seizure/myeegcode/processed_data/Juarez_Data/faster_short.set', 'faster_short.set')

% % % band power experiments
% % % set_window_params(obj, window_length, stride, window_generator)
% % % EEG band power distribution, distinctive separation between on-seizure and seizure 
% % % seizure states, parameters chosen to achieve very good separation

% % % TODO: compare with other interictal, preictal and postictal states

% dd.set_window_params(2, 0.5, 'EEGWindowBandPower')
% disp('finishing extracting all windows')
% % dd.plot_pca()
% disp('start to compute kmeans')

% dd.k_means(6)

% figure
% dd.plot_temporal_evolution()
% % ylim([0,3])
% title('normal')

%% mit band experiment
file_dir = [pwd, '/processed_data/CHB_MIT_Data'];
save_dir = [pwd, '/tmp'];
all_files = {'03', '04', '10', '11', '12', '13', '15', '16', '18', '21', '26', '46'}
seizure_times = [2996, 3036;
                1467, 1494; 
                0, 0;
                0, 0; 
                0, 0; 
                0, 0; 
                1732, 1772; 
                1015, 1066;
                1720, 1810;
                327, 420;
                1862, 1963;
                0, 0]
% matlabpool open
for ind = 7
    filenum = all_files{ind};
    seizure_time = seizure_times(ind, :);
    filename = [file_dir, '/chb01_', filenum, '_raw.set']
    disp(['.......processing.......' filename]);
    mit = EEGStudyInterface();
    mit.import_data(filename, filenum, seizure_time);
%     mit.set_window_params(2, 1, 'EEGWindowBandCoherence');
    mit.set_window_params(2, 1, 'EEGWindowBandAmplitude')
    mit.plot_temporal_evolution()
    save([save_dir, '/mit', filenum], 'mit');
end
% matlabpool close 
mit.plot_pca()
% mit.k_means(3, true)
% matlabpool close