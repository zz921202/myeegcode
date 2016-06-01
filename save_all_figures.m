h = get(0,'children');
for i=1:length(h)
  saveas(h(i), [pwd '/test_MIT_Data/' 'figure' num2str(i)], 'fig');
end