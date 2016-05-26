

set(0,'DefaultFigureVisible','off')
for j = 1:loops
    fig = figure('position', [100, 100, 600, 600]);
    topoplot(activation(:, j* 1000), EEG_rej.chanlocs);
    
    title(['frame' num2str(j)])

    g(j) = getframe(fig);
end
set(0,'DefaultFigureVisible','on')
implay(g,2)
set(findall(0,'tag','spcui_scope_framework'),'position',[150 150 1000 800]);