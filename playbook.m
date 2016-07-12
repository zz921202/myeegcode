%% load MIT data



all_files = { '01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24', '25', '26', '27'}
for ind = 1:length(all_files)
    file = all_files{ind}
    cur_name = ['chb01_' file]
    file_name = ['/' cur_name '.edf']
    c = EEGDataMIT()
    c.set_data_file('/Users/Zhe/chb01', file_name)
    c.set_name(cur_name, 'CHB_MIT_01')
    c.load_raw()
end
%% load emotiv raw data

% c = EEGDataInterface()
% c.set_name('Vidya_june_3_1','Vidya_june_3_1')
% c.load_raw('/Users/Zhe/Documents/seizure/myeegcode/raw_data/1/2016-06-03_14:45:57.762702-epoc-recording.dat')

%% eyeballing emotiv raw


% c = EEGDataInterface();
% c.set_name('short','Juarez');
% reading_file = '/Users/Zhe/Documents/seizure/myeegcode/raw_data/Juarex_July_15/Juarez_short.txt';
% c.faster_load_raw(reading_file);

%% load Vidya data

% all_files = {
% '1639_reading.txt',
% }
% c = EEGDataInterface();
% for ind = 1: length(all_files)
%     cur_name = all_files{ind};
%     short_name = cur_name(1:4);

%     c.set_name(short_name,'Vidya_june_6');
%     reading_file = ['/Users/Zhe/Documents/seizure/myeegcode/raw_data/Vidya_june_6/', cur_name];
%     c.load_raw(reading_file);
% end

