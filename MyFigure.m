classdef MyFigure 
    % a data class for storing figure information to simplify workflow
    properties
        figure
        subplot
    end
    methods
        function obj = MyFigure(figure, subplot)
            % initialize class
            obj.figure = figure;
            obj.subplot = subplot;
        end

        function use_figure(obj)
            % set this figure object as current figure for plotting
            figure(obj.figure);
            subplot(obj.subplot);

        end

        function fig = get_figure(obj)
            % use to get frame to make movie
            fig = obj.figure;
        end

        function frame = get_frame(obj)
            % use to get frame to make movie
            frame = getframe(obj.figure);
        end
    end

end

% fig = figure('position', [100, 100, 600, 600], 'visible', 'off');