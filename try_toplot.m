% A = [1  -1.5  0.7];
% B = [0 1 0.5];
% m0 = idpoly(A,B);
% u = iddata([],idinput(300,'rbs'));
% e = iddata([],randn(300,1));
% y = sim(m0,[u e]);
% z = [y,u];
% m = arx(z,[2 2 1]);



% y = sin([1:300]') + 0.5*randn(300,1);
% y = iddata(y);
% mb = ar(y,4,'burg');
% mfb = ar(y,4);
% 
% stem(resid(mb, y))
% close all
% figure()
% topoplot([], cc.EEGData.curEEG.chanlocs, 'style','blank','electrodes','numbers', 'chaninfo',curEEG.chaninfo ...
% ,'emarker', {'.','k',[],1});

% f = EEG();
% f.chanlocs = c.chanlocs;
% f.srate = '128';
% f.trials = 1;
c = EEGDataInterface;
c.pop_load_set()
M = c.raw_data; % matrix 
f = LoadEEGDataMatlab(M, 'fffuck', 'emotive_channel_info.ced', 128, 0);
curEEG = c.curEEG;
f.data = c.raw_data;
f.icaact = c.ica_data;
f.icawinv = c.curEEG.icawinv;
f.icasphere = c.curEEG.icasphere;
f.icaweights = c.curEEG.icaweights;
EEG = f;
