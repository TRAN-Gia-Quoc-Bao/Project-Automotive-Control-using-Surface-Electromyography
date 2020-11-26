%% Data preparation for ML-based classification of sEMG signals _ TRAN Gia Quoc Bao

%% Default commands
close all;
clear all;
clc;

%% Load & cut signals

% Run ONCE only:
% Step 1: Put the 10 .mat files and this .m file in the same folder
% Step 2: Creat a folder called Data in this folder also
% Step 3: In the Data, creat 5 folders with the muscle names: TibialisAnteriorMuscle, GastrocnemiusMedialHead, GastrocnemiusLateralHead, RectusFemorisMuscle, AdductorMagnusMuscle
% Step 4: In each of them, create 2 folders for brake and no brake, like TibialisAnteriorMuscleBrake and TibialisAnteriorMuscleNoBrake
% Step 5: Run this

for i = 1 : 10
    load(strcat('sEMG_', num2str(i), '.mat'));
    for j = 1 : 50
        TibialisAnteriorMuscleNoBrake     = TibialisAnteriorMuscle(100*j - 99 : 100*j);
        save(strcat('Data\TibialisAnteriorMuscle\TibialisAnteriorMuscleNoBrake\TibialisAnteriorMuscleNoBrake', num2str(j + 50*i - 50), '.mat'), 'TibialisAnteriorMuscleNoBrake');
        
        GastrocnemiusMedialHeadNoBrake    = GastrocnemiusMedialHead(100*j - 99 : 100*j);
        save(strcat('Data\GastrocnemiusMedialHead\GastrocnemiusMedialHeadNoBrake\GastrocnemiusMedialHeadNoBrake', num2str(j + 50*i - 50), '.mat'), 'GastrocnemiusMedialHeadNoBrake');
        
        GastrocnemiusLateralHeadNoBrake   = GastrocnemiusLateralHead(100*j - 99 : 100*j);
        save(strcat('Data\GastrocnemiusLateralHead\GastrocnemiusLateralHeadNoBrake\GastrocnemiusLateralHeadNoBrake', num2str(j + 50*i - 50), '.mat'), 'GastrocnemiusLateralHeadNoBrake');

        RectusFemorisMuscleNoBrake        = RectusFemorisMuscle(100*j - 99 : 100*j);
        save(strcat('Data\RectusFemorisMuscle\RectusFemorisMuscleNoBrake\RectusFemorisMuscleNoBrake', num2str(j + 50*i - 50), '.mat'), 'RectusFemorisMuscleNoBrake');

        AdductorMagnusMuscleNoBrake       = AdductorMagnusMuscle(100*j - 99 : 100*j);
        save(strcat('Data\AdductorMagnusMuscle\AdductorMagnusMuscleNoBrake\AdductorMagnusMuscleNoBrake', num2str(j + 50*i - 50), '.mat'), 'AdductorMagnusMuscleNoBrake');
    end
    
    for k = 51 : 100
        TibialisAnteriorMuscleBrake   = TibialisAnteriorMuscle(100*k - 99 : 100*k);
        save(strcat('Data\TibialisAnteriorMuscle\TibialisAnteriorMuscleBrake\TibialisAnteriorMuscleBrake', num2str(k + 50*i - 100), '.mat'), 'TibialisAnteriorMuscleBrake');
        
        GastrocnemiusMedialHeadBrake  = GastrocnemiusMedialHead(100*k - 99 : 100*k);
        save(strcat('Data\GastrocnemiusMedialHead\GastrocnemiusMedialHeadBrake\GastrocnemiusMedialHeadBrake', num2str(k + 50*i - 100), '.mat'), 'GastrocnemiusMedialHeadBrake');
        
        GastrocnemiusLateralHeadBrake = GastrocnemiusLateralHead(100*k - 99 : 100*k);
        save(strcat('Data\GastrocnemiusLateralHead\GastrocnemiusLateralHeadBrake\GastrocnemiusLateralHeadBrake', num2str(k + 50*i - 100), '.mat'), 'GastrocnemiusLateralHeadBrake');

        RectusFemorisMuscleBrake      = RectusFemorisMuscle(100*k - 99 : 100*k);
        save(strcat('Data\RectusFemorisMuscle\RectusFemorisMuscleBrake\RectusFemorisMuscleBrake', num2str(k + 50*i - 100), '.mat'), 'RectusFemorisMuscleBrake');

        AdductorMagnusMuscleBrake     = AdductorMagnusMuscle(100*k - 99 : 100*k);
        save(strcat('Data\AdductorMagnusMuscle\AdductorMagnusMuscleBrake\AdductorMagnusMuscleBrake', num2str(k + 50*i - 100), '.mat'), 'AdductorMagnusMuscleBrake');
    end
