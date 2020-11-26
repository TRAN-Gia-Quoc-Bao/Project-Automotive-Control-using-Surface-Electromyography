%% sEMG signal classification using LSTM _ TRAN Gia Quoc Bao

%% Default commands
close all;
clear all;
clc;

%% Data
load LSTMData.mat;
% summary(Labels);
% We see that the data are not balanced so we perform oversampling
brakeX = Signals(Labels == 'brake');
brakeY = Labels(Labels == 'brake');

noBrakeX = Signals(Labels == 'noBrake');
noBrakeY = Labels(Labels == 'noBrake');

% 100
% [trainIndB, ~, testIndB] = dividerand(636, 0.9, 0.0, 0.1);
% [trainIndN, ~, testIndN] = dividerand(17180, 0.9, 0.0, 0.1);
% 1000
[trainIndB, ~, testIndB] = dividerand(60, 0.9, 0.0, 0.1);
[trainIndN, ~, testIndN] = dividerand(1708, 0.9, 0.0, 0.1);
% 500
% [trainIndB, ~, testIndB] = dividerand(125, 0.9, 0.0, 0.1);
% [trainIndN, ~, testIndN] = dividerand(3428, 0.9, 0.0, 0.1);

XTrainB = brakeX(trainIndB);
YTrainB = brakeY(trainIndB);

XTrainN = noBrakeX(trainIndN);
YTrainN = noBrakeY(trainIndN);

XTestB = brakeX(testIndB);
YTestB = brakeY(testIndB);

XTestN = noBrakeX(testIndN);
YTestN = noBrakeY(testIndN);
%%
% % Use the first 15444 with 572 x 27 
% XTrain = [repmat(XTrainB(1 : 572), 27, 1); XTrainN(1 : 15444)];
% YTrain = [repmat(YTrainB(1 : 572), 27, 1); YTrainN(1 : 15444)];
% % Use the first 1701 with 63 x 27 
% XTest = [repmat(XTestB(1 : 63), 27, 1); XTestN(1 : 1701)];
% YTest = [repmat(YTestB(1 : 63), 27, 1); YTestN(1 : 1701);];

% Use the first 1537 with 53 x 29 
XTrain = [repmat(XTrainB(1 : 53), 29, 1); XTrainN(1 : 1537)];
YTrain = [repmat(YTrainB(1 : 53), 29, 1); YTrainN(1 : 1537)];
% Use the first 168 with 6 x 28 
XTest = [repmat(XTestB(1 : 6), 28, 1); XTestN(1 : 168)];
YTest = [repmat(YTestB(1 : 6), 28, 1); YTestN(1 : 168);];

% Use the first 3085 with 110 x 28 
% XTrain = [repmat(XTrainB(1 : 110), 28, 1); XTrainN(1 : 3085)];
% YTrain = [repmat(YTrainB(1 : 110), 28, 1); YTrainN(1 : 3085)];
% % Use the first 338 with 13 x 26 
% XTest = [repmat(XTestB(1 : 13), 26, 1); XTestN(1 : 338)];
% YTest = [repmat(YTestB(1 : 13), 26, 1); YTestN(1 : 338);];

%oversampling
summary(YTrain)
summary(YTest)

%% LSTM
% Network architecture
layers = [ ...
    sequenceInputLayer(1, 'Name', 'Sequence input layer')
    bilstmLayer(100, 'OutputMode', 'last', 'Name', 'Bidirectional LSTM layer')
    fullyConnectedLayer(2, 'Name', 'Fully connected layer')
    softmaxLayer('Name', 'Softmax layer')
    classificationLayer('Name', 'Classification layer')
    ];
% lgraph = layerGraph(layers);
% figure;
% plot(lgraph);
% title('Structure of the LSTM network');
% set(gca, 'FontSize', 14);

options = trainingOptions('adam', 'MaxEpochs', 4, 'MiniBatchSize', 150, 'InitialLearnRate', 0.01, 'SequenceLength', 1000, 'GradientThreshold', 1, 'plots', 'training-progress', 'Verbose', false, 'ExecutionEnvironment', 'gpu');
%% Train
net = trainNetwork(XTrain, YTrain, layers, options);
trainPred = classify(net, XTrain, 'SequenceLength', 1000);
plotconfusion(YTrain', trainPred', 'Training Accuracy');

%% Test
testPred = classify(net, XTest, 'SequenceLength', 1000);
plotconfusion(YTest', testPred', 'Testing Accuracy');

%% Improve performance with feature extraction
fs = 1000;
brakeSample = Signals{1};
noBrakeSample = Signals{1000};

% figure;
% subplot(211);
% pspectrum(noBrakeSample, fs, 'spectrogram', 'TimeResolution', 0.01);
% title('NoBrake signal');
% set(gca, 'FontSize', 14);
% subplot(212);
% pspectrum(brakeSample, fs, 'spectrogram', 'TimeResolution', 0.01);
% title('Brake signal');
% set(gca, 'FontSize', 14);

[instFreqB, tB] = instfreq(brakeSample, fs);
[instFreqN, tN] = instfreq(noBrakeSample, fs);

% figure;
% subplot(211);
% plot(tN, instFreqN, 'LineWidth', 2);
% grid on;
% title('NoBrake signal');
% xlabel('Time (s)');
% ylabel('Instantaneous frequency');
% set(gca, 'FontSize', 14);
% subplot(212);
% plot(tB, instFreqB, 'LineWidth', 2);
% grid on;
% title('Brake signal');
% xlabel('Time (s)');
% ylabel('Instantaneous frequency');
% set(gca, 'FontSize', 14);

instfreqTrain = cellfun(@(x)instfreq(x, fs)', XTrain, 'UniformOutput', false);
instfreqTest = cellfun(@(x)instfreq(x, fs)', XTest, 'UniformOutput', false);

[pentropyB, tB2] = pentropy(brakeSample, fs);
[pentropyN, tN2] = pentropy(noBrakeSample, fs);

% figure;
% subplot(211);
% plot(tN2, pentropyN, 'LineWidth', 2);
% grid on;
% title('NoBrake signal');
% ylabel('Spectral entropy');
% set(gca, 'FontSize', 14);
% subplot(212);
% plot(tB2, pentropyB, 'LineWidth', 2);
% grid on;
% title('Brake Signal');
% xlabel('Time (s)');
% ylabel('Spectral entropy');
% set(gca, 'FontSize', 14);

pentropyTrain = cellfun(@(x)pentropy(x, fs)', XTrain, 'UniformOutput', false);
pentropyTest = cellfun(@(x)pentropy(x, fs)', XTest, 'UniformOutput', false);

XTrain2 = cellfun(@(x,y)[x;y], instfreqTrain, pentropyTrain, 'UniformOutput', false);
XTest2 = cellfun(@(x,y)[x;y], instfreqTest, pentropyTest, 'UniformOutput', false);

XTrain2(1:5)

% Standardize the data
mean(instFreqN)
mean(pentropyN)

XV = [XTrain2{:}];
mu = mean(XV, 2);
sg = std(XV, [], 2);

XTrainSD = XTrain2;
XTrainSD = cellfun(@(x)(x - mu)./sg, XTrainSD, 'UniformOutput', false);

XTestSD = XTest2;
XTestSD = cellfun(@(x)(x - mu)./sg, XTestSD, 'UniformOutput', false);

instFreqNSD = XTrainSD{1}(1,:);
pentropyNSD = XTrainSD{1}(2,:);

mean(instFreqNSD)
mean(pentropyNSD)

%% Modify the LSTM network architecture
layers = [ ...
    sequenceInputLayer(2, 'Name', 'Sequence input layer')
    bilstmLayer(100, 'OutputMode', 'last', 'Name', 'Bidirectional LSTM layer')
    fullyConnectedLayer(2, 'Name', 'Fully connected layer')
    softmaxLayer('Name', 'Softmax layer')
    classificationLayer('Name', 'Classification layer')
    ];
% lgraph = layerGraph(layers);
% figure;
% plot(lgraph);
% title('Structure of the second LSTM network');
% set(gca, 'FontSize', 14);
options = trainingOptions('adam', 'MaxEpochs', 3, 'MiniBatchSize', 150, 'InitialLearnRate', 0.01, 'GradientThreshold', 1, 'plots', 'training-progress', 'Verbose', false);

%% Train LSTM network
net2 = trainNetwork(XTrainSD, YTrain, layers, options);

% Test
% trainPred2 = classify(net2, XTrainSD);
% plotconfusion(YTrain', trainPred2', 'Training Accuracy');
testPred2 = classify(net2, XTestSD);
plotconfusion(YTest', testPred2', 'Testing Accuracy');