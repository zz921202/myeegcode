%% load MIT data

% c = EEGDataMIT()
% c.set_data_file('/Users/Zhe/chb01', '/chb01_03.edf')
% c.set_name('test_MIT')

%% load emotiv raw data

% c = EEGDataInterface()
% c.set_name('Vidya_june_3_1','Vidya_june_3_1')
% c.load_raw('/Users/Zhe/Documents/seizure/myeegcode/raw_data/1/2016-06-03_14:45:57.762702-epoc-recording.dat')

%% eyeballing emotiv raw


c = EEGDataInterface();
c.set_name('short','Juarez');
reading_file = '/Users/Zhe/Documents/seizure/myeegcode/raw_data/Juarex_July_15/Juarez_short.txt';
c.faster_load_raw(reading_file);

%% load Vidya data
% c = EEGDataInterface();
% c.set_name('1630','Vidya_june_6');
% reading_file = '/Users/Zhe/Documents/seizure/myeegcode/raw_data/Vidya_june_6/1630_reading.txt';
% c.faster_load_raw(reading_file);

