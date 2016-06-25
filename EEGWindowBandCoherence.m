classdef EEGWindowBandCoherence < EEGWindowInterface

    properties(Constant)
        band_cutoff = [30,40] % to be set as a static parameter
    end

    properties
        
        cxy
        f
    end
    methods(Static)
        function cur_power = get_coherence_band_sum(cxy, f)
            low_cutoff = EEGWindowBandCoherence.band_cutoff(1);
            high_cutoff = EEGWindowBandCoherence.band_cutoff(2);
            test_cond = @(freq) and(freq >= low_cutoff, freq < high_cutoff);
            indicator = arrayfun(test_cond, f);

            cur_power = sum((cxy(indicator))) / sum(indicator);
        end
    end
    methods
          function extract_feature(obj)
            % opt1 used to indicate parallel processing
            
            dim = size(obj.raw_feature, 1);
            feature = zeros(dim,dim);
            raw_feature = obj.raw_feature;
            parfor i = 1:dim
            % for i = 1:dim
                curfeature = zeros(1,dim);
                for j= i: dim
                    x = raw_feature(i, :);
                    y = raw_feature(j, :);
                    [cxy, f] = mscohere(x,y,[],[],[],obj.Fs);
                    val = EEGWindowBandCoherence.get_coherence_band_sum(cxy,f);
                    curfeature(j) = val;
%                     feature(j,i) = val;
                end
                feature(i, :)= curfeature;
            end

            feature = feature + feature' - diag(diag(feature));
            obj.feature = feature;
            obj.flattened_feature = feature(:);
        end







        function plot_feature(obj, feature, opt1)%
            % opt1 is the intensity mapping [min, max], used for comparison
            ah1 = axes;
            imagesc(feature);
            if nargin == 3
                caxis(ah1,opt1)
            end
            colorbar;

        end 

        function y = get_functional(obj)
            y = mean(abs(obj.flattened_feature));
        end

        function mystr = get_functional_label(obj)
            mystr = 'l1 norm';
        end
    end
end