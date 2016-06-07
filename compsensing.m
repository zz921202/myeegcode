function loss_mean = compsensing(v , num_trials, epoch_len, opt1)
% opt1 is used to set the number of compression ratio to be used

% Experiment demo for the first EEG experiment in: 
%   Zhilin Zhang, Tzyy-Ping Jung, Scott Makeig, Bhaskar D. Rao, 
%   Compressed Sensing of EEG for Wireless Telemonitoring with Low Energy 
%   Consumption and Inexpensive Hardware, accepted by IEEE Trans. on 
%   Biomedical Engineering, 2012
%
% This demo file shows the ability of BSBL-BO to recover signals which are
% non-sparse in the time domain or in any transformed domain
%
% Author: Zhilin Zhang (zhangzlacademy@gmail.com)
% Date  : Sep 12, 2012

% input:
    % v vector of data from one channel
    % numtrials: number of repeats
    % epoch_len: length of one "epoched" data   


CompSensing_path = [pwd '/CompSensing'];
addpath(CompSensing_path);
tot_len = length(v);
if tot_len == epoch_len
    X = zeros(num_trials, epoch_len); 
    for i = 1: num_trials
        X(i,:) = v;
    end
else

    samples = randi(tot_len - epoch_len   , [num_trials, 1]);
    % given matrix X, modified return the error as measured by MSE for all compression rate
    % every row of x is an epoch data 
    X = zeros(num_trials, epoch_len); 
    % inefficient implementation, waste memory, but whatever
    index = 0;

    for sample = samples' % generate all data for BSBD
        index = index + 1;
        X(index,:) = v(sample : sample + epoch_len-1);        
    end
end
[nrow, N] = size(X);
if nargin == 4
    compre_per = 1./ opt1;
else
    compre_per = 1./ (2:6) ;
end




load Phi;
Phi = create_Phi(N,N, floor(N * 0.0953));


mse_loss = zeros(1, length(compre_per));
compre_index = 0;
    
for r = compre_per
    compre_index = compre_index + 1;
    M = round(N * r);

 



    count = 0;
  % channel number
    for ep = 1 : nrow     % epoch number
        % We use DCT dictionary matrix
        A=zeros(M,N);
        cur_Phi = zeros(M,N);
        for k=randi(N, 1,M)
            A(k,:)=dct(Phi(k,:));
            cur_Phi(k, :) = Phi(k,:);
        end
        
        ch = 1;
        count = count + 1;

        x = X(ep,:)';
    
    % compress an epoch
        y = cur_Phi * double(x);
    
    
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %             use  BSBL-BO to recover
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        blkLen = 25;                  % the block size in the user-defined block partition
        groupStartLoc = 1:blkLen:N;   % user-defined block partition
    
        % run the algorithm
        tic;
        Result1 = BSBL_BO(A,y,groupStartLoc,0,'prune_gamma',-1, 'max_iters',7);
        t_bsbl = toc;
        
        % restore recovered data
        recon_EEG(ch,1:N,ep) = (idct(Result1.x))';  
    
        % MSE
        mse_lose(ep, compre_index) = (norm(x - recon_EEG(ch,1:N,ep)','fro')/norm(x,'fro'))^2;
        mse_bsbl = (norm(x - recon_EEG(ch,1:N,ep)','fro')/norm(x,'fro'))^2;

        fprintf('BSBL-BO: time: %4.3f, MSE: %5.4f \n',t_bsbl, mse_bsbl);
        

    end
end


loss_mean = mean(mse_lose , 1);
loss_std = 1.959964 * std(mse_lose, 1) / sqrt(nrow);

% errorbar(1:10, loss_mean, loss_std);


% xlabel('compression ratio')
% ylabel('compression loss (MSE)')
% title('compressive sensing')

