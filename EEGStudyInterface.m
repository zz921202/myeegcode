classdef EEGStudyInterface < handle
    % overall flow of one study
    % concrete class includes specific eegdata 
    % 
    properties
        data_windows = [] % an array that saves all data windows
        EEGData % source data file, handles I/O
        start_locs
        window_length
        feature_matrix = []
        num_windows
        window_generator = 'EEGWindowInterface'
        stride
        color_codes % used to indicate the class that current window belongs to 
        S = []          % should consider
        V = []% used to store result from pca
        color_types
        idx
        C
        pca_coordinates
        
    end

    methods

        function import_data(obj, opt1, opt2, opt3)
            % opt1 import data file
            % opt2 import dataset name
            % opt3 seizure times mx2 matrix

            if nargin == 1
                opt1 = '/Users/Zhe/Documents/seizure/myeegcode/test_MIT_Data/test_MIT_rejected.set';
                opt2 = 'test_MIT';
                opt3 = [2996, 3036];
            %  maybe rather than subclassing, change to just function calls, 
            % but I guess it might be a sensible thing to do when there are some many parameters to set
            end
            obj.EEGData = EEGDataMIT();

            obj.EEGData.load_set(opt1);
            obj.EEGData.set_name(opt2, 'CHB_MIT');
            obj.EEGData.seizure_times = opt3;


        end


        function set_window_params(obj, window_length, stride, window_generator)
            obj.window_length = window_length;
            obj.stride = stride;
            obj.window_generator = window_generator;
            obj.gen_data_windows()

        end

        function gen_data_windows(obj, opt1)
            %opt1 for parallel programming 

            % generate window location
            obj.start_locs = 0: obj.stride : (obj.EEGData.total_length - obj.window_length)
            %obj.start_locs = [ 2000,  2990, 3000, 3040, 3100]; % I changed this because compressive sensing is just too slow
            counter = 0
            % obj.start_locs
            % obj.EEGData.total_length
            for start_loc = obj.start_locs
                counter = counter + 1;
                if mod(counter, 500) == 0
                    disp(['......window : ' num2str(counter) '.........'])
                end

                curwindow = feval(obj.window_generator);
                obj.EEGData.gen_raw_window(start_loc, obj.window_length, curwindow); %TODO changed backed to raw window
                obj.data_windows = [obj.data_windows, curwindow];

            end

            obj.num_windows = length(obj.start_locs);
            obj.gen_feature_matrix();
            

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

        %TODO for backward compatibility support
        function check_color(obj)
            % disp('checking color ffff')
            if obj.EEGData.seizure_times(2) == 0
                % disp('checking color')
                obj.color_codes = zeros(size(obj.color_codes));
                obj.color_types = zeros(size(obj.color_types));
            end
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
        function pca(obj)
            data_mat = obj.feature_matrix;
            if isempty(obj.V)
                [U,S,V] = svd(data_mat);
                obj.V = V;
                obj.S = S;
            else
                V = obj.V;
                S = obj.S;
            end
            pca_coordinates = data_mat * V(:, 1:3);
            
            obj.pca_coordinates = pca_coordinates;
        end

        function plot_pca(obj, opt1)
            obj.pca();

            figure()
            pca_coordinates = obj.pca_coordinates;
            % subplot(131)
            % bar(diag(obj.S))
            % title(['PCA' obj.toString])

            % subplot(132)
            
            
            % %TODO changed scale for fair comparison
            % subplot(133)
            if nargin == 2
                scatter3(pca_coordinates(:, 1), pca_coordinates(:, 2), pca_coordinates(:, 3), 50, obj.color_codes, 'filled');
            else
                scatter(pca_coordinates(:,1), pca_coordinates(:,2), 50,obj.color_codes, 'filled')
            end
            % % zlim([-0.4, 0.4])
            colorbar()
        end

        function porp = k_means(obj, k, opt1)
            % function for normalize a vector 
            % porp the percentage of correct clustering
            data_mat = obj.feature_matrix;
            % pool = parpool;                      % In cvokes workers
            % stream = RandStream('mlfg6331_64');  % Random number stream
            % options = statset('UseParallel',1,'UseSubstreams',1,...
            %                     'Streams',stream);

            figure()
            [idx, C] = kmeans(data_mat, k,'MaxIter',1000, 'Replicates',20) ;
            obj.idx = idx;
            obj.C = C;
            disp('finishing kmeans clustering');

            subplot(121)
            plot(C')
            title('kmeans vectors')
            
            ss = 1:k;
            ss = arrayfun(@num2str, ss, 'UniformOutput', false);
            legend(ss)

            subplot(122)
            obj.bar_plot(idx);
            title('group disribution')



            
            obj.pca();

            pca_coordinates = obj.pca_coordinates;
            figure()

            scatter(pca_coordinates(:,1), pca_coordinates(:,2), 50,obj.idx, 'filled')
            % scatter3(pca_coordinates(:, 1), pca_coordinates(:, 2), pca_coordinates(:, 3), 50,obj.idx, 'filled');
            colorbar;

            first_window = obj.data_windows(1);

            n = 3; % number of subplots per graph, individual plots
            
            if nargin == 3
                obj.EEGData.raw_electrodes(); % more detailed graph
                for i = 0:1:floor(k/n)                
                    % figure()
                    for j = 1:n
                        curidx = n * i + j;
                        if curidx > k
                            break
                        end
                        figure()
                        % subplot(1, n, j)
                        curfeature = C(curidx, :);
                        first_window.plot_his_feature(curfeature(:))%, [0, 0.7]);%TODO remove limit
                        title(sprintf('%d th component',curidx))
                    end
                end

                for i = 0:1:floor(k/n) 
                    % plot raw temporal data
                    % figure()
                    for j = 1:n
                        curidx = n * i + j;
                        if curidx > k
                            break
                        end
                        windowidx = find(idx == curidx);
                        type_windows = obj.data_windows(windowidx);
                        first_window = type_windows(2);
                        first_window.plot_raw_feature();
                        title(sprintf('%d th compoenent',curidx));
                    end
                end
            end


            % show original temporal feature(time series) corresponding to each feature, take the mean

        end

        function y = plot_temporal_evolution(obj, opt1)
            % opt1 supports foreign vectors, say the classification result from svm etc
            if nargin < 2
                y = [];
                for curwindow = obj.data_windows
                    y = [y, curwindow.get_functional()];
                    
                end
                my_ylabel = curwindow.get_functional_label;
            else
                if obj.num_windows ~= length(opt1);
                    error('input feature vector are incompatible with current study')
                end
                y = opt1;
                my_ylabel = 'score';
            end


            figure()

            plot(obj.start_locs, y)
            xlabel('time')
            ylabel(my_ylabel)
            title(['temporal evolution' , obj.toString]);
            for row = size(obj.EEGData.seizure_times, 1)
                for marker = obj.EEGData.seizure_times(row, :)
                    line([marker, marker], ylim, 'color','red')
                end
            end

        end

        %% standard functionalities
        function mystr = toString(obj)
            mystr = [class(obj) ' '  num2str(obj.num_windows) ' of ' num2str(obj.window_length) ' sec ' obj.window_generator ...
                              ' from ' obj.EEGData.toString];
        end


        
    end
end