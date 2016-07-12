classdef SVM < SupervisedLearnerInterface

    % searching parameter adjustment will need to be performed manually
    properties
        %model
    end

    methods

        % used as a demo to get an idea of basic performance
        function [labels, scores] = train(obj, X, y, options_map)
        end

        % use cross validation to search for optimal parameter model
        function [labels, scores] = cvtrain(obj, X, y)
            cdata = X; grp = y;
            % Train the classifier
            obj.model = fitcsvm(cdata,grp,'KernelFunction','rbf','ClassNames',unique(grp));

            c = cvpartition(length(y),'KFold',10); % partitioned object

            minfn = @(z)kfoldLoss(fitcsvm(cdata,grp,'CVPartition',c,...
                'KernelFunction','rbf','BoxConstraint',exp(z(2)),...
                'KernelScale',exp(z(1))));
            opts = optimset('Tolx', 5e-2, 'TolFun', 5e-2, 'Display', 'iter');
            [searchmin fval] = patternsearch(minfn, randn(2,1), [], [], [], [], [-5; -5], [5, 5], [], opts)
            z = exp(searchmin);
            obj.model = fitcsvm(cdata, grp, 'KernelFunction','rbf', 'KernelScale',z(1),'BoxConstraint',z(2))
            [labels, scores] = predict(obj.model,X);
            scores = scores(:, 2);
        end

        % infer label for new data
        function [labels, scores] = infer(obj, Xnew)
            [labels, scores] = predict(obj.model,Xnew);
            scores = scores(:, 2);
        end

    end
end