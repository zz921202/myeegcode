c = MyEEG();
c.set_name('Juarez')
c.load_set('Juarez_rejected.set')

% need to test load raw as well

% test all get functions, they are so simple, so I guess it is unnecessary
interval = 2;
time_slots = 300 :0.5: 600;
for i = 6:14
    g = c.make_a_movie(time_slots, interval, i, ['movie', num2str(i)]);
end
% c.play_movie()

% for frame = 1:total_frames
%     c.use_time_window(time_slots(frame), interval);
%     g(frame) = c.make_a_frame();
% end
% set(0,'DefaultFigureVisible','on')
% % implay(g,2)
% % set(findall(0,'tag','spcui_scope_framework'),'position',[100 100 1500 1000]);
% save('hi', g)