end

% Now we have, for each muscle and each activity (brake/no brake), there
% are 500 signals of 100 samples each.

%% Grouping data
% The feature here is the amplitude. We calculate the RMS of each
trainingSetSize = 400; % we use this many data for training
% TibialisAnteriorMuscleNoBrakeRMS    = zeros(trainingSetSize, 1);    TibialisAnteriorMuscleBrakeRMS = zeros(trainingSetSize, 1);
% GastrocnemiusMedialHeadNoBrakeRMS   = zeros(trainingSetSize, 1);    GastrocnemiusMedialHeadBrakeRMS = zeros(trainingSetSize, 1);
% GastrocnemiusLateralHeadNoBrakeRMS  = zeros(trainingSetSize, 1);    GastrocnemiusLateralHeadBrakeRMS = zeros(trainingSetSize, 1);
RectusFemorisMuscleNoBrakeRMS       = zeros(trainingSetSize, 1);    RectusFemorisMuscleBrakeRMS = zeros(trainingSetSize, 1);
% AdductorMagnusMuscleNoBrakeRMS      = zeros(trainingSetSize, 1);    AdductorMagnusMuscleBrakeRMS = zeros(trainingSetSize, 1);

for p = 1 : trainingSetSize
%     load(strcat('Data\TibialisAnteriorMuscle\TibialisAnteriorMuscleNoBrake\TibialisAnteriorMuscleNoBrake', num2str(p), '.mat'));
%     TibialisAnteriorMuscleNoBrakeRMS(p)     = rms(TibialisAnteriorMuscleNoBrake);
%     load(strcat('Data\TibialisAnteriorMuscle\TibialisAnteriorMuscleBrake\TibialisAnteriorMuscleBrake', num2str(p), '.mat'));
%     TibialisAnteriorMuscleBrakeRMS(p)       = rms(TibialisAnteriorMuscleBrake);
% 
%     load(strcat('Data\GastrocnemiusMedialHead\GastrocnemiusMedialHeadNoBrake\GastrocnemiusMedialHeadNoBrake', num2str(p), '.mat'));
%     GastrocnemiusMedialHeadNoBrakeRMS(p)    = rms(GastrocnemiusMedialHeadNoBrake);
%     load(strcat('Data\GastrocnemiusMedialHead\GastrocnemiusMedialHeadBrake\GastrocnemiusMedialHeadBrake', num2str(p), '.mat'));
%     GastrocnemiusMedialHeadBrakeRMS(p)      = rms(GastrocnemiusMedialHeadBrake);
% 
%     load(strcat('Data\GastrocnemiusLateralHead\GastrocnemiusLateralHeadNoBrake\GastrocnemiusLateralHeadNoBrake', num2str(p), '.mat'));
%     GastrocnemiusLateralHeadNoBrakeRMS(p)   = rms(GastrocnemiusLateralHeadNoBrake);
%     load(strcat('Data\GastrocnemiusLateralHead\GastrocnemiusLateralHeadBrake\GastrocnemiusLateralHeadBrake', num2str(p), '.mat'));
%     GastrocnemiusLateralHeadBrakeRMS(p)       = rms(GastrocnemiusLateralHeadBrake);

    load(strcat('Data\RectusFemorisMuscle\RectusFemorisMuscleNoBrake\RectusFemorisMuscleNoBrake', num2str(p), '.mat'));
    RectusFemorisMuscleNoBrakeRMS(p)        = rms(RectusFemorisMuscleNoBrake);
    load(strcat('Data\RectusFemorisMuscle\RectusFemorisMuscleBrake\RectusFemorisMuscleBrake', num2str(p), '.mat'));
    RectusFemorisMuscleBrakeRMS(p)          = rms(RectusFemorisMuscleBrake);

