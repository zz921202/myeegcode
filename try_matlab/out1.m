cg.pca(7:8)
cg.plot_temporal_evolution(7:8)

cg.k_means(2, 7:8)
cg.EEGStudys(1).EEGData.raw_electrodes()
% all_files = {'faster_1610.set',
%              'faster_1611.set',
%              'faster_1626.set',
%              'faster_1630.set',
%              'faster_1636.set',
%              'faster_1637.set',
%              'faster_1639.set',
%              'faster_1645.set'};

% for idx  = 1 : length(all_files)
%     filename = all_files{idx};
%     c.EEGStudys(idx).EEGData.dataset_name = filename
% end