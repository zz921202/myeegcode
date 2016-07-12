myeegcode_dir = '/Users/Zhe/Documents/seizure/myeegcode';
% addpath(myeegcode_dir)
% 
% tmp_folder = [myeegcode_dir, '/tmp/mit'];
% 
% 
% all_files = {'03', '04','21' , '16', '18', '21',  '13','26','15' , '46', '10', '11'};
% 
% for file_ind  = 1
%     load([tmp_folder all_files{file_ind}]);
%     studies(file_ind) = mit
% end
% c = EEGLearning();
% c.set_study(studies);
% c.sup_learning('SVM',[1]);
% c.test_sup_learner([3,4]);

% matlabpool open
% vidya = [myeegcode_dir, '/processed_data/Vidya_june_6_Data/'];
% all_files = {'faster_1639.set',
%              'faster_1645.set',
% %              'faster_1610.set',
% %              'faster_1611.set',
% %              'faster_1626.set',
% %              'faster_1630.set',
% %              'faster_1636.set',
% %              'faster_1637.set',
%              };
% for idx  = 1 : length(all_files)
%     filename = all_files{idx};
%     dd = EEGStudyEmotiv();
%     file_dir = [vidya, filename];
%     disp(['...... importing', file_dir, '......']);
%     dd.import_data(file_dir, filename);
%     disp('....extracting features.....');
%     dd.set_window_params(2, 0.5, 'EEGWindowGardnerEnergy');
% 
%     disp('..............')
%     studies(idx) = dd;
% end
% cg = EEGLearning();
% cg.set_study(studies);
% cfreq.plot_temporal_evolution(1 : length(all_files));
% matlabpool close