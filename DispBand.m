function [] = DispBand( EEG, band_start, band_end )
%DISPBAND Summary of this function goes here
%   Detailed explanation goes here

figure_name = strcat(num2str(band_start), 'Hz - ', num2str(band_end), 'Hz');

figure('Name', figure_name); [spectrum, freqs] = pop_spectopo(EEG, 1, [EEG.xmin EEG.xmax]*1000, 'EEG' , 'percent', 100, 'freq', [band_start band_end]);
[~, minind] = min(abs(freqs-band_start));
[~, maxind] = min(abs(freqs-band_end));
alphaPower = mean(spectrum(:, minind:maxind),2);
figure('Name', figure_name); topoplot(alphaPower, EEG.chanlocs, 'maplimits', 'maxmin'); cbar;

end