%     load(strcat('Data\AdductorMagnusMuscle\AdductorMagnusMuscleNoBrake\AdductorMagnusMuscleNoBrake', num2str(p), '.mat'));
%     AdductorMagnusMuscleNoBrakeRMS(p)       = rms(AdductorMagnusMuscleNoBrake);
%     load(strcat('Data\AdductorMagnusMuscle\AdductorMagnusMuscleBrake\AdductorMagnusMuscleBrake', num2str(p), '.mat'));
%     AdductorMagnusMuscleBrakeRMS(p)         = rms(AdductorMagnusMuscleBrake);
end

%% Give labels
% trainDataTibialisAnteriorMuscle     = [TibialisAnteriorMuscleNoBrakeRMS; TibialisAnteriorMuscleBrakeRMS];
% labelTibialisAnteriorMuscle     = cell(trainingSetSize*2, 1);
% labelTibialisAnteriorMuscle(1 : trainingSetSize)    = {'No brake'};
% labelTibialisAnteriorMuscle(trainingSetSize + 1 : end)      = {'Brake'};
% 
% trainDataGastrocnemiusMedialHead    = [GastrocnemiusMedialHeadNoBrakeRMS; GastrocnemiusMedialHeadBrakeRMS];
% labelGastrocnemiusMedialHead    = cell(trainingSetSize*2, 1);
% labelGastrocnemiusMedialHead(1 : trainingSetSize)   = {'No brake'};
% labelGastrocnemiusMedialHead(trainingSetSize + 1 : end)     = {'Brake'};
% 
% trainDataGastrocnemiusLateralHead   = [GastrocnemiusLateralHeadNoBrakeRMS; GastrocnemiusLateralHeadBrakeRMS];
% labelGastrocnemiusLateralHead = cell(trainingSetSize*2, 1);
% labelGastrocnemiusLateralHead(1 : trainingSetSize)  = {'No brake'};
% labelGastrocnemiusLateralHead(trainingSetSize + 1 : end)    = {'Brake'};

trainDataRectusFemorisMuscle        = [RectusFemorisMuscleNoBrakeRMS; RectusFemorisMuscleBrakeRMS];
labelRectusFemorisMuscle        = cell(trainingSetSize*2, 1);
labelRectusFemorisMuscle(1 : trainingSetSize)       = {'No brake'};
labelRectusFemorisMuscle(trainingSetSize + 1 : end)         = {'Brake'};

% trainDataAdductorMagnusMuscle       = [AdductorMagnusMuscleNoBrakeRMS; AdductorMagnusMuscleBrakeRMS];
% labelAdductorMagnusMuscle       = cell(trainingSetSize*2, 1);
% labelAdductorMagnusMuscle(1 : trainingSetSize)      = {'No brake'};
% labelAdductorMagnusMuscle(trainingSetSize + 1 : end)        = {'Brake'};

%% Fit k-nearest neighbor classifiers
rangeK = 20;

kNN = 1 : rangeK;
% ratioTibialisAnteriorMuscle     = zeros(rangeK, 1);
% ratioGastrocnemiusMedialHead    = zeros(rangeK, 1);
% ratioGastrocnemiusLateralHead   = zeros(rangeK, 1);
ratioRectusFemorisMuscle        = zeros(rangeK, 1);
% ratioAdductorMagnusMuscle       = zeros(rangeK, 1);

for k = 1 : rangeK
%     kNN_TibialisAnteriorMuscle      = fitcknn(trainDataTibialisAnteriorMuscle, labelTibialisAnteriorMuscle, 'NumNeighbors', k, 'Standardize', 1);
%     kNN_GastrocnemiusMedialHead     = fitcknn(trainDataGastrocnemiusMedialHead, labelGastrocnemiusMedialHead, 'NumNeighbors', k, 'Standardize', 1);
%     kNN_GastrocnemiusLateralHead    = fitcknn(trainDataGastrocnemiusLateralHead, labelGastrocnemiusLateralHead, 'NumNeighbors', k, 'Standardize', 1);
    kNN_RectusFemorisMuscle         = fitcknn(trainDataRectusFemorisMuscle, labelRectusFemorisMuscle, 'NumNeighbors', k, 'Standardize', 1);
