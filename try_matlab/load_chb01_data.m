myeegcode_dir = '/Users/Zhe/Documents/seizure/myeegcode';
addpath(myeegcode_dir)


file_dir = [myeegcode_dir, '/processed_data/CHB_MIT_01_Data'];

all_files = {'01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24', '25', '26', '27'}
% all_files = {'02'};
seizure_time_file = [3, 4, 15, 16, 18, 21, 26];

seizure_times = [2996, 3036;
                1467, 1494; 
                1732, 1772; 
                1015, 1066;
                1720, 1810;
                327, 420;
                1862, 1963;];
% matlabpool open
for ind = 1: length(all_files)

    filenum = all_files{ind};

    if ismember(str2num(filenum),seizure_time_file)
        seizure_time = seizure_times(find(str2num(filenum) == seizure_time_file), :);
    else
        seizure_time = [0, 0];
    end

    filename = [file_dir, '/chb01_', filenum, '_raw.set'];
    disp(['.......processing.......' filename]);
    mit = EEGStudyInterface();
    mit.import_data(filename, filenum, seizure_time);
%     mit.set_window_params(2, 1, 'EEGWindowBandCoherence');
    mit.set_window_params(2, 1, 'EEGWindowBandAmplitude')
    mit.plot_temporal_evolution()
    mit
    studies(ind) = mit
end
% matlabpool close 

c = EEGLearning();
c.set_study(studies);
