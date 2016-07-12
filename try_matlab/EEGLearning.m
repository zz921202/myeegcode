classdef EEGLearning < handle
% this class handles more complicated machine learning tasks, combining multiple segments of 
% eeg recording, it allows the integration of pca projection with machine learning algorithms f
% for a more visual understanding of performance of of trained model

    properties
        EEGStudyInterfaces = [] % an array of EEGStudyIntrefaces, data extraction should have already been completed 
        
        p2;
        suplearner;
        debugging = false;
        EEGStudys = [];
    end


    methods

        %%%%%%%%%%%%%%%%%  helper functions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function set_study(obj, EEGStudys)
            % EEGStudys should have already imported data and generated data windows
            % get and plot pca coordinates immedaitely after loading
            obj.EEGStudys = EEGStudys;
            obj.pca(1:length(EEGStudys), 0.1);
        end

        

        function [X, color_types, endpoints, data_windows, color_codes] = get_feature_and_label(obj, datasets, type_to_use) % opt1 selects which study to use
            % endpoints is used to separate the data windows to their corresponding EEGStudy instance so that we could 
            % delegate plot temporal evolution back to the original class
            % X each row represents an data point

            % type_to_use to extract a subset of data according to color designation
            if obj.debugging
                [X, color_types] = obj.generate_test_data();
                endpoints = [];
                return 
            end

            % load EEG study datasets
            if nargin < 2
                datasets = 1: length(obj.EEGStudys);
            end
            endpoints = zeros(1, length(datasets));
            cum_windows_counter = 0;
            X = [];
            color_types = [];
            data_windows = [];
            color_codes = [];
            for ind = 1: length(datasets)
                data_ind = datasets(ind);
                curEEGStudy = obj.EEGStudys(data_ind);
                curEEGStudy.check_color();

                data_windows = [data_windows, curEEGStudy.data_windows];

                X = [X; curEEGStudy.feature_matrix];
                color_types = [color_types; curEEGStudy.color_types(:)];
                color_codes = [color_codes; curEEGStudy.color_codes(:)];

                cum_windows_counter = cum_windows_counter + length(curEEGStudy.data_windows);

                endpoints(ind) = cum_windows_counter;

            end

            if  nargin > 2

                indicator = zeros(size(color_types));
                for curtype = type_to_use
                    indicator = indicator + (color_types == curtype);
                end
                indicator = logical(indicator);
                X = X(indicator, :);
                data_windows = data_windows(indicator);
                color_types = color_types(indicator);
                color_codes = color_codes(indicator);
            end


        end

        function splitted_struct = split_vector_back(obj, vec, datasets)
            % splitted struct is a sturct of vectors containing functional feature corresponding to each data source
            [~, ~, endpoints] = obj.get_feature_and_label(datasets);

            end_point = 0;
            splitted_struct = {};
            for ind = 1:length(datasets)
                start_point = end_point + 1;
                end_point = endpoints(ind);
                splitted_struct{ind} = vec(start_point: end_point);
            end
        end


        function pca(obj, datasets, sample_proportion)

            disp('..........starting pca...........');
            if nargin < 2
                [data_mat, color_types, endpoints, ~, color_codes] = obj.get_feature_and_label();
            else
                %TODO remove 1:3
                [data_mat, color_types, endpoints, ~, color_codes] = obj.get_feature_and_label(datasets);

            end



            if nargin < 3
                sample_proportion = 0.1;
            end
            k = floor(length(data_mat) * sample_proportion);
            sampled_data_mat = datasample(data_mat,k ,1);

            [~,~,V] = svd(sampled_data_mat);
            
             % plot 2d projection
            obj.p2 = V(:, 1:2);
            pca_coordinates = data_mat * obj.p2;
            if unique(color_types) == 0 % color according to the dataset in chronological order
                end_point = 0;
                for ind = 1:length(endpoints)
                    start_point = end_point + 1;
                    end_point = endpoints(ind);
                    color_types(start_point: end_point) = ind;
                end
            end
            figure;
            scatter(pca_coordinates(:,1), pca_coordinates(:,2), 15, color_types, 'filled');
            title('pca 2d plot of color types')
            scatter(pca_coordinates(:,1), pca_coordinates(:,2), 15, color_codes, 'filled');
            title('pca 2d continuous color encoding')
            colorbar

            figure
            subplot(311)
            title('pca 1 evolution');
            color_line(1: length(color_codes),pca_coordinates(:,1)', color_types')
            for endpoint = endpoints
                line([endpoint, endpoint], ylim, 'color', 'blue');
            end

            subplot(312)
            title('pca 2 evolution');
            color_line(1: length(color_codes),pca_coordinates(:,2)', color_types')
            for endpoint = endpoints
                line([endpoint, endpoint], ylim, 'color', 'blue');
            end


            subplot(313)
            title('pca 3 evolution');
            pca_coordinates = data_mat * V(:, 1:3);
            color_line(1: length(color_codes),pca_coordinates(:,3)', color_types')
            for endpoint = endpoints
                line([endpoint, endpoint], ylim, 'color', 'blue');
            end

            if size(data_mat, 2) > 2
                pca_coordinates = data_mat * V(:, 1:3);
                figure;
                scatter3(pca_coordinates(:, 1), pca_coordinates(:, 2), pca_coordinates(:, 3), 15, color_types, 'filled');
                colorbar
            end
            disp('............end of pca..........');
        end


        function sup_learning(obj, learner, training_set)
            % learner must confrom to the SupervisedLearnerInterface

            [Xtrain, ytrain] = obj.get_feature_and_label(training_set);
        
            ytrain = obj.color_transform(ytrain);
            obj.suplearner = feval(learner);

            [label, score] = obj.suplearner.cvtrain(Xtrain, ytrain); % of course we could change it to train bunch of models using 
            
            % temporal visualization 
            
            obj.plot_temporal_evolution(training_set, score);
            % figure
            % obj.plot_temporal_evolution(training_set, label);
            
            obj.plot_temporal_evolution(training_set);


            % visualization of scatter
            cdata = Xtrain * obj.p2;
            grp = ytrain;
            d = 0.02;
            [x1Grid,x2Grid] = meshgrid(min(cdata(:,1)):d:max(cdata(:,1)),...
                min(cdata(:,2)):d:max(cdata(:,2)));
            xGrid = [x1Grid(:),x2Grid(:)]; % flattened X grid

            original_xGrid = xGrid * obj.p2';

            [~,scores] = obj.suplearner.infer(original_xGrid);
            figure
            plot(scores);
            % Plot the data and the decision boundary
            figure;
            h(1:2) = gscatter(cdata(:,1),cdata(:,2),grp,'rg','+*');
            hold on
            if strcmp(class(obj.suplearner), 'SVM')
                model = obj.suplearner.model;
                h(3) = plot(cdata(model.IsSupportVector,1),...
                    cdata(model.IsSupportVector,2),'ko');
            end
            contour(x1Grid,x2Grid,reshape(scores,size(x1Grid)),[0 0],'k');
            legend(h,{'-1','+1','Support Vectors'},'Location','Southeast');
            axis equal
            hold off
        end

        function plot_temporal_evolution(obj, datasets, vec)
            % opt1 used to indicate to use external functionals to plot

            if nargin < 3
                vec = [];
                for idx = datasets
                    curStudy = obj.EEGStudys(idx);
                    y = curStudy.plot_temporal_evolution();
                   
                    vec = [vec, y(:)'];
                end
            else
                splited_vec = obj.split_vector_back(vec, datasets);
                for idx = datasets
                    curStudy = obj.EEGStudys(idx);
                    curStudy.toString
                    curvec = splited_vec{1:length(datasets)};
                    curStudy.plot_temporal_evolution(curvec);
                end         
            end
            [~, ~, endpoints, ~] = obj.get_feature_and_label(datasets);
            figure
            
            plot(vec)
            for endpoint = endpoints
                line([endpoint, endpoint], ylim, 'color', 'blue');
            end
            title('total temporal evolution')
            
        end

        function test_sup_learner(obj, testing_set)

            [Xtest, ytest] = obj.get_feature_and_label(testing_set);
        
            ytest = obj.color_transform(ytest);

            [label, score] = obj.suplearner.infer(Xtest); % of course we could change it to train bunch of models using 
            % temporal visualization 
            obj.plot_temporal_evolution(testing_set, score);
            % figure
            % obj.plot_temporal_evolution(training_set, label);
            obj.plot_temporal_evolution(testing_set);

            cdata = Xtest * obj.p2;
            grp = ytest;
            d = 0.02;
            [x1Grid,x2Grid] = meshgrid(min(cdata(:,1)):d:max(cdata(:,1)),...
                min(cdata(:,2)):d:max(cdata(:,2)));
            xGrid = [x1Grid(:),x2Grid(:)]; % flattened X grid
            original_xGrid = xGrid * obj.p2';
            [~,scores] = obj.suplearner.infer(original_xGrid);


            figure
            title('scores on the projection')
            plot(scores);

            figure
            conf = confusionmat(ytest, label)
            imagesc(conf)
            xlabel('true label')
            ylabel('predicted label')

            % Plot the data and the decision boundary
            figure
            gscatter(cdata(:,1),cdata(:,2),grp,'rg','+*');
            title('original grouping')

            figure;
            h(1:2) = gscatter(cdata(:,1),cdata(:,2),label,'rg','+*');
            title('fitted grouping')


            hold on

            contour(x1Grid,x2Grid,reshape(scores,size(x1Grid)),[0 0],'k');
            legend(h,{'-1','+1'},'Location','Southeast');
            axis equal
            hold off

        end

        % use to transform color encoding to binary for classification
        function labels = color_transform(obj, color_types)
            active_set = [1,2,3];
            labels = - ones(size(color_types));
            for encoding = active_set
                labels(color_types == encoding) = 1;
            end

        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% used to test learners

        function testing(obj)
                        % visualization of scatter
            [Xtrain, ytrain] = obj.get_feature_and_label([1,]);
        
            ytrain = obj.color_transform(ytrain);

            
            cdata = Xtrain * obj.p2;
            grp = ytrain;
            d = 0.02;
            [x1Grid,x2Grid] = meshgrid(min(cdata(:,1)):d:max(cdata(:,1)),...
                min(cdata(:,2)):d:max(cdata(:,2)));
            xGrid = [x1Grid(:),x2Grid(:)]; % flattened X grid

            original_xGrid = xGrid * obj.p2';

            [~,scores] = obj.suplearner.infer(original_xGrid);
            figure
            plot(scores);
            % Plot the data and the decision boundary
            figure;
            h(1:2) = gscatter(cdata(:,1),cdata(:,2),grp,'rg','+*');
            hold on

            model = obj.suplearner.model;
            h(3) = plot(cdata(model.IsSupportVector,1),...
                cdata(model.IsSupportVector,2),'ko');

            contour(x1Grid,x2Grid,reshape(scores,size(x1Grid)),[0 0],'k');
            legend(h,{'-1','+1','Support Vectors'},'Location','Southeast');
            axis equal
            hold off

        end

        function [X, color_types] = generate_test_data(obj)
                           
                % test data A
                rng(0)
                grnpnts = mvnrnd([2, 2 ,2],eye(3),100);
                redpnts = mvnrnd([0, 0, 0],eye(3),100);
                X = [grnpnts;redpnts];
                grp = ones(200,1);
                grp(101:200) = -1;
                color_types = grp;

                % test data B
                % rng(1); % For reproducibility
                % r = sqrt(rand(1000,1)); % Radius
                % t = 2*pi*rand(1000,1);  % Angle
                % data1 = [r.*cos(t), r.*sin(t)]; % Points

                % r2 = sqrt(3*rand(1000,1)+1); % Radius
                % t2 = 2*pi*rand(1000,1);      % Angle
                % data2 = [r2.*cos(t2), r2.*sin(t2)]; % points

                % % visualization of example data
                % figure;
                % plot(data1(:,1),data1(:,2),'r.','MarkerSize',15)
                % hold on
                % plot(data2(:,1),data2(:,2),'b.','MarkerSize',15)
                % ezpolar(@(x)1);ezpolar(@(x)2);
                % axis equal
                % hold off


                % X = [data1;data2];
                % theclass = ones(2000,1);
                % theclass(1:1000) = -1;

                % color_types = theclass;
        end




            % show original temporal feature(time series) corresponding to each feature, take the mean




        function k_means(obj, k, datasets)
            % function for normalize a vector 
            % porp the percentage of correct clustering
            


            disp('..........starting k means...........');
            if nargin == 3
                [data_mat, color_types, endpoints, data_windows] = obj.get_feature_and_label(datasets);
            else
                [data_mat, color_types, endpoints, data_windows] = obj.get_feature_and_label();
            end

            
            if unique(color_types) == 0 % color according to the dataset in chronological order
                end_point = 0;
                for ind = 1:length(endpoints)
                    start_point = end_point + 1;
                    end_point = endpoints(ind);
                    color_types(start_point: end_point) = ind;
                end
            end


            figure()
            
            figure
            [idx, C] = kmeans(data_mat, k,'MaxIter',1000, 'Replicates',20) ;


            disp('finishing kmeans clustering');

            figure
            plot(C')
            title('kmeans vectors')
            
            ss = 1:k;
            ss = arrayfun(@num2str, ss, 'UniformOutput', false);
            legend(ss)




            
           
            pca_coordinates = data_mat * obj.p2;

            figure()
            subplot(121)
            scatter(pca_coordinates(:,1), pca_coordinates(:,2), 15,idx, 'filled')
            colorbar
            title('k_means clustering')
            subplot(122)

            scatter(pca_coordinates(:,1), pca_coordinates(:,2), 15, 1 : size(pca_coordinates, 1), 'filled')
            title('time elapsed')

            % scatter3(pca_coordinates(:, 1), pca_coordinates(:, 2), pca_coordinates(:, 3), 50,obj.idx, 'filled');
            colorbar;
            figure();

            plot(idx);
            title('time evolution of idx')
            ylim([0, max(max(idx)) + 1]);
            %TODO delete this one, used for once 
            % figure;
            % plot(pca_coordinates(:, 2)' > -1);
            % ylim([-1,2]);
            % title('vertical separation');

            first_window = data_windows(1);

            n = 3; % number of subplots per graph, individual plots
            plot_limits = [min(min(C)), max(max(C))];
            
            if true %TODO change to true
                
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

                        first_window.plot_his_feature(curfeature(:), plot_limits)%, [0, 0.7]);%TODO remove limit
                        title(sprintf('%d th component',curidx))
                    end
                end

                % change to a more representative element
                for i = 0:1:floor(k/n) 
                    % plot raw temporal data
                    % figure()
                    for j = 1:n
                        curidx = n * i + j;
                        if curidx > k
                            break
                        end

                        % to find most representative element in terms of l2 distance
                        cur_landmark = C(curidx, :);
                        best_dist = inf;
                        best_win = [];
                        for cur_win = data_windows
                            cur_dist = norm(cur_landmark(:) - cur_win.flattened_feature(:));
                            if cur_dist < best_dist
                                best_dist = cur_dist;
                                best_win = cur_win;
                            end
                        end


                        % windowidx = find(idx == curidx);
                        % type_windows = data_windows(windowidx);
                        % first_window = type_windows(2);
                        best_win.plot_raw_feature();
                        title(sprintf('%d th compoenent',curidx));
                    end
                end
            end
        end
    end
end