%     kNN_AdductorMagnusMuscle        = fitcknn(trainDataAdductorMagnusMuscle, labelAdductorMagnusMuscle, 'NumNeighbors', k, 'Standardize', 1);
% Now we have 5 models

% Test the k-NN classifiers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     testTibialisAnteriorMuscle = zeros(2*(500 - trainingSetSize), 1);
%     for i = 1 : length(testTibialisAnteriorMuscle)/2
%         load(strcat('Data\TibialisAnteriorMuscle\TibialisAnteriorMuscleNoBrake\TibialisAnteriorMuscleNoBrake', num2str(i + trainingSetSize), '.mat'));
%         testTibialisAnteriorMuscle(i) = rms(TibialisAnteriorMuscleNoBrake);
%     end
%     for i = length(testTibialisAnteriorMuscle)/2 + 1 : length(testTibialisAnteriorMuscle)
%         load(strcat('Data\TibialisAnteriorMuscle\TibialisAnteriorMuscleBrake\TibialisAnteriorMuscleBrake', num2str(i + trainingSetSize - length(testTibialisAnteriorMuscle)/2), '.mat'));
%         testTibialisAnteriorMuscle(i) = rms(TibialisAnteriorMuscleBrake);
%     end
% 
%     predictTibialisAnteriorMuscle = predict(kNN_TibialisAnteriorMuscle, testTibialisAnteriorMuscle);
% 
%     correctTibialisAnteriorMuscle = 0;
%     for i = 1 : length(testTibialisAnteriorMuscle)/2
%         correctTibialisAnteriorMuscle = correctTibialisAnteriorMuscle + strcmp(predictTibialisAnteriorMuscle{i}, 'No brake');   
%     end
%     for i = length(testTibialisAnteriorMuscle)/2 + 1 : length(testTibialisAnteriorMuscle)
%         correctTibialisAnteriorMuscle = correctTibialisAnteriorMuscle + strcmp(predictTibialisAnteriorMuscle{i}, 'Brake'); 
%     end
%     ratioTibialisAnteriorMuscle(k) = correctTibialisAnteriorMuscle*100/length(testTibialisAnteriorMuscle);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     testGastrocnemiusMedialHead = zeros(2*(500 - trainingSetSize), 1);
%     for i = 1 : length(testGastrocnemiusMedialHead)/2
%         load(strcat('Data\GastrocnemiusMedialHead\GastrocnemiusMedialHeadNoBrake\GastrocnemiusMedialHeadNoBrake', num2str(i + trainingSetSize), '.mat'));
%         testGastrocnemiusMedialHead(i) = rms(GastrocnemiusMedialHeadNoBrake);
%     end
%     for i = length(testGastrocnemiusMedialHead)/2 + 1 : length(testGastrocnemiusMedialHead)
%         load(strcat('Data\GastrocnemiusMedialHead\GastrocnemiusMedialHeadBrake\GastrocnemiusMedialHeadBrake', num2str(i + trainingSetSize - length(testGastrocnemiusMedialHead)/2), '.mat'));
%         testGastrocnemiusMedialHead(i) = rms(GastrocnemiusMedialHeadBrake);
%     end
% 
%     predictGastrocnemiusMedialHead = predict(kNN_GastrocnemiusMedialHead, testGastrocnemiusMedialHead);
% 
%     correctGastrocnemiusMedialHead = 0;
%     for i = 1 : length(testGastrocnemiusMedialHead)/2
%         correctGastrocnemiusMedialHead = correctGastrocnemiusMedialHead + strcmp(predictGastrocnemiusMedialHead{i}, 'No brake');   
%     end
%     for i = length(testGastrocnemiusMedialHead)/2 + 1 : length(testGastrocnemiusMedialHead)
%         correctGastrocnemiusMedialHead = correctGastrocnemiusMedialHead + strcmp(predictGastrocnemiusMedialHead{i}, 'Brake'); 
%     end
%     ratioGastrocnemiusMedialHead(k) = correctGastrocnemiusMedialHead*100/length(testGastrocnemiusMedialHead);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     testGastrocnemiusLateralHead = zeros(2*(500 - trainingSetSize), 1);
%     for i = 1 : length(testGastrocnemiusLateralHead)/2
%         load(strcat('Data\GastrocnemiusLateralHead\GastrocnemiusLateralHeadNoBrake\GastrocnemiusLateralHeadNoBrake', num2str(i + trainingSetSize), '.mat'));
%         testGastrocnemiusLateralHead(i) = rms(GastrocnemiusLateralHeadNoBrake);
%     end
%     for i = length(testGastrocnemiusLateralHead)/2 + 1 : length(testGastrocnemiusLateralHead)
%         load(strcat('Data\GastrocnemiusLateralHead\GastrocnemiusLateralHeadBrake\GastrocnemiusLateralHeadBrake', num2str(i + trainingSetSize - length(testGastrocnemiusLateralHead)/2), '.mat'));
%         testGastrocnemiusLateralHead(i) = rms(GastrocnemiusLateralHeadBrake);
%     end
% 
%     predictGastrocnemiusLateralHead = predict(kNN_GastrocnemiusLateralHead, testGastrocnemiusLateralHead);
% 
%     correctGastrocnemiusLateralHead = 0;
%     for i = 1 : length(testGastrocnemiusLateralHead)/2
%         correctGastrocnemiusLateralHead = correctGastrocnemiusLateralHead + strcmp(predictGastrocnemiusLateralHead{i}, 'No brake');   
%     end
%     for i = length(testGastrocnemiusLateralHead)/2 + 1 : length(testGastrocnemiusLateralHead)
%         correctGastrocnemiusLateralHead = correctGastrocnemiusLateralHead + strcmp(predictGastrocnemiusLateralHead{i}, 'Brake'); 
%     end
%     ratioGastrocnemiusLateralHead(k) = correctGastrocnemiusLateralHead*100/length(testGastrocnemiusLateralHead);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    testRectusFemorisMuscle = zeros(2*(500 - trainingSetSize), 1);
    testRTRectusFemorisMuscle = zeros(20000, 1);
    for i = 1 : length(testRectusFemorisMuscle)/2
        load(strcat('Data\RectusFemorisMuscle\RectusFemorisMuscleNoBrake\RectusFemorisMuscleNoBrake', num2str(i + trainingSetSize), '.mat'));
        testRectusFemorisMuscle(i) = rms(RectusFemorisMuscleNoBrake);
        testRTRectusFemorisMuscle(200*i - 199 : 200*i - 100) = RectusFemorisMuscleNoBrake;
    end
    for i = length(testRectusFemorisMuscle)/2 + 1 : length(testRectusFemorisMuscle)
        load(strcat('Data\RectusFemorisMuscle\RectusFemorisMuscleBrake\RectusFemorisMuscleBrake', num2str(i + trainingSetSize - length(testRectusFemorisMuscle)/2), '.mat'));
        testRectusFemorisMuscle(i) = rms(RectusFemorisMuscleBrake);
        testRTRectusFemorisMuscle(200*(i - length(testRectusFemorisMuscle)/2) - 99 : 200*(i - length(testRectusFemorisMuscle)/2)) = RectusFemorisMuscleBrake;
    end
    
    ansRTRectusFemorisMuscle = cell(200, 1);
    for i = 1 : 200
        ansRTRectusFemorisMuscle(2*i - 1)   = {'No brake'};
        ansRTRectusFemorisMuscle(2*i)       = {'Brake'};
    end
    
    predictRectusFemorisMuscle = predict(kNN_RectusFemorisMuscle, testRectusFemorisMuscle);

    correctRectusFemorisMuscle = 0;
    for i = 1 : length(testRectusFemorisMuscle)/2
        correctRectusFemorisMuscle = correctRectusFemorisMuscle + strcmp(predictRectusFemorisMuscle{i}, 'No brake');   
    end
    for i = length(testRectusFemorisMuscle)/2 + 1 : length(testRectusFemorisMuscle)
        correctRectusFemorisMuscle = correctRectusFemorisMuscle + strcmp(predictRectusFemorisMuscle{i}, 'Brake'); 
    end
    ratioRectusFemorisMuscle(k) = correctRectusFemorisMuscle*100/length(testRectusFemorisMuscle);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     testAdductorMagnusMuscle = zeros(2*(500 - trainingSetSize), 1);
