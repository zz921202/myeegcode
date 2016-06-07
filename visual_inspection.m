reading_file = '/Users/Zhe/Documents/seizure/myeegcode/raw_data/Vidya_june_6/1630_reading.txt';
% reading_file = '/Users/Zhe/Documents/seizure/myeegcode/raw_data/Juarex_July_15/juarez_7_15_2015_readings_file.txt';
M = dlmread(reading_file); 
M = M';
M = row_mean_std_normalization(M);

eegplot(M, 'srate', 128);
figure
plot(M(:, 1:300)')

% for row = 1: 14
%     figure
%     title(num2str(row))
%     plot(M(row, 1:300)');
% end