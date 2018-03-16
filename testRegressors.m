% Test impact of regressors and scaling on beta estimation.
%
% Requires glm.m and t2p.m (from Rik Henson), and SPM
%
% Jonathan Peelle
% First version: March 2018


close all
clear all


noiseScale = 0.5;

badScans = [20];


%% generate data

% (This could be random data but I'm just adding noise to a simple function
% so that it looks sort of like a block design fMRI study...)

boxCar = repmat([zeros(8,1); ones(5,1)], 4, 1);
Y = boxCar + noiseScale*randn(length(boxCar),1)
t = 1:length(Y);

figure
plot(t, boxCar, 'k-');
hold on
plot(t, Y, 'r-');
xlabel('x')
ylabel('y')
title('Data (and the boxcar function it''s based on)')


%% generate models X{1} = model 1, titleText{1} = title for model 1...

%---- model 1

X{1} = ones(length(boxCar), 2);
X{1}(:,1) = boxCar;

% Fit GLM
[t,F,p,R2,B] = glm(X{1}, Y, [1 0], 0);
Yhat = X{1}*B;
resids = Y - Yhat;

titleText{1} = sprintf('Model 1: predictor of interest (beta1 = %.3f, resids = %.3f)', B(1), mean(resids));



%---- model 2: model out some weird scans

X{2} = ones(length(boxCar), 3);
X{2}(:,1) = boxCar;
X{2}(:,2) = 0;
X{2}(badScans,2) = 1;

% Fit GLM
[t,F,p,R2,B] = glm(X{2}, Y, [1 0 0], 0);
Yhat = X{2}*B;
resids = Y - Yhat;

titleText{2} = sprintf('Model 2: badScans (beta1 = %.3f, resids = %.3f)', B(1), mean(resids));



%---- model 3: model out some weird scans, but not with 0/1

X{3} = X{2};
X{3}(:,2) = X{3}(:,2) + 1;

% Fit GLM
[t,F,p,R2,B] = glm(X{2}, Y, [1 0 0], 0);
Yhat = X{3}*B;
resids = Y - Yhat;

titleText{3} = sprintf('Model 3: badScans (non binary) (beta1 = %.3f, resids = %.3f)', B(1), mean(resids));



%---- model 4: same model, but add noise to the weird time point

YY = Y;
YY(badScans) = 1000000;

X{4} = X{2};

% Fit GLM
[t,F,p,R2,B] = glm(X{2}, Y, [1 0 0], 0);
Yhat = X{4}*B;
resids = Y - Yhat;

titleText{4} = sprintf('Model 4: same model, spike data (beta1 = %.3f, resids = %.3f)', B(1), mean(resids));







%% Plot all the models

figure
for mInd = 1:length(X)
   subplot(1, length(X), mInd);
   imagesc(X{mInd});
   title(titleText{mInd});
    colormap bone
    
    
end






