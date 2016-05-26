classdef EEGDataMIT < EEGDataInterface
% special read in file for MIT_CHB data set
    properties
        data_dir
        data_file
    end

    methods
        
        function obj = EEGDataMIT(obj) 
            obj.sampling_rate = 256;
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
            [hdr, record] = edfread(obj.data_file);
            load([obj.data_dir '/channel_reverse_info.mat']);
            channel_m = diff_inv * record;
            obj.curEEG = LoadEEGDataMatlab(channel_m, 'hello', channel_file);
        end

    end
end