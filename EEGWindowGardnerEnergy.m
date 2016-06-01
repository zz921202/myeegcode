classdef EEGWindowGardner < EEGWindowInterface
    % note that this is still a single channel approach, connectivity 
    % and other interesting properties are ignored
    methods
        function extract_feature(obj)
            feature = [];
            len = size(obj.raw_feature, 2);
            for chn = 1:size(obj.raw_feature,1)
                cur_chn = obj.raw_feature(chn,:)';
                cur_feature = obj.single_chanel_energy(cur_chn);
                feature = [feature; cur_feature]; % assume output from comp sensing is a row vector
            end
            obj.feature = feature;
            obj.flattened_feature = feature(:);

        end

        function cur_feature = single_chanel_energy(obj, vec)
            N = length(vec);
            % first order difference, curve length
            diffs = filter([1 -1], 1, vec)(2:);
            cl = log(sum(abs(diffs))) - N;
            % energy
            e = log(sum(vec.^2)) - N;
            % teager Energy
            te = log(sum(x(2: N-1).^2 - x(1:N-2).^ x(3:N))) - N;
            cur_feature = [cl, e, te]
        end
    end
end