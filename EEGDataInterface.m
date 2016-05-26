classdef EEGDataInterface < handle
% this is an interface for eegdata
% it handles I/O and data extraction using time as coordinates
% it is integrated with eeglab, provides raw data plot functionality, 
% as well as ica source separation (source component plot)

    properties
        curEEG
        sampling_rate = 128
        dataset_name % all data stored will be in the ./<dataset_name>Data/<dataset_name>_ext
        raw_data = 1
        ica_data
        ica_weights
        ica_inv
        chanlocs
        cur_component_index=1;
        start_loc
        end_loc
        raw_vec
        ica_vec
        window_raw_vec
        window_ica_vec
        begin_time
        interval_length
        xvec
        data_path
        seizure_times = [] % [start_time, end_time] each row represents an entry

    end

    methods
    %% all load functionalities
        function obj = EEGDataInterface(obj)       
            % initialize an empty object, just set the dataset_name
            % initialize eeglab
            parpath = fileparts(pwd);
            addpath([parpath '/eeglab']);
            eeglab;
        end
        
 
       function obj = set_name(obj, dataset_name)
            obj.dataset_name = dataset_name;
            mkdir([dataset_name 'Data']);
            obj.data_path = [pwd '/' dataset_name 'Data'];
        end

        function obj = load_raw(obj, readings_file)
            channel_file = [pwd '/' 'emotive_channel_info.ced']
            obj.curEEG = LoadEEGData(readings_file, obj.dataset_name, channel_file);
            obj = obj.extract_EEG_data();
        end

        function obj = pop_load_set(obj)
            obj.curEEG = pop_loadset();
            obj = obj.extract_EEG_data();
        end

        function obj = load_set(obj, path_to_set)
            obj.curEEG = pop_loadset(path_to_set);
            obj = obj.extract_EEG_data();
        end

        function obj = extract_EEG_data(obj)
            % extract values from EEG object for easier access
            obj.ica_weights = obj.curEEG.icaweights * obj.curEEG.icasphere;
            obj.ica_inv = obj.curEEG.icawinv;
            obj.raw_data = obj.curEEG.data;
            obj.ica_data = obj.ica_weights * obj.raw_data;
            obj.chanlocs = obj.curEEG.chanlocs;
            obj.raw_vec = obj.raw_data(obj.cur_component_index, :);
            obj.ica_vec = obj.ica_data(obj.cur_component_index, :);
        end

            %% helper functions
        function start_loc = get_time_loc(obj, time_in_sec) 
            % get the col_number of the first frame just after the time  
            start_loc = round(obj.sampling_rate * time_in_sec) + 1;
        end

        function [start_loc, end_loc] = get_interval_loc(obj, begin_time, interval)
            % inclusive of end point
            start_loc = round(obj.sampling_rate * begin_time) + 1;
            end_loc = round(obj.sampling_rate * (begin_time + interval));
        end

        function duration = get_total_length(obj)
            duration = obj.curEEG.xmax;
        end

        function [raw_vec, ica_vec] = get_component(obj, index)
            raw_vec = obj.data(index, :);
            ica_vec = obj.data(index, :);
        end


    end
end
