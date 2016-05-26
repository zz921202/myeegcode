% subplot(1,2,1)
% % pop_topoplot(EEG_rej,0, 1,'Juarez_rejected',[1 1] ,0,'electrodes','on');
% subplot(1,2,2)
topoplot(activation(:, 5000), EEG_rej.chanlocs);