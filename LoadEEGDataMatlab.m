function[EEG] = LoadEEGDataMatlab(reading_matrix, dataset_name, channel_file, srate, opt1, opt2)

    % this differs from LoadEEGData in that it only takes in matlab matrix as record 
    % instead of .txt file
    % opt2 is built specifically for MIT data

    % input examples: reading_M, set_name, channel_file, srate, dir_to_save, MIT
    %                  reading_M, set_name, channel_file, srate
    %                   reading_M, set_name, channel_file, srate, 0 // used for faster only

    if nargin == 5
        EEG = pop_importdata('dataformat','array','nbchan', 0,'data',reading_matrix ,'srate', [srate], 'pnts', 0,'xmin',0);
        EEG.setname=strcat(dataset_name)
        EEG = eeg_checkset( EEG );
        EEG.chanlocs = readlocs(channel_file);
        EEG = eeg_checkset( EEG );
        return
    end



    datasetname = dataset_name;
    if opt1
        file_path = [pwd '/processed_data/' opt1 '_Data'];
        mkdir(file_path);
    else
        file_path = [pwd '/processed_data/' dataset_name '_Data'];
    end

    if opt2 == 'MIT'
        EEG = pop_importdata('dataformat','array','nbchan', 0,'data',reading_matrix ,'srate', [srate], 'pnts', 0,'xmin',0);
        EEG.setname=strcat(dataset_name, '_raw');
        EEG = eeg_checkset( EEG );
        EEG.chanlocs = readlocs(channel_file);
        EEG = eeg_checkset( EEG );
        EEG = pop_runica(EEG, 'extended',1,'interupt','on');

        EEG = pop_saveset( EEG, 'filename', strcat(EEG.setname, '.set'),'filepath',file_path);
        return
    end
    

    M = reading_matrix;
    M = row_mean_std_normalization(M);

    % Import data from array into EEGlab, and properly set data properties
    EEG = pop_importdata('dataformat','array','nbchan', 0,'data',M ,'srate', [srate], 'pnts', 0,'xmin',0);
    EEG.setname=strcat(dataset_name, '_raw');
    EEG = eeg_checkset( EEG );
    EEG.chanlocs = readlocs(channel_file);
    EEG = eeg_checkset( EEG );
    strcat(EEG.setname, '.set');
    EEG = pop_saveset( EEG, 'filename', strcat(EEG.setname, '.set'),'filepath',file_path);
    

    % Filter data to include only above lowest frequency cutoff, and run initial ICA
    EEG.setname = strcat(dataset_name, '_filtered');
    EEG = pop_eegfiltnew(EEG, band_cutoffs(1), band_cutoffs(length(band_cutoffs)), 424, 0, [], 0);
    EEG = eeg_checkset( EEG ); % i applied upper limit to band curtoffs
    EEG = pop_runica(EEG, 'extended',1,'interupt','on');
    EEG = eeg_checkset( EEG );
    EEG = pop_saveset( EEG, 'filename',strcat(EEG.setname, '.set'),'filepath',file_path);
    EEG = eeg_checkset( EEG );

    % Autoreject regions of data and run ICA again
    EEG.setname=strcat(dataset_name, '_rejected');
    EEG = pop_rejcont(EEG, 'elecrange',[1:14] ,'freqlimit',[20 40] ,'threshold',10,'epochlength',0.5,'contiguous',4,'addlength',0.25,'taper','none');
    EEG = eeg_checkset( EEG );
    EEG = pop_runica(EEG, 'extended',1,'interupt','on');
    EEG = eeg_checkset( EEG );
    EEG = pop_saveset( EEG, 'filename', strcat(EEG.setname, '.set'),'filepath',file_path);
    EEG = eeg_checkset( EEG );



end