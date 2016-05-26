%-- 5/15/16, 4:50 PM --%
% set all parameters for using sift with GUI

parpath = fileparts(pwd);
addpath([parpath '/eeglab']);
eeglab;
EEG = pop_loadset();
% eeglab redraw
[EEG, cfg] = pop_pre_prepData(EEG)
save('./sift_options/prepdata', 'cfg')
[EEG, cfg] = pop_est_fitMVAR(EEG)
save('./sift_options/fitMVAR', 'cfg')
[EEG, cfg] = pop_est_validateMVAR(EEG)
save('./sift_options/validateMVAR', 'cfg')
[EEG, cfg] = pop_est_mvarConnectivity(EEG)
save('./sift_options/mvarConnectivity', 'cfg')

EEG = pop_dipfit_settings(EEG)
EEG = pop_dipfit_gridsearch(EEG)
pop_vis_TimeFreqGrid(EEG)