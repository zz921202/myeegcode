% mannually set parallel parameters

% mit = EEGStudyInterface();
% mit.import_data()

% t = tic;
% mit.set_window_params(2, 200, 'EEGWindowBandCoherence');
% disp(['single cost' num2str(toc(t))])

matlabpool open
t = tic;
mit.set_window_params(2, 200, 'EEGWindowBandCoherence');
disp(['parallel cost' num2str(toc(t))])
matlabpool close 