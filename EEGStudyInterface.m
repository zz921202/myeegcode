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
    end

    methods
        function gen_features(obj) % to be implemented in subclass 
            % generate data and extract features
            obj.EEGData = EEGStudyInterface();
            obj.EEGData.set_name('test_MIT');


        end

    end
end