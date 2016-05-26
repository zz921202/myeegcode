parpath = fileparts(pwd);
% set(0,'DefaultFigureVisible','off')
addpath([parpath '/eeglab']);
file_path = pwd;
eeglab
readings_file = 'juarez_7_15_2015_readings_file.txt';
channel_file = 'juarez_channels.ced';
dataset_name = 'Juarez';


eeglab;
filename = readings_file;
datasetname = dataset_name;
channelfile = channel_file;
band_cutoffs = [1, 4, 8, 12, 32, 60];

% Read data from file 

EEG_rej = pop_loadset('Juarez_rejected.set');
c = EEG_rej;
epoch_len = 500;
num_trials = 100;
graph_dir = '/graphs_try/';

% for i = 1:14
%     v = double(EEG_rej.data(i,:));
%     activation  = EEG_rej.icaweights * EEG_rej.icasphere *   EEG_rej.data;
%     ac = double(activation(i,:));
% 
%     plot_cwt(v, [pwd graph_dir  num2str(i)])
%     figure('visible','off')
%     compsensing(v, num_trials, epoch_len)
%     hold on
%     compsensing(ac, num_trials, epoch_len)
%     legend('raw 1st compoent', 'ica 1st compoenent')
%     title(['Compressive Sensing Component' num2str(i)] )
%     print([pwd graph_dir 'comp_sen_' num2str(i)], '-dpdf')
%     figure('visible','off');
%     pop_topoplot(EEG_rej,0, i,'Juarez_rejected',[1 1] ,0,'electrodes','on');
%     print([pwd graph_dir 'ica_' num2str(i)], '-dpng')
% end