% parpath = fileparts(pwd);
% addpath([parpath '/eeglab']);
% eeglab;
% 
% EEG = pop_loadset();

% EEG = pop_dipfit_settings(EEG);
% EEG = pop_dipfit_gridsearch(EEG);

load('./sift_options/prepdata.mat')
EEG = pre_prepData('EEG', EEG, cfg);

load('./sift_options/fitMVAR.mat')
EEG.CAT.MODEL = est_fitMVAR('EEG', EEG, cfg);

load('./sift_options/validateMVAR.mat')
est_validateMVAR('EEG', EEG, cfg);

load('./sift_options/mvarConnectivity.mat')
EEG.CAT.Conn = est_mvarConnectivity('EEG', EEG, 'MODEL', EEG.CAT.MODEL, cfg);


