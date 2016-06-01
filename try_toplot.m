% A = [1  -1.5  0.7];
% B = [0 1 0.5];
% m0 = idpoly(A,B);
% u = iddata([],idinput(300,'rbs'));
% e = iddata([],randn(300,1));
% y = sim(m0,[u e]);
% z = [y,u];
% m = arx(z,[2 2 1]);

% windows = [200:200:2500, 2980:10:3040, 3040:50:3400];
for window = 100
    figure
    cur_data = c.data_windows(window).raw_feature;
    L = 512;
    Fs = 256;
    NFFT = 2^nextpow2(L); % Next power of 2 from length of y
    Y = fft(cur_data,NFFT, 2)/L;

    f = Fs/2*linspace(0,1,NFFT/2+1);
    Y_sub = filter(1/20 * ones(1,20), 1, Y, [], 2);
    % Plot single-sided amplitude spectrum.
    plot(f,2*abs(Y_sub(:,1:NFFT/2+1)))

    title(['Single-Sided Amplitude Spectrum of y(t) at ' num2str(window)])
    xlabel('Frequency (Hz)')
    ylabel('|Y(f)|')
end

% low_cutoff = 1;
% high_cutoff = 10;
% test_cond = @(freq) and(freq >= low_cutoff, freq < high_cutoff);
% x = [(-10:20)', (-10:20)'];
% indicator = arrayfun(test_cond,x(:, 1));
% energies = x(:, 2)
% power = sum(energies(indicator)) / (high_cutoff - low_cutoff)