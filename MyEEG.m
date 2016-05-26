classdef MyEEG < handle
% this matlab class stores a single recording of EEG data
% it provides function handles to load data set from raw txt file or import processed
% data
% it should also provide user friendly interface for analysis of data based on abstract concept like time
% it also integrates various plotting functionality of eeg lab, so it is like a wrapper 
% on eeg lab
    properties
        curEEG
        sampling_rate = 128
        dataset_name % all data stored will be in the ./<dataset_name>Data/<dataset_name>_ext
        raw_data 
        ica_data
        ica_weights
        ica_inv
        chanlocs
        cur_component_index=1;
        start_loc
        end_loc
        raw_vec
        ica_vec
        window_raw_vec
        window_ica_vec
        begin_time
        interval_length
        xvec
        data_path
        curmovie
    end

    methods
    %% all load functionalities
        function obj = MyEEG(obj)       
            % initialize an empty object, just set the dataset_name
            % initialize eeglab
            parpath = fileparts(pwd);
            addpath([parpath '/eeglab']);
            eeglab;
        end
        
 
       function obj = set_name(obj, dataset_name)
            obj.dataset_name = dataset_name;
            mkdir([dataset_name 'Data']);
            obj.data_path = [pwd '/' dataset_name 'Data'];
        end

        function obj = load_raw(obj, readings_file, channel_file)
            obj.curEEG = LoadEEGData(readings_file, obj.dataset_name, channel_file);
            obj = obj.extract_EEG_data();
        end

        function obj = pop_load_set(obj)
            obj.curEEG = pop_loadset();
            obj = obj.extract_EEG_data();
        end

        function obj = load_set(obj, path_to_set)
            obj.curEEG = pop_loadset(path_to_set);
            obj = obj.extract_EEG_data();
        end

        function obj = extract_EEG_data(obj)
            % extract values from EEG object for easier access
            obj.ica_weights = obj.curEEG.icaweights * obj.curEEG.icasphere;
            obj.ica_inv = obj.curEEG.icawinv;
            obj.raw_data = obj.curEEG.data;
            obj.ica_data = obj.ica_weights * obj.raw_data;
            obj.chanlocs = obj.curEEG.chanlocs;
            obj.raw_vec = obj.raw_data(obj.cur_component_index, :);
            obj.ica_vec = obj.ica_data(obj.cur_component_index, :);
        end


    %% helper functions
        function start_loc = get_time_loc(obj, time_in_sec) 
            % get the col_number of the first frame just after the time  
            start_loc = round(obj.sampling_rate * time_in_sec) + 1;
        end

        function [start_loc, end_loc] = get_interval_loc(obj, begin_time, interval)
            % inclusive of end point
            start_loc = round(obj.sampling_rate * begin_time) + 1;
            end_loc = round(obj.sampling_rate * (begin_time + interval));
        end

        function duration = get_total_length(obj)
            duration = obj.curEEG.xmax;
        end

        function [raw_vec, ica_vec] = get_component(obj, index)
            raw_vec = obj.data(index, :);
            ica_vec = obj.data(index, :);
        end
        
    %% instant plot    
        function plot_instant_overall_scalp(obj, start_time, myfigure)
            myfigure.use_figure()
            topoplot(obj.raw_data(:, obj.get_time_loc(start_time)), obj.chanlocs);
            title(['raw scalp at' num2str(start_time) ' sec']);

        end


    %% time window analysis

        function obj = use_time_window(obj, begin_time, interval_length)
            % set the window for current analysis, 
            obj.begin_time = begin_time;
            obj.interval_length = interval_length;
            [obj.start_loc, obj.end_loc] = get_interval_loc(obj, begin_time, interval_length);
            obj.xvec = (obj.start_loc : obj.end_loc) / obj.sampling_rate;
            obj.window_raw_vec = obj.raw_vec(obj.start_loc:obj.end_loc);
            obj.window_ica_vec = obj.ica_vec(obj.start_loc:obj.end_loc);
        end

        function  [ica_mat, raw_mat]= use_window_data(obj, begin_time, interval_length)
            % output the current window raw_data for analysis
            obj.begin_time = begin_time;
            obj.interval_length = interval_length;
            [obj.start_loc, obj.end_loc] = get_interval_loc(obj, begin_time, interval_length);
            obj.xvec = (obj.start_loc : obj.end_loc) / obj.sampling_rate;
            raw_mat = obj.raw_data(:,obj.start_loc:obj.end_loc);
            ica_mat = obj.ica_data(:,obj.start_loc:obj.end_loc);
        end


        function info = get_window_info(obj)
            info = ['[' num2str(obj.begin_time) ',' num2str(obj.begin_time + obj.interval_length) '] sec'];
        end

        function plot_interval_overall_scalp(obj, myfigure)
            myfigure.use_figure()
 
            mean_potential = mean(obj.raw_data(:, obj.start_loc: obj.end_loc) ,2);
            topoplot(mean_potential, obj.chanlocs);
            title(['raw scalp plot for ', obj.get_window_info()]);
        end


    %% component +  windowed analysis:  set component and basic parameters

        function obj = use_component(obj, cur_component_index)
            obj.cur_component_index = cur_component_index ;
            obj.raw_vec = obj.raw_data(cur_component_index, :);
            obj.ica_vec = obj.ica_data(cur_component_index, :);
            % obj.window_raw_vec = obj.raw_vec(obj.start_loc:obj.end_loc);
            % obj.window_ica_vec = obj.ica_vec(obj.start_loc:obj.end_loc);
        end

        function info = get_component_info(obj)
            info = ['Comp' , num2str(obj.cur_component_index)];
        end

        %% component analysis, plotting functionalities
        function plot_ica_scalp(obj, myfigure)
            myfigure.use_figure()
            topoplot(obj.ica_inv(:, obj.cur_component_index), obj.chanlocs);
            title(['scalp plot for' obj.get_component_info()]);
        end

        function plot_ica_signal(obj, myfigure)
            % just normal zigzag plot of a signal
            myfigure.use_figure()
            plot(obj.xvec, obj.window_ica_vec)
            ylim([-150, 150])
            title(['ica ' obj.get_component_info() '' obj.get_window_info()])
        end



        function plot_ica_compressive(obj, myfigure)
            myfigure.use_figure()
            vec_len = length(obj.window_ica_vec);
            compsensing(obj.window_ica_vec, 5, vec_len);
            ylim([0, 1])
            title(['ICA compsensing' obj.get_component_info() 'during' obj.get_window_info() ]);
        end

        function plot_wavelet(obj, myfigure)
            
            myfigure.use_figure()
            myqporps_new(obj.window_ica_vec, obj.xvec, obj.sampling_rate,'wavelets');
        end

        function plot_wavelet_frequency(obj, myfigure)
            myfigure.use_figure()
            myqporps_new(obj.window_ica_vec, obj.xvec, obj.sampling_rate,'frequency')
        end

        function plot_wavelet_energy_bar(obj, myfigure)
            myfigure.use_figure()
            myqporps_new(obj.window_ica_vec, obj.xvec, obj.sampling_rate,'energy_bar')
            ylim([0,8])
        end            
        %% make movie with frames

        function frame = make_a_frame(obj)
            f = figure('position', [100, 100, 1500, 1000], 'visible','off');
            fa = MyFigure(f, subplot(231));
            fb = MyFigure(f, subplot(232));
            fc = MyFigure(f, subplot(233));
            fd = MyFigure(f, subplot(234));
            fe = MyFigure(f, subplot(235));
            fg = MyFigure(f, subplot(236));
            % use time window
            obj.plot_ica_signal(fa)
            obj.plot_ica_compressive(fb)
            obj.plot_interval_overall_scalp(fc)

            obj.plot_wavelet(fd)
            obj.plot_wavelet_frequency(fe)
            obj.plot_wavelet_energy_bar(fg)
            frame = getframe(f);
            close(f)
        end

        function g = make_a_movie(obj, time_slots, interval, component, name)
            % one should save the name of the frames as curmovie 
            obj.use_component(component);
            total_frames = length(time_slots);
            for frame = 1:total_frames
                obj.use_time_window(time_slots(frame), interval);
                g(frame) = obj.make_a_frame();
            end
            obj.curmovie = g;
            curmovie = g;
            save([obj.data_path, '/', name], 'curmovie','-v7.3' );
        end

        function load_movie(obj, movie_frames)
            obj.curmovie = movie_frames;
        end

        function play_movie(obj)
            implay(obj.curmovie, 2)
            set(findall(0,'tag','spcui_scope_framework'),'position',[100 100 1500 1000]);
        end
        %% multichannel analysis

        
        function [ica_mat, mytitle, raw_mat] = raw_data_chunks(obj)% begin_time, end_time, window_length, step_size)
            begin_time = 200;
            end_time= 700;
            window_length = 2;
            step_size = 1;

            window_vec = begin_time + step_size : step_size : end_time - window_length;

            [ica_vec, raw_vec] = obj.use_window_data(begin_time, window_length);
            % column vector data
            ica_mat = ica_vec(:);
            raw_mat = raw_vec(:);
            for t = window_vec
                [ica_vec, raw_vec] = obj.use_window_data(t, window_length);
                % column vector data
                ica_mat = [ica_mat, ica_vec(:)];
                raw_mat = [raw_mat, raw_vec(:)];
                % vertical staking
            end
            ica_mat = ica_mat';
            raw_mat = raw_mat';
            mytitle =sprintf(' data %.1f: %.2f: %f with window length %d', begin_time, step_size, end_time, window_length);
        end


        %%pca
        function plot_pca(obj, data_mat, mytitle)
            [U,S,V] = svd(data_mat);
            f = figure();

            pca_coordinates = data_mat * V(:, 1:3);
            fa = MyFigure(f, subplot(131));
            fa.use_figure();
            scatter(pca_coordinates(:,1), pca_coordinates(:,2))
            fb = MyFigure(f, subplot(132));
            fb.use_figure()

            scatter3(pca_coordinates(:, 1), pca_coordinates(:, 2), pca_coordinates(:, 3));
            fc = MyFigure(f, subplot(133));
            fc.use_figure()
            bar(diag(S))
            title(mytitle)
            % ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0 
            % 1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
            % text(0.5, 1,sprintf('%.1f: %.2f: %f with window length %d', begin_time, step_size, end_time, window_length),'HorizontalAlignment','center','VerticalAlignment', 'top')
            % % title(sprintf('%.1f: %.2f: %f with window length %d', begin_time, step_size, end_time, window_length))
        end

        function normalize_channels(obj)
            obj.raw_data = row_mean_std_normalization(obj.raw_data);
            obj.ica_data = row_mean_std_normalization(obj.ica_data);
        end
    end
end
