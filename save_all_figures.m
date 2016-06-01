h = get(0,'children');
for i=1:length(h)
  saveas(h(i), [pwd '/exam_graphs/' 'figure' num2str(i)], 'fig');
end