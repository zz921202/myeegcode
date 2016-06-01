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
        start_loc %TODO: outdated structure, to be removed
        end_loc
        data_path
        seizure_times = [] % [start_time, end_time] each row represents an entry
        total_length
    end

    methods
    %% all load functionalities
        function obj = EEGDataInterface()       
            % initialize an empty object, just set the dataset_name
            % initialize eeglab
            parpath = fileparts(pwd);
            addpath([parpath '/eeglab']);
            eeglab;
        end
        
 
       function obj = set_name(obj, dataset_name)
            obj.dataset_name = dataset_name;
            mkdir([dataset_name '_Data']);
            obj.data_path = [pwd '/' dataset_name 'Data'];
        end

        function obj = load_raw(obj, readings_file)
            channel_file = [pwd '/' 'emotive_channel_info.ced'];
            obj.curEEG = LoadEEGData(readings_file, obj.dataset_name, channel_file);
            obj = obj.extract_EEG_data();
        end

        function obj = pop_load_set(obj)
            % TODO remember to set seizure times in EEGStudyInterface
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
            tot_pnts = size(obj.raw_data);
            obj.total_length = tot_pnts(2) / obj.sampling_rate;
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

        function description = to_str(obj)
            % TODO provide human readable concise descriptor
            description = '';
        end

        %% easy plot to browse the data    
        function plot_instant_overall_scalp(obj, start_time)
            topoplot(obj.raw_data(:, obj.get_time_loc(start_time)), obj.chanlocs);
            title(['raw scalp at' num2str(start_time) ' sec']);
        end

        function browse_raw(obj)
            eegplot(obj.raw_data)
        end

        function browse_ica(obj)
            eegplot(obj.ica_data)
        end

        function ica_electrodes(obj)
            pop_topoplot(obj.curEEG, 2)
        end

        % generate eeg_window object for feature extraction
        function set_window_obj(obj, object_class_name)
            obj.window_generator = object_class_name;
        end

        % TODO generate color encoding to emphasis not only pre-ictal, ictal and post-ictal features, but the transition between them as well
        function color_encoding = color_code(obj, window_start, window_length)
            % I implement a stupid coding just for testing
            % it looks like ___/start_time-----end_time\______ symmetric
            % color encoding will range from 0 to 1, with 1 being the most ictal window
            % TODO maybe we should assign a different encoding for ictal period or the symmetry between 
            %       pre-ictal and post-ictal should be explored for better representation

            % find out if it overlaps with ictal period
            scaling = 300; % how many seconds to reach 0.1 color encoding
            window_end = window_length + window_start;
            start_times = obj.seizure_times(:, 1);
            end_times = obj.seizure_times(:, 2);
            start_time_cond  = any(and(window_start > start_times, window_start < end_times));
            end_time_cond = any(and(window_end > start_times, window_end < end_times));
            if any([start_time_cond, end_time_cond])
                color_encoding = 2;
            else
                % find closet distance to the ictal state
                dist_start = min(min([abs(window_start - start_times),  abs(window_end - start_times)]));
                dist_end = min(min([abs(window_end - end_times),abs(window_start- end_times)]));
                if dist_end < dist_start
                    color_encoding = 3 - exp(dist_end / scaling * log(0.1));
                else
                    color_encoding = exp(dist_end / scaling * log(0.1));
                end

                
            end

        end



        function gen_ica_window(obj, start_time, interval_len, window_obj)
            % set the window for current analysis, pass raw data to window obj and perform 
            % analysis NOTE window object should be initialized before use

            [obj.start_loc, obj.end_loc] = get_interval_loc(obj, start_time, interval_len);
            ica_mat = obj.ica_data(:,obj.start_loc:obj.end_loc);
            input_mat = ica_mat;
            
            window_obj.set_raw_feature(input_mat, obj.sampling_rate);
            window_obj.time_info = [start_time, start_time + interval_len];
            window_obj.color_code = obj.color_code(start_time, interval_len);
            window_obj.extract_feature()
        end

        function gen_raw_window(obj, start_time, interval_len, window_obj)
            
            [obj.start_loc, obj.end_loc] = get_interval_loc(obj, start_time, interval_len);
            raw_mat = obj.raw_data(:,obj.start_loc:obj.end_loc);
            input_mat = raw_mat;
            
            window_obj.set_raw_feature(input_mat, obj.sampling_rate);
            window_obj.time_info = [start_time, start_time + interval_len];
            window_obj.color_code = obj.color_code(start_time, interval_len);
            window_obj.extract_feature()
        end
    end
end
