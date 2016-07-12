
save_to_dir = 'chb01_band_amp'
mkdir('chb01_band_amp')

%% to save
% curlearn = c
% counter = 1
% for study = curlearn.EEGStudys
%     file_name = [save_to_dir '/' num2str(counter)]
%     save(file_name, 'study')
%     counter = counter + 1
% end


%% to load
tot_num_files = 27;

d = EEGLearning();

for ind = 1: tot_num_files
    ind
    file_name = [save_to_dir '/' num2str(ind)];
    load(file_name);
    studies(ind) = study;
end
d.set_study(studies)
