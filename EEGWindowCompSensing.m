classdef EEGWindowCompSensing < EEGWindowInterface

    methods
        % function extract_feature(obj)
        %     % single channel implementation
        %     feature = [];
        %     len = size(obj.raw_feature, 2);
        %     % TODO change back
        %     for chn = 1:size(obj.raw_feature,1)
        %         cur_chn = obj.raw_feature(chn,:)';
        %         cur_feature = compsensing(cur_chn, 5, len);
        %         feature = [feature; cur_feature]; % assume output from comp sensing is a row vector
        %     end
        %     obj.feature = feature;
        %     obj.flattened_feature = feature(:);
        % end

        function y =get_functional(obj)

            len = size(obj.raw_feature, 2);
            curfeature = [];
            for chn = 1:size(obj.raw_feature,1)
                cur_chn = obj.raw_feature(chn,:)';
                cur_feature = compsensing(cur_chn, 1, len, [5,]);
                curfeature = [curfeature; cur_feature]; % assume output from comp sensing is a row vector
            end
            y = mean(curfeature);
        end

        function mystr = get_functional_label(obj)
            mystr = 'average(across channel) mse at compresion ration of 5';
        end

        
    end
end