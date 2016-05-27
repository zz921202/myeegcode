classdef EEGStudyInterface < handle
    % overall flow of one study
    % concrete class includes specific eegdata 
    properties
        data_windows % an array that saves all data windows
        EEGData % source data file, handles I/O
        start_time
        end_time
        stride
        window_len
        feature_matirx
    end

    methods
        function gen_features(obj) % to be implemented in subclass 
            % generate data and extract features
            obj.EEGData = EEGStudyInterface();
            obj.EEGData.set_name('test_MIT');

        end


        function gen_feature_matrix(obj)
            % pull extracted features from each eeg window to form a matrix for fitting
            
        end

    end
end