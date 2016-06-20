classdef EEGLearning < handle
% this class handles more complicated machine learning tasks, combining multiple segments of 
% eeg recording, it allows the integration of pca projection with machine learning algorithms f
% for a more visual understanding of performance of of trained model

    properties
        EEGStudyInterfaces = [] % an array of EEGStudyIntrefaces, data extraction should have already been completed 
        data_windows = [];
        p2;
        suplearner;
        debugging = true;
    end


    methods

        function set_study(obj, EEGStudy)

            % get and plot pca coordinates immedaitely after loading
            obj.pca()
        end

        % opt1 is the learned vector
        % green lines separate between different data sets
        function plot_temporal_evolution(obj, opt1)  
        end

        function [X, color_codes] = get_feature_and_label(obj, opt1) % opt1 selects which study to use
            if obj.debugging
                %% generate data
                % test data A
                % rng(0)
                % grnpnts = mvnrnd([2, 2 ,2],eye(3),100);
                % redpnts = mvnrnd([0, 0, 0],eye(3),100);
                % X = [grnpnts;redpnts];
                % grp = ones(200,1);
                % grp(101:200) = -1;
                % color_codes = grp;

                % test data B
                rng(1); % For reproducibility
                r = sqrt(rand(1000,1)); % Radius
                t = 2*pi*rand(1000,1);  % Angle
                data1 = [r.*cos(t), r.*sin(t)]; % Points

                r2 = sqrt(3*rand(1000,1)+1); % Radius
                t2 = 2*pi*rand(1000,1);      % Angle
                data2 = [r2.*cos(t2), r2.*sin(t2)]; % points

                % visualization of example data
                figure;
                plot(data1(:,1),data1(:,2),'r.','MarkerSize',15)
                hold on
                plot(data2(:,1),data2(:,2),'b.','MarkerSize',15)
                ezpolar(@(x)1);ezpolar(@(x)2);
                axis equal
                hold off


                X = [data1;data2];
                theclass = ones(2000,1);
                theclass(1:1000) = -1;

                color_codes = theclass;


                return 
            end
        end


        function pca(obj)
            
            if isempty(obj.p2)
                [data_mat, color_codes] = obj.get_feature_and_label();
                [~,~,V] = svd(data_mat);
                
                
                figure % plot 2d projection
                obj.p2 = V(:, 1:2);
                pca_coordinates = data_mat * obj.p2;
                scatter(pca_coordinates(:,1), pca_coordinates(:,2), 15, color_codes, 'filled');
                
                if size(data_mat, 2) > 2
                    pca_coordinates = data_mat * V(:, 1:3);
                    scatter3(pca_coordinates(:, 1), pca_coordinates(:, 2), pca_coordinates(:, 3), 15, color_codes, 'filled');
                end
                
            end
        end




        function suplearning(obj, learner, training_set)
            % learner must confrom to the SupervisedLearnerInterface

            [Xtrain, ytrain] = obj.get_feature_and_label(training_set);

            obj.suplearner = feval(learner);
            obj.suplearner.cvtrain(Xtrain, ytrain); % of course we could change it to train bunch of models using 
            % specific key-value pairs

            % visualization of performance on the training set
            cdata = Xtrain * obj.p2;
            grp = ytrain;
            d = 0.02;
            [x1Grid,x2Grid] = meshgrid(min(cdata(:,1)):d:max(cdata(:,1)),...
                min(cdata(:,2)):d:max(cdata(:,2)));
            xGrid = [x1Grid(:),x2Grid(:)]; % flattened X grid

            original_xGrid = xGrid * obj.p2';

            [~,scores] = obj.suplearner.infer(original_xGrid);

            % Plot the data and the decision boundary
            figure;
            h(1:2) = gscatter(cdata(:,1),cdata(:,2),grp,'rg','+*');
            hold on
            if learner == 'SVM'
                model = obj.suplearner.model;
                h(3) = plot(cdata(model.IsSupportVector,1),...
                    cdata(model.IsSupportVector,2),'ko');
            end
            contour(x1Grid,x2Grid,reshape(scores(:,2),size(x1Grid)),[0 0],'k');
            legend(h,{'-1','+1','Support Vectors'},'Location','Southeast');
            axis equal
            hold off

        end

        function test_sup_learner(obj, testing_set)
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% used to test learners

        function testing(obj)
            obj.plot_pca()
        end


    end

end
