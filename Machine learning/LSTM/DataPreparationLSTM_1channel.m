%% Prepare labeled data for single-channel DL (tibialis anterior muscle) _ TRAN Gia Quoc Bao

%% Default commands
close all;
clear all;
clc;

%% Prepare data
% Split into 3 types
tibialisAnteriorBrake = {};         
tibialisAnteriorPrepare = {};
tibialisAnteriorNoBrake = {};

for i = 1 : 8
    load(strcat('TibialisAnteriorSampleLabeled', num2str(i), '.mat'));
    signal = 1e7*(ls.Source{1, 1} - mean(ls.Source{1, 1}));
    % For "brake" segments
    signalBrake = signal(ceil(ls.Labels.brake{1, 1}.ROILimits(1)) : ceil(ls.Labels.brake{1, 1}.ROILimits(2)));
    tibialisAnteriorBrake = [tibialisAnteriorBrake; {signalBrake}];
    % For "prepare" segments
    for j = 1 : height(ls.Labels.prepare{1,1})
        signalPrepare = signal(ceil(ls.Labels.prepare{1, 1}.ROILimits(j, 1)) : ceil(ls.Labels.prepare{1, 1}.ROILimits(j, 2)));
        tibialisAnteriorPrepare = [tibialisAnteriorPrepare; {signalPrepare}];
    end
    % For "no brake" segments
    for k = 1 : height(ls.Labels.noBrake{1,1})
        signalNoBrake = signal(ceil(ls.Labels.noBrake{1, 1}.ROILimits(k, 1)) : ceil(ls.Labels.noBrake{1, 1}.ROILimits(k, 2)));
        tibialisAnteriorNoBrake = [tibialisAnteriorNoBrake; {signalNoBrake}];
    end
end

% Normalize values
sumBrake = 0;
for i = 1 : length(tibialisAnteriorBrake)
    sumBrake = sumBrake + (max(tibialisAnteriorBrake{i}) - min(tibialisAnteriorBrake{i}))/2;
end
aveBrake = sumBrake/length(tibialisAnteriorBrake);
for i = 1 : length(tibialisAnteriorBrake)
    tibialisAnteriorBrake{i} = tibialisAnteriorBrake{i}*aveBrake/(max(tibialisAnteriorBrake{i}) - min(tibialisAnteriorBrake{i}))/2;
end

sumPrepare = 0;
for i = 1 : length(tibialisAnteriorPrepare)
    sumPrepare = sumPrepare + (max(tibialisAnteriorPrepare{i}) - min(tibialisAnteriorPrepare{i}))/2;
end
avePrepare = sumPrepare/length(tibialisAnteriorPrepare);
for i = 1 : length(tibialisAnteriorPrepare)
    tibialisAnteriorPrepare{i} = tibialisAnteriorPrepare{i}*avePrepare/(max(tibialisAnteriorPrepare{i}) - min(tibialisAnteriorPrepare{i}))/2;
end

sumNoBrake = 0;
for i = 1 : length(tibialisAnteriorNoBrake)
    sumNoBrake = sumNoBrake + (max(tibialisAnteriorNoBrake{i}) - min(tibialisAnteriorNoBrake{i}))/2;
end
aveNoBrake = sumNoBrake/length(tibialisAnteriorNoBrake);
for i = 1 : length(tibialisAnteriorNoBrake)
    tibialisAnteriorNoBrake{i} = tibialisAnteriorNoBrake{i}*aveNoBrake/(max(tibialisAnteriorNoBrake{i}) - min(tibialisAnteriorNoBrake{i}))/2;
end

% Signals = [tibialisAnteriorBrake; tibialisAnteriorPrepare; tibialisAnteriorNoBrake];
Signals = [tibialisAnteriorBrake; tibialisAnteriorNoBrake];

% Label cells
labelsBrake = repmat({'brake'}, length(tibialisAnteriorBrake), 1);
% labelsPrepare = repmat({'prepare'}, length(tibialisAnteriorPrepare), 1);
% labelsPrepare = repmat({'noBrake'}, length(tibialisAnteriorPrepare), 1); % now just have 2 labels first
labelsNoBrake = repmat({'noBrake'}, length(tibialisAnteriorNoBrake), 1);
% Labels = [labelsBrake; labelsPrepare; labelsNoBrake];
Labels = [labelsBrake; labelsNoBrake];

% Create a database of equal segments
% The length of each segment is 1000 samples which means 1 second
[Signals, Labels] = segmentSignals(Signals, Labels, 1000);

save LSTMData.mat Signals Labels;