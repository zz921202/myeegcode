for i = 1:8
    curstudy = vid.EEGStudys(i)
    curstudy.gen_feature_matrix
%     for win  = curstudy.data_windows
%         win.feature = win.feature * 2;
%         win.flattened_feature= win.flattened_feature * 2;
%     end
end