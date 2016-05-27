classdef EEGWindowInterface < handle
    % a data window, concrete class should implement feature extraction 

    properties
        raw_feature
        extracted_feature % normally we should expect a column vector
        color_code % to be used for encoding type of information
        time_info % [strat_time, end_time] used as reference only, to be set directly
    end

    methods
    %% set input data
        function set_raw_feature(obj, input_data):
            obj.raw_feature = input_data
        end

        function extracted_feature(obj):
            obj.extracted_feature = obj.raw_feature[:]
        end

    end

end