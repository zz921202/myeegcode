classdef EEGStudyInterface < handle
    % overall flow of one study
    % concrete class includes specific eegdata 
    properties
        data_windows = [] % an array that saves all data windows
        EEGData % source data file, handles I/O
        start_locs
        window_length
        feature_matrix = []
        num_windows
        window_generator = 'EEGWindowInterface'
        stride
        toString
        color_codes % used to indicate the class that current window belongs to 
        S = []          % should consider
        V = []% used to store result from pca
        color_types
        idx
        C
    end

    methods

        function import_data(obj)
            %  maybe rather than subclassing, change to just function calls, 
            % but I guess it might be a sensible thing to do when there are some many parameters to set

            obj.EEGData = EEGDataMIT();
            obj.EEGData.load_set('/Users/Zhe/Documents/seizure/myeegcode/test_MIT_Data/test_MIT_rejected.set');
            obj.EEGData.set_name('test_MIT');
            obj.EEGData.seizure_times = [2996, 3036];
        end

        function set_window_params(obj, window_length, stride, window_generator)
            obj.window_length = window_length;
            obj.stride = stride;
            obj.window_generator = window_generator;
            obj.gen_data_windows()

        end

        function gen_data_windows(obj) 

            % generate window location
            obj.start_locs = 0: obj.stride : (obj.EEGData.total_length - obj.window_length);

            for start_loc = obj.start_locs
                curwindow = feval(obj.window_generator);
                obj.EEGData.gen_ica_window(start_loc, obj.window_length, curwindow);
                obj.data_windows = [obj.data_windows, curwindow];
            end
            obj.num_windows = length(obj.start_locs);
            obj.gen_feature_matrix();
            obj.toString = [class(obj) 'from 0 to ' num2str(obj.EEGData.total_length) ' with ' num2str(obj.num_windows) ' ' obj.window_generator ];
        end

        %% helper functions, to be called inside each subclass


        function gen_feature_matrix(obj)
            % pull extracted features from each eeg window to form a matrix for fitting
            % ASSUME that we are using flattened column vector features
            % we would not use that for ,say, convolution neural network(CNN)
            feature_matrix = [];
            color_codes = [];
            color_types = [];
            for cur_window  = obj.data_windows
                feature_matrix = [feature_matrix, cur_window.flattened_feature];
                color_codes = [color_codes, cur_window.color_code];
                color_types = [color_types, cur_window.get_color_type()];
            end
            obj.feature_matrix = feature_matrix';
            obj.color_codes = color_codes;
            obj.color_types = color_types;
        end

        %% Exploratory Analysis primarily Unsupervised Learning, NOW the exciting part

        %% helper plot functions

        function bar_plot(obj, clusters)
            % barplot test
            % given two vectors x, y with x indicating the class member ship and y the
            % submembership
            % draw barplots

            x = clusters(:);
            y = obj.color_types(:);
            combi = [x y];
            result = [];
            count_num = @(sample_vector) sum(not(any(bsxfun(@minus, combi, sample_vector), 2)));
            for cluster = sort(unique(x))'
                currow = [];
                for type = sort(unique(y))'
                    sample_vector = [cluster, type];
                    currow = [currow, count_num(sample_vector)];
                end
                result = [result; currow];
            end
            bar(result)
            colorbar()
        end

        % pca
        function plot_pca(obj)
            data_mat = obj.feature_matrix;
            if isempty(obj.V)
                [U,S,V] = svd(data_mat);
                obj.V = V;
                obj.S = S;
            else
                V = obj.V;
                S = obj.S;
            end
            
            figure()
            subplot(131)
            bar(diag(S))
            title(['PCA' obj.toString])

            subplot(132)
            pca_coordinates = data_mat * V(:, 1:3);
            scatter(pca_coordinates(:,1), pca_coordinates(:,2), 50,obj.color_codes, 'filled')

            subplot(133)
            scatter3(pca_coordinates(:, 1), pca_coordinates(:, 2), pca_coordinates(:, 3), 50, obj.color_codes, 'filled');

            colorbar()

        end

        function k_means(obj, k)
            % function for normalize a vector 
            data_mat = obj.feature_matrix;
            % pool = parpool;                      % Invokes workers
            % stream = RandStream('mlfg6331_64');  % Random number stream
            % options = statset('UseParallel',1,'UseSubstreams',1,...
            %                     'Streams',stream);

            figure()
            [idx, C] = kmeans(data_mat, k,'MaxIter',100,'Display', 'iter' ) ;
            obj.idx = idx;
            obj.C = C;
            disp('finishing kmeans clustering');

            subplot(121)
            plot(C')
            title('kmeans vectors')

            subplot(122)
            obj.bar_plot(idx);
            title('group disribution')




            for i = 0:1:(k/5-1)                
                figure()
                for j = 1:5
                    curidx = 5 * i + j;
                    subplot(1, 5, j)
                    plot(C(curidx, :)')
                    title(sprintf('%d th compoenent',curidx))
                end
            end
        end


        %% Quantitative Analysis primarily Supervised Learning, the even more exciting part

        


    end
end