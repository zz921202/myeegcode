rng(0)
grnpnts = mvnrnd([2, 2 ,2],eye(3),100);
redpnts = mvnrnd([0, 0, 0],eye(3),100);

plot3(grnpnts(:,1),grnpnts(:,2), grnpnts(:, 3), 'go');
hold on
plot3(redpnts(:,1),redpnts(:,2),redpnts(:, 3), 'ro');
hold off

X = [grnpts;redpts];
grp = ones(200,1);
grp(101:200) = -1;
color_codes = grp;