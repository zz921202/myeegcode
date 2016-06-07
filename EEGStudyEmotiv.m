classdef EEGStudyEmotiv < EEGStudyInterface
    methods
        function import_data(obj, set_file, dataset_name)
            % TODO
            obj.EEGData = EEGDataInterface();
            obj.EEGData.load_set(set_file);
            % obj.EEGData.load_set('/Users/Zhe/Documents/seizure/myeegcode/Vidya_june_3_1_Data/faster_Vidya_june_3_1.set');
            obj.EEGData.set_name('', dataset_name);
            obj.EEGData.seizure_times = [-1, 0];
        end
    end
end