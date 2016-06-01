classdef EEGWindowInterface < handle
    % a data window, concrete class should implement feature extraction 

    properties
        raw_feature
        feature % normally we should expect a column vector
        flattened_feature
        color_code % to be used for encoding type of information
        time_info % [strat_time, end_time] used as reference only, to be set directly
        color_type
    end

    methods
    %% set input data
        function set_raw_feature(obj, input_data)
            obj.raw_feature = input_data;
        end

        function extract_feature(obj)
            obj.feature = obj.raw_feature;
            obj.flattened_feature = obj.raw_feature(:);
        end

        function color_type = get_color_type(obj)
            % interitcal state
            if obj.color_code < 0.1 | obj.color_code > 2.9
                color_type = 0;
            elseif obj.color_code < 2
                color_type = 1 ;% preictal state
            elseif obj.color_code == 2
                color_type = 2 ;
            else
                color_type = 3 ;
            end
                
        end 
    end

end