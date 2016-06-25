cf.plot_temporal_evolution(7:8)
time_stamps = [89, 114, 139, 182, 317, 330, 516,  674, 660]

for curtime = time_stamps
    
    for offset = 0
        time = curtime + offset;

        curwin = windows(time);
        curwin.plot_raw_feature();
        title(['at' num2str(time)]);
    end
    % w = input('press to continue');
end

cf.EEGStudys(1).EEGData.raw_electrodes;