%     for i = 1 : length(testAdductorMagnusMuscle)/2
%         load(strcat('Data\AdductorMagnusMuscle\AdductorMagnusMuscleNoBrake\AdductorMagnusMuscleNoBrake', num2str(i + trainingSetSize), '.mat'));
%         testAdductorMagnusMuscle(i) = rms(AdductorMagnusMuscleNoBrake);
%     end
%     for i = length(testAdductorMagnusMuscle)/2 + 1 : length(testAdductorMagnusMuscle)
%         load(strcat('Data\AdductorMagnusMuscle\AdductorMagnusMuscleBrake\AdductorMagnusMuscleBrake', num2str(i + trainingSetSize - length(testAdductorMagnusMuscle)/2), '.mat'));
%         testAdductorMagnusMuscle(i) = rms(AdductorMagnusMuscleBrake);
%     end
% 
%     predictAdductorMagnusMuscle = predict(kNN_AdductorMagnusMuscle, testAdductorMagnusMuscle);
% 
%     correctAdductorMagnusMuscle = 0;
%     for i = 1 : length(testAdductorMagnusMuscle)/2
%         correctAdductorMagnusMuscle = correctAdductorMagnusMuscle + strcmp(predictAdductorMagnusMuscle{i}, 'No brake');   
%     end
%     for i = length(testAdductorMagnusMuscle)/2 + 1 : length(testAdductorMagnusMuscle)
%         correctAdductorMagnusMuscle = correctAdductorMagnusMuscle + strcmp(predictAdductorMagnusMuscle{i}, 'Brake'); 
%     end
%     ratioAdductorMagnusMuscle(k) = correctAdductorMagnusMuscle*100/length(testAdductorMagnusMuscle);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
end

