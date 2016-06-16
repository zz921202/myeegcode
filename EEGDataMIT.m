classdef EEGDataMIT < EEGDataInterface
% special read in file for MIT_CHB data set
    properties
        data_dir
        data_file
    end

    methods
        
        function obj = EEGDataMIT(obj) 
            obj.sampling_rate = 256; %TODO
        end

        % automatic detection will start time will be added subsequently
        function obj = set_data_file(obj, data_dir, data_file)
            % data_dir : e.g '/Users/Zhe/chb01'
            % data_file : e.g '/chb01_03'
            obj.seizure_times = [2996, 3036];
            obj.data_dir = data_dir;
            obj.data_file = [data_dir data_file];
        end

        function obj = load_raw(obj)
            channel_file = [ obj.data_dir '/channel_info.ced']
            disp(['........reading form', obj.data_file, '.........'])
            [hdr, record] = edfread(obj.data_file);
            load([obj.data_dir '/channel_reverse_info.mat']);
            channel_m = channel_inv * record;
            % channel_m = channel_m(:, 1:256);
            obj.curEEG = LoadEEGDataMatlab(channel_m, obj.dataset_name, channel_file, 256, 'CHB_MIT', 'MIT');
            obj = obj.extract_EEG_data();
        end

    end
end