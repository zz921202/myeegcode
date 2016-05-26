function plot_cwt(v, path_to_save)
parpath = fileparts(pwd);
ndtools_path = [parpath '/ndtools/ndtools'];
addpath(ndtools_path);
vec_len = length(v);
v = v(:);
% Sampling rate
Fs=128;
% Number of points (for 1 second)
pnts=300;
num_samples = 100;

all_energy = zeros(num_samples,5);
for i = 1:num_samples


    
    
    start = randi(vec_len - pnts); % Generate the signal
    y= v(start: start + pnts);

    % make wavelet object
    w=mkwobj('morl',pnts,Fs);
    % compute CWT
    q=qwave(y,w);
    % visualize results
    all_energy(i,:) = myqprops(y,q,w, false)';

end
figure('visible','off');
myqprops(y,q,w, true);

print([path_to_save 'cwt'], '-dpng')
band_labels = {'Delta', 'Theta', 'Alpha', 'Beta', 'Gamma'};
figure('visible','off');
boxplot(all_energy)

% figure;
% bar(all_energy)
% title('energy by frequency band')
set(gca, 'XTickLabel', band_labels)
print([path_to_save 'energy_band'], '-dpdf')
