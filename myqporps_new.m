function all_energy =myqporps_new(y,xvec, Fs, plot_flag,vtype)

%   qprop()
%
%   quickly plot the basic properties of a signal, y.
%
%   USAGE:  qprop(y,q,w);
%
%   INPUT:  y is the original signal
%
%           q is a structure from qwave()
%
%           w is a structure from mkwobj()
%
%           vtype is what to do with 3D coefficents (i.e., more than one
%           channel or observation).  The default is a simple average, but
%           we can also choose coherene and power.
%           Input for vtype is a string:
%
%               'avg' | 'coh' | 'pow'
%
%   OUTPUT: is a figure with the signal properties

% Copyright (C) 2014 Phillip M. Gilley.  % This program is free software:
% you can redistribute it and/or modify it under the terms of the GNU
% General Public License as published by the Free Software Foundation,
% either version 3 of the License, or (at your option) any later version.
% This program is distributed in the hope that it will be useful, but
% WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
% Public License for more details. You should have received a copy of the
% GNU General Public License along with this program. If not, see
% http://www.gnu.org/licenses/.
parpath = fileparts(pwd);
ndtools_path = [parpath '/ndtools/ndtools'];
addpath(ndtools_path);
pnts = length(y);

w=mkwobj('morl',pnts,Fs);
q=qwave(y,w);


if nargin<5
    vtype='avg';
end

if ndims(q.cfs)==3
    
    % average the cwt
    switch vtype
        case 'avg'
            q.cfs=squeeze(mean(q.cfs,1));
            t3='Mean of Raw Coefficients';
            t4='Energy Normalized Mean Coefficients';
        case 'coh'
            q.cfs=squeeze(mean(q.cfs./abs(q.cfs),1));
            t3='Inter-trial Coherence';
            t4='Energy Normalized Coherence';
        case 'pow'
            q.cfs=squeeze(mean(abs(q.cfs),1)).^2;
            t3='CWT Band Power';
            t4='Energy Normalized Band Power';
    end
    
    % average the signal
    y=mean(y);
    
    % make some title labels
    t1='Mean of Signals';
    t2='Spectrum of Signals Mean';
    
else
    t1='Signal';
    t2='Spectrum';
    t3='Raw Coefficients';
    t4='Energy Normalized Coeffficients'; 

end

% normalize to scale energy
nq=qnrg(q,w);
normcfs=nq.cfs;

% normalize to time energy
tq=qnrg(q,w,'m');

z0=sum(real(tq.cfs),1);
z0=z0./max(abs(z0(:)));

z1=sum(abs(nq.cfs),2);
z2=sum(abs(q.cfs),2);
mx=max(abs([z1(:);z2(:)]));
z1=z1./mx;
z2=z2./mx;

% subplot(3,2,3);
% qsurf(w.cF,1:length(y),q.cfs);
% xlabel('points');
% ylabel('Frequency (pHz)');
% title(t3);
if strcmp(plot_flag,'wavelets')
    if ~strcmp(vtype,'coh')
        % subplot(3,2,4);
        qsurf(w.cF,xvec,normcfs);
        xlabel('points');
        ylabel('Frequency (pHz)');
        title(t4);
    end
end



if strcmp(plot_flag,'frequency')
    plot(z2);
    plot(z1,'r');
    xlabel('Frequency (Hz)');
    ylabel('Magnitude');
    title('Normalized Frequency Magnitudes');
    axis tight;
    ylim([0 1.05]);
    return
end

band_cutoffs = [1, 4, 8, 12, 32, 60];
band_labels = {'Delta', 'Theta', 'Alpha', 'Beta', 'Gamma'};
numbands = length(band_cutoffs) - 1;
all_energy = zeros( numbands,1 );
for i = 1 : numbands
    cur_start = band_cutoffs(i);
    cur_end = band_cutoffs(i + 1);

    all_energy(i) = sum(z1(cur_start: cur_end-1));
end
if strcmp(plot_flag,'energy_bar')
    bar(all_energy)
    title('energy by frequency band')
    set(gca, 'XTickLabel', band_labels)
    return
end