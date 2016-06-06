%% load MIT data

% c = EEGDataMIT()
% c.set_data_file('/Users/Zhe/chb01', '/chb01_03.edf')
% c.set_name('test_MIT')

%% load emotiv raw data

% c = EEGDataInterface()
% c.set_name('test_Vidya2')
% c.load_raw('/Users/Zhe/Documents/seizure/myeegcode/raw_data/1/2016-06-03_14:45:57.762702-epoc-recording.dat')

%% eyeballing emotiv raw


c = EEGDataInterface();
c.set_name('Juarez');
reading_file = '/Users/Zhe/Documents/seizure/myeegcode/raw_data/Juarex_July_15/juarez_7_15_2015_readings_file.txt';
c.faster_load_raw(reading_file);