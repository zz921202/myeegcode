%-- 5/15/16, 4:50 PM --%
% set all parameters for using sift with GUI

parpath = fileparts(pwd);
addpath([parpath '/eeglab']);
eeglab;
EEG = pop_loadset();
% eeglab redraw
[EEG, cfg] = pop_pre_prepData(EEG)
save('./sift_opt/prepdata', 'cfg')
[EEG, cfg] = pop_est_fitMVAR(EEG)
save('./sift_opt/fitMVAR', 'cfg')
[EEG, cfg] = pop_est_validateMVAR(EEG)
save('./sift_opt/validateMVAR', 'cfg')
[EEG, cfg] = pop_est_mvarConnectivity(EEG)
save('./sift_opt/mvarConnectivity', 'cfg')

EEG = pop_dipfit_settings(EEG)
EEG = pop_dipfit_gridsearch(EEG)
pop_vis_TimeFreqGrid(EEG)