%% Plot accuracy with respect to k
% figure();
% plot(kNN, ratioTibialisAnteriorMuscle, kNN, ratioGastrocnemiusMedialHead, kNN, ratioGastrocnemiusLateralHead, kNN, ratioRectusFemorisMuscle, kNN, ratioAdductorMagnusMuscle, 'linewidth', 2);
% grid on;
% set(gca, 'FontSize', 12);
% xlabel('Number of points taken for classification');
% ylabel('Accuracy (%)');
% xlim([0, rangeK]);
% ylim([70, 95]);
% legend('Tibialis Anterior Muscle', 'Gastrocnemius Medial Head Muscle', 'Gastrocnemius Lateral Head Muscle', 'Rectus Femoris Muscle', 'Adductor Magnus Muscle', 'Location', 'southeast');
% title('Accuracy vs k');

%% Real-time test with 5-NN of rectus femoris (the most accurate)

kNN_RectusFemorisMuscle = fitcknn(trainDataRectusFemorisMuscle, labelRectusFemorisMuscle, 'NumNeighbors', 5, 'Standardize', 1);

tDecide = 0.1; % we make decision after this time
Fs = 1000;
N = length(testRTRectusFemorisMuscle); % number of samples
time = (0 : N - 1)'/Fs; % discrete time
correctRTRectusFemorisMuscle = 0;

figure()
for i = 4 : 200
    timeSpan = time(100*i - 399 : 100*i);
    plot(timeSpan, testRTRectusFemorisMuscle(100*i - 399 : 100*i), 'linewidth', 2);
    grid on;
    set(gca, 'FontSize', 12);
    xlim([tDecide*(i - 4) tDecide*i]);
    xlabel('Time (seconds)');
    ylabel('sEMG (\muV)');
    guessRTRectusFemorisMuscle = predict(kNN_RectusFemorisMuscle, rms(testRTRectusFemorisMuscle(100*i - 99 : 100*i)));
    correctRTRectusFemorisMuscle = correctRTRectusFemorisMuscle + strcmp(guessRTRectusFemorisMuscle, ansRTRectusFemorisMuscle(i));
    accuracyRTRectusFemorisMuscle = correctRTRectusFemorisMuscle/(i - 3);
    title({'Classification of the rectus femoris muscle activities', strcat('Classification=', char(guessRTRectusFemorisMuscle)), strcat('Answer= ', char(ansRTRectusFemorisMuscle(i))), strcat('Accuracy= ', num2str(accuracyRTRectusFemorisMuscle))});
    pause(0.1);
end