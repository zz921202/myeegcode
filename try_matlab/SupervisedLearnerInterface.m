classdef SupervisedLearnerInterface < handle
    % searching parameter adjustment will need to be performed manually
    properties

        model
    end

    methods(Abstract)

        % used as a demo to get an idea of basic performance
        [label, score] = train(obj, X, y, options_map)
        % use cross validation to search for optimal parameter model
        [label, score] = cvtrain(obj, X, y)
        % infer label for new data
        [label, score] = infer(obj, Xnew)

    end
end