function[EEG] = LoadEEGData(readings_file, dataset_name, channel_file, out_put_dir)
    
    filename = readings_file;
    datasetname = dataset_name;
    file_path = out_put_dir;
    mkdir(file_path);
    band_cutoffs = [1, 4, 8, 12, 32, 60];

    % Read data from file 
    M = dlmread(filename); 
    M = M';
    M = row_mean_std_normalization(M);

    % Import data from array into EEGlab, and properly set data properties
    EEG = pop_importdata('dataformat','array','nbchan', 0,'data',M ,'srate', [128], 'pnts', 0,'xmin',0);
    EEG.setname=strcat(datasetname, '_raw');
    EEG = eeg_checkset( EEG );
    EEG.chanlocs = readlocs(channel_file);
    EEG = eeg_checkset( EEG );
    EEG = pop_saveset( EEG, 'filename', strcat(EEG.setname, '.set'),'filepath',file_path);
    

    % Filter data to include only above lowest frequency cutoff, and run initial ICA
    EEG.setname = strcat(datasetname, '_filtered');
    EEG = pop_eegfiltnew(EEG, band_cutoffs(1), band_cutoffs(length(band_cutoffs)), 424, 0, [], 0);
    EEG = eeg_checkset( EEG ); % i applied upper limit to band curtoffs
    EEG = pop_runica(EEG, 'extended',1,'interupt','on');
    EEG = eeg_checkset( EEG );
    EEG = pop_saveset( EEG, 'filename',strcat(EEG.setname, '.set'),'filepath',file_path);
    EEG = eeg_checkset( EEG );

    % Autoreject regions of data and run ICA again
    EEG.setname=strcat(datasetname, '_rejected');
    EEG = pop_rejcont(EEG, 'elecrange',[1:14] ,'freqlimit',[20 40] ,'threshold',10,'epochlength',0.5,'contiguous',4,'addlength',0.25,'taper','none');
    EEG = eeg_checkset( EEG );
    EEG = pop_runica(EEG, 'extended',1,'interupt','on');
    EEG = eeg_checkset( EEG );
    EEG = pop_saveset( EEG, 'filename', strcat(EEG.setname, '.set'),'filepath',file_path);
    EEG = eeg_checkset( EEG );

%     % Plot band frequencies
%     for i = 1:length(band_cutoffs)-1
%         DispBand(EEG, band_cutoffs(i), band_cutoffs(i + 1))
%         savefig([file_path '/Juarez_graph/' num2str(band_cutoffs(i)) '~' num2str(band_cutoffs(i+1))])
%     end

end