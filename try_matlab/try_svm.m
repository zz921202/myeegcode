rng(1); % For reproducibility
r = sqrt(rand(100,1)); % Radius
t = 2*pi*rand(100,1);  % Angle
data1 = [r.*cos(t), r.*sin(t)]; % Points

r2 = sqrt(3*rand(100,1)+1); % Radius
t2 = 2*pi*rand(100,1);      % Angle
data2 = [r2.*cos(t2), r2.*sin(t2)]; % points

% visualization of example data
figure;
plot(data1(:,1),data1(:,2),'r.','MarkerSize',15)
hold on
plot(data2(:,1),data2(:,2),'b.','MarkerSize',15)
ezpolar(@(x)1);ezpolar(@(x)2);
axis equal
hold off


data3 = [data1;data2];
theclass = ones(200,1);
theclass(1:100) = -1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%fit svm model%%%%%%%%%%%%%%%%%%%%
for i = 3
    %%fit model
    box_constraint = 10 ^ i;
    %Train the SVM Classifier
    cl = fitcsvm(data3,theclass,'KernelFunction','rbf',...
        'BoxConstraint', box_constraint,'ClassNames',[-1,1]);

    %%cross_validation 
    cvcl = crossval(cl);
    misclass1 = kfoldLoss(cvcl);
    disp(['out of sample misclassification rate:' num2str(misclass1)])

    %% model visualization 
    % Predict scores over the grid
    d = 0.02;
    [x1Grid,x2Grid] = meshgrid(min(data3(:,1)):d:max(data3(:,1)),...
        min(data3(:,2)):d:max(data3(:,2)));
    xGrid = [x1Grid(:),x2Grid(:)]; % unroll the mesh grid vector
    [~,scores] = predict(cl,xGrid);

    % Plot the data and the decision boundary
    figure;
    h(1:2) = gscatter(data3(:,1),data3(:,2),theclass,'rb','.');
    hold on
    % ezpolar(@(x)1);
    h(3) = plot(data3(cl.IsSupportVector,1),data3(cl.IsSupportVector,2),'ko');
    contour(x1Grid,x2Grid,reshape(scores(:,2),size(x1Grid)),[0, 0]);  % row back the mesh grid vector
    legend(h,{'-1','+1','Support Vectors'});
    title(['box_constraint: ' num2str(box_constraint) 'val_err' num2str(misclass1)])
    axis equal
    hold off
end
close all

