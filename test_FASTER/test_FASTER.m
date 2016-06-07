% develop prototype for loading data with FASTER prepossessing capability
% to be integrated with EEGDataInterface
% because of this stupid design, I'm gonna use ====> temp_folder =====> desired folder and output_name


addpath(cd(cd('..')))
obj = EEGDataInterface
obj.set_name('test_FASTER', 'test_FASTER')

% Import data from array into EEGlab, and properly set data properties
myeegcode_path = '/Users/Zhe/Documents/seizure/myeegcode';
reading_file = [myeegcode_path, '/raw_data/Vidya_june3/reading_1.dat'];



channel_file = [myeegcode_path, '/emotive_channel_info.ced'];

%% generate a set data structure first
M = dlmread(reading_file); 
M = M';
M = M(:, 1:1024); % TODO  remove this for testing only
M = row_mean_std_normalization(M);

pre_file_path = [myeegcode_path, '/Faster_Processing/pre'];
EEG = pop_importdata('dataformat','array','nbchan', 0,'data',M ,'srate', [128], 'pnts', 0,'xmin',0);
EEG = eeg_checkset( EEG );
EEG.chanlocs = readlocs(channel_file);
EEG = eeg_checkset( EEG );
EEG = pop_saveset( EEG, 'filename', ['pre.set'],'filepath',[myeegcode_path, '/Faster_Processing/pre']);


%% process data put it into faster and replace the original set data

%% used to set options 
% FASTER_GUI 

%% use options
load([myeegcode_path, '/Faster_Processing/faster_options.mat'])
option_wrapper.options.channel_options.bad_channels = [5,8]
FASTER(option_wrapper)

% %% load the set into EEGDataInterface and save them

obj.curEEG = pop_loadset([myeegcode_path, '/Faster_Processing/post/pre.set']);
% save it to desired output
% mkdir(obj.data_path)
% pop_saveset( obj.curEEG, 'filename', [obj.dataset_name],'filepath', [myeegcode, '/test_FASTER']);

% % load EEGDataInterface
% obj = obj.extract_EEG_data();




%% visual comparison of processed data to original data



