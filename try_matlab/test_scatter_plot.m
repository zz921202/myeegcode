x = linspace(0,3*pi,200);
y = cos(x) + rand(1,200);

c = linspace(0,1,length(x));
c(1:70) = linspace(0,1, 70);
c(71:130) = linspace(2,2, 60);
c(131: 200) = 3 + linspace(0,1, 70);

% x,y, size, color
scatter(x,y,50,c, 'filled')

