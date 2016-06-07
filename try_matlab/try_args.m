function somefcn(arg1, opt1)
if nargin<2
    mystr = 'default';
else
    mystr = opt1;
end
disp(mystr)
end