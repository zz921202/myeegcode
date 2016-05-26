%Author: Osama Ullah Khan,
%        Phd Student, University of Michigan-Ann Arbor.
%        Email: oukhan@umich.edu
%        Version: 1.0
%
%This code demonstrate compressive sensing example. In this
%example the signal is sparse in frequency domain and random samples
%are taken in time domain.

close all;
clear all;

%setup path for the subdirectories of l1magic
parpath = fileparts(pwd);
l1opt_path = [parpath '/l1magic']
addpath(l1opt_path);

addpath([l1opt_path '/Optimization']);
addpath([l1opt_path '/Data']);

N=500;
ratio = 1:10; %N/K is the corresponding compression ratio

M = dlmread('juarez_7_15_2015_readings_file.txt');
%length of the signal

x_front = M(1:N, :);
%Number of random observations to take
x = mean(x_front, 2);
x = (x - mean(x));
x = x/std(x);
x = x';

% %Discrete frequency of two sinusoids in the input signal
% K = 1:10:100
% 
% n=0:N-1;
% 
% %Sparse signal in frequency domain.
% x = zeros(1,N)
% for k = K
%     x = x + sin(2*pi*(k/N)*n)
% end

l2_loss = zeros(1,10)
for r = ratio
    K = N/r;


    %creating dft matrix
    B=dftmtx(N);
    Binv=inv(B);

    %Taking DFT of the signal
    xf=B*x';

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
    l2_loss(r) = norm(x(:) - xprec(:)) / norm(x);
end
plot(ratio, l2_loss)
xlabel('compression ratio')
ylabel('compression loss (l2 distance ratio)')
title('Compressive Sensing on random vector')
