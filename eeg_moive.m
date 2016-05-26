pnts = eeg_lat2point([-100:10:600]/1000, 1, EEG.srate, [EEG.xmin EEG.xmax]);
% Above, convert latencies in ms to data point indices
figure; [Movie,Colormap] = eegmovie(EEG.data(:,128:1:192), EEG.srate, EEG.chanlocs, 0, 0);
seemovie(Movie,-5,Colormap);