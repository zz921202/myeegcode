function [] =plot_compression(v, mytitle)
%input a data vector of arbitrary length 

parpath = fileparts(pwd);
l1opt_path = [parpath '/l1magic']
addpath(l1opt_path);

addpath([l1opt_path '/Optimization']);
addpath([l1opt_path '/Data']);

% v = zeros(10000,1);
% v = M(1:10000, 1);
v = v(:);
N = 100; % sample data length
NumSample = 40;

vec_len = length(v);
compre_per = 0.1 : 0.1 :1 ;
data_matrix = zeros(NumSample, length(compre_per));
index = 0;
samples = randi(vec_len - N  , [NumSample, 1]);
for sample = samples'
    index = index + 1;


    x = v(sample : sample + N-1);
    x = (x - mean(x));
    x = x/std(x);
   

    l2_loss = zeros(1, length(compre_per));
    compre_index = 0;
    
    for r = compre_per
        compre_index = compre_index + 1;
        K = round(N * r);


        %creating dft matrix
        B=dftmtx(N);
        Binv=inv(B);

        %Taking DFT of the signal
        size(x)
        size(B)
        xf=B*x;

        %Selecting random rows of the DFT matrix
        q=randperm(N);

        %creating measurement matrix
        A=Binv(q(1:K),:);

        %taking random time measurements
        y=(A*xf);

        %Calculating Initial guess
        x0=A'*y;

        %Running the recovery Algorithm
        tic
        xp=l1eq_pd(x0,A,[],y,1e-5);
        toc

        %recovered signal in time domain
        xprec=real(Binv*xp); % recovered signal 
        l2_loss(compre_index) = norm(x(:) - xprec(:)) / norm(x);
    end

    data_matrix(index,:) = l2_loss;
end

loss_mean = mean(data_matrix , 1);
loss_std = 1.959964 * std(data_matrix, 1) / sqrt(NumSample);
errorbar(compre_per, loss_mean, loss_std)

xlabel('compression ratio')
ylabel('compression loss (l2 distance ratio)')
title(mytitle)
end

