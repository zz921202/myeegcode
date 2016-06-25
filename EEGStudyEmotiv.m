classdef EEGStudyEmotiv < EEGStudyInterface
    methods
        function import_data(obj, set_file, dataset_name)
            % TODO
            obj.EEGData = EEGDataInterface();
            obj.EEGData.load_set(set_file);
            % obj.EEGData.load_set('/Users/Zhe/Documents/seizure/myeegcode/Vidya_june_3_1_Data/faster_Vidya_june_3_1.set');
            [pathstr,name,ext] = fileparts(set_file);
            [pathstr, data_dir,ext] = fileparts(pathstr);
            obj.EEGData.set_name(dataset_name, data_dir);
            obj.EEGData.seizure_times = [0, 0];
        end
    end
end