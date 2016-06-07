classdef EEGWindowInterface < handle
    % a data window, concrete class should implement feature extraction 

    properties
        raw_feature
        feature % normally we should expect a column vector
        flattened_feature
        color_code % to be used for encoding type of information
        time_info % [strat_time, end_time] used as reference only, to be set directly
        color_type
        abs_power
        freq
        Fs
    end

    methods
    %% set input data
        function set_raw_feature(obj, input_data, Fs)
            obj.raw_feature = input_data;
            obj.Fs = Fs;
            obj.get_frequency_spectrum();
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
        
        function get_frequency_spectrum(obj)
            Fs = obj.Fs;
            cur_data = obj.raw_feature;
            L = size(cur_data, 2);
            NFFT = 2^nextpow2(L); % Next power of 2 from length of y
            Y = fft(cur_data,NFFT, 2)/L;

            obj.freq = Fs/2*linspace(0,1,NFFT/2+1);
            obj.abs_power = 2*abs(Y(:,1:NFFT/2+1));
            
            % Y_sub = filter(1/20 * ones(1,20), 1, Y, [], 2);
            % Plot single-sided amplitude spectrum.
            % plot(f,2*abs(Y_sub(:,1:NFFT/2+1)))

            % title(['Single-Sided Amplitude Spectrum of y(t) at ' num2str(window)])
            % xlabel('Frequency (Hz)')
            % ylabel('|Y(f)|')
        end 

        function plot_my_feature(obj)
            % most appropriate representation of raw feature
            obj.plot_feature(obj.feature);
        end

        function plot_his_feature(obj, flattened_feature)
            feature_m = reshape(flattened_feature, size(obj.feature));
            obj.plot_feature(feature_m);
        end


        function plot_feature(obj, feature_m)
            % TODO to be implemented individually
            plot(feature_m);
        end

        function plot_raw_feature(obj)
            raw_feature = obj.raw_feature;
            fs = obj.Fs;
            eegplot(raw_feature, 'srate', fs, 'winlength', size(raw_feature,2)/fs);

        end

        function y = get_functional(obj)
            % TODO
            y = 0;
        end

        function  mystr = get_functional_label(obj)
            % TODO
            mystr = 'nothing'
        end
    end

end