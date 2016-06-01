A = [1  -1.5  0.7];
B = [0 1 0.5];
m0 = idpoly(A,B);
u = iddata([],idinput(300,'rbs'));
e = iddata([],randn(300,1));
y = sim(m0,[u e]);
z = [y,u];
m = arx(z,[2 2 1]);