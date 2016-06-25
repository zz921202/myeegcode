windows = [140 182];
cg7 = cg.EEGStudys(7);
cg7.EEGData.raw_electrodes;
cg7.plot_temporal_evolution;
% cfreq_7 = cfreq.EEGStudys(7);
for win = windows
    curwind = cg7.data_windows(win);
    figure
    curwind.plot_my_feature();
    title(['spike at' num2str(win)]);
    curwind.plot_raw_feature();
end