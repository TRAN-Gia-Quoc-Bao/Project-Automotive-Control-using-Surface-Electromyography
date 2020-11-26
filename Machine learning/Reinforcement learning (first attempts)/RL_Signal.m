%% sEMG signal classification using RL - TRAN Gia Quoc Bao

% Default commands
clc;
clear all;
close all;

% Observations
obsInfo = rlNumericSpec([1 1], 'LowerLimit', [-inf]', 'UpperLimit', [inf]');
obsInfo.Name = 'observations';
obsInfo.Description = 'observations';
numObservations = obsInfo.Dimension(1);

% Actions
actInfo = rlNumericSpec([1 1]);
actInfo.Name = 'brake';
numActions = actInfo.Dimension(1);

% Environment
env = rlSimulinkEnv('signalClassification', 'signalClassification/RL Agent', obsInfo, actInfo);
env.ResetFcn = @(in)localResetFcn(in);

w = [1 1 1];
w = w/sum(w);

Ts = 1;
load('sEMG_situations_1.mat');
Fs = 1000; % sampling frequency
N1 = length(TibialisAnteriorMuscle); % number of samples
time = (0 : N1 - 1)'/Fs; % discrete time
signalTibialisAnteriorMuscleTrain = [time TibialisAnteriorMuscle];
% signalGastrocnemiusMedialHeadTrain = [time GastrocnemiusMedialHead];
% signalGastrocnemiusLateralHeadTrain = [time GastrocnemiusLateralHead];
% signalRectusFemorisMuscleTrain = [time RectusFemorisMuscle];
% signalAdductorMagnusMuscleTrain = [time AdductorMagnusMuscle];
pedalInputTrain= [time PedalInput];
load('sEMG_situations_2.mat');
N2 = length(TibialisAnteriorMuscle); % number of samples
time = (N1 : N1 + N2 - 1)'/Fs; % discrete time
signalTibialisAnteriorMuscleTrain = [signalTibialisAnteriorMuscleTrain; time TibialisAnteriorMuscle];
% signalGastrocnemiusMedialHeadTrain = [signalGastrocnemiusMedialHeadTrain; time GastrocnemiusMedialHead];
% signalGastrocnemiusLateralHeadTrain = [signalGastrocnemiusLateralHeadTrain; time GastrocnemiusLateralHead];
% signalRectusFemorisMuscleTrain = [signalRectusFemorisMuscleTrain; time RectusFemorisMuscle];
% signalAdductorMagnusMuscleTrain = [signalAdductorMagnusMuscleTrain; time AdductorMagnusMuscle];
pedalInputTrain = [pedalInputTrain; time PedalInput];
% load('sEMG_situations_3.mat');
% N3 = length(TibialisAnteriorMuscle); % number of samples
% time = (N1 + N2 : N1 + N2 + N3 - 1)'/Fs; % discrete time
% signalTibialisAnteriorMuscleTrain = [signalTibialisAnteriorMuscleTrain; time TibialisAnteriorMuscle];
% signalGastrocnemiusMedialHeadTrain = [signalGastrocnemiusMedialHeadTrain; time GastrocnemiusMedialHead];
% signalGastrocnemiusLateralHeadTrain = [signalGastrocnemiusLateralHeadTrain; time GastrocnemiusLateralHead];
% signalRectusFemorisMuscleTrain = [signalRectusFemorisMuscleTrain; time RectusFemorisMuscle];
% signalAdductorMagnusMuscleTrain = [signalAdductorMagnusMuscleTrain; time AdductorMagnusMuscle];
% pedalInputTrain = [pedalInputTrain; time PedalInput];
% load('sEMG_situations_4.mat');
% N4 = length(TibialisAnteriorMuscle); % number of samples
% time = (N1 + N2 + N3 : N1 + N2 + N3 + N4 - 1)'/Fs; % discrete time
% signalTibialisAnteriorMuscleTrain = [signalTibialisAnteriorMuscleTrain; time TibialisAnteriorMuscle];
% signalGastrocnemiusMedialHeadTrain = [signalGastrocnemiusMedialHeadTrain; time GastrocnemiusMedialHead];
% signalGastrocnemiusLateralHeadTrain = [signalGastrocnemiusLateralHeadTrain; time GastrocnemiusLateralHead];
% signalRectusFemorisMuscleTrain = [signalRectusFemorisMuscleTrain; time RectusFemorisMuscle];
% signalAdductorMagnusMuscleTrain = [signalAdductorMagnusMuscleTrain; time AdductorMagnusMuscle];
% pedalInputTrain = [pedalInputTrain; time PedalInput];
% load('sEMG_situations_5.mat');
% N5 = length(TibialisAnteriorMuscle); % number of samples
% time = (N1 + N2 + N3 + N4 : N1 + N2 + N3 + N4 + N5 - 1)'/Fs; % discrete time
% signalTibialisAnteriorMuscleTrain = [signalTibialisAnteriorMuscleTrain; time TibialisAnteriorMuscle];
% signalGastrocnemiusMedialHeadTrain = [signalGastrocnemiusMedialHeadTrain; time GastrocnemiusMedialHead];
% signalGastrocnemiusLateralHeadTrain = [signalGastrocnemiusLateralHeadTrain; time GastrocnemiusLateralHead];
% signalRectusFemorisMuscleTrain = [signalRectusFemorisMuscleTrain; time RectusFemorisMuscle];
% signalAdductorMagnusMuscleTrain = [signalAdductorMagnusMuscleTrain; time AdductorMagnusMuscle];
% pedalInputTrain = [pedalInputTrain; time PedalInput];

% Apply smoothing
% for i = 5 : length(pedalInputTrain)
%     signalTibialisAnteriorMuscleTrain(i, 2) = (signalTibialisAnteriorMuscleTrain(i, 2) + signalTibialisAnteriorMuscleTrain(i - 1, 2) + signalTibialisAnteriorMuscleTrain(i - 2, 2) + signalTibialisAnteriorMuscleTrain(i - 3, 2) + signalTibialisAnteriorMuscleTrain(i - 4, 2))/5;
%     signalGastrocnemiusMedialHeadTrain(i, 2) = (signalGastrocnemiusMedialHeadTrain(i, 2) + signalGastrocnemiusMedialHeadTrain(i - 1, 2) + signalGastrocnemiusMedialHeadTrain(i - 2, 2) + signalGastrocnemiusMedialHeadTrain(i - 3, 2) + signalGastrocnemiusMedialHeadTrain(i - 4, 2))/5;
% end

%% Denoising
% fc1l = 2*48/Fs; % the lower cut frequency 
% fc1h = 2*52/Fs; % the upper cut frequency 
% deltaWindow1 = 0.01;
% sizeWindow1 = round(3.3/deltaWindow1 - 1);
% 
% fc2l = 2*148/Fs; % the lower cut frequency 
% fc2h = 2*152/Fs; % the upper cut frequency 
% deltaWindow2 = 0.01;
% sizeWindow2 = round(3.3/deltaWindow2 - 1);
% 
% filter1 = fir1(sizeWindow1 + 1, [fc1l fc1h], 'stop'); 
% filter2 = fir1(sizeWindow1 + 1, [fc2l fc2h], 'stop'); 

% [magnitudeTibialisAnteriorMuscle, frequencyTibialisAnteriorMuscle] = Spectrum('Tibialis Anterior Muscle sEMG signal', signalTibialisAnteriorMuscleTrain, Fs);

% figure;
% plot(signalTibialisAnteriorMuscleTrain(:, 1), signalTibialisAnteriorMuscleTrain(:, 2), 'b');
% hold on;
% signalTibialisAnteriorMuscleTrain(:, 2) = filter(filter1, 1, signalTibialisAnteriorMuscleTrain(:, 2));
% signalGastrocnemiusMedialHeadTrain(:, 2) = filter(filter1, 1, signalGastrocnemiusMedialHeadTrain(:, 2));
% 
% signalTibialisAnteriorMuscleTrain(:, 2) = filter(filter2, 1, signalTibialisAnteriorMuscleTrain(:, 2));
% signalGastrocnemiusMedialHeadTrain(:, 2) = filter(filter2, 1, signalGastrocnemiusMedialHeadTrain(:, 2));

% plot(signalTibialisAnteriorMuscleTrain(:, 1), signalTibialisAnteriorMuscleTrain(:, 2), 'r');

% [magnitudeTibialisAnteriorMuscle, frequencyTibialisAnteriorMuscle] = Spectrum('Tibialis Anterior Muscle sEMG signal filtered', signalTibialisAnteriorMuscleTrain, Fs);

Tf = time(end); 

rng(0);

% Network 
statePath = [
    imageInputLayer([numObservations 1 1], 'Normalization', 'none', 'Name', 'State')
    fullyConnectedLayer(64, 'Name', 'CriticStateFC1')
    reluLayer('Name', 'CriticRelu1')
    fullyConnectedLayer(32, 'Name', 'CriticStateFC2')
%     reluLayer('Name', 'CriticRelu2')
%     fullyConnectedLayer(32, 'Name', 'CriticStateFC3')
];
actionPath = [
    imageInputLayer([numActions 1 1],'Normalization','none','Name','Action')
    fullyConnectedLayer(32,'Name','CriticActionFC1')];
commonPath = [
    additionLayer(2,'Name','add')
%     reluLayer('Name','CriticCommonRelu')
    tanhLayer('Name','CriticCommonTanh')
    fullyConnectedLayer(1,'Name','CriticOutput')];

criticNetwork = layerGraph();

criticNetwork = addLayers(criticNetwork, statePath);
criticNetwork = addLayers(criticNetwork, actionPath);
criticNetwork = addLayers(criticNetwork, commonPath);
criticNetwork = connectLayers(criticNetwork, 'CriticStateFC2', 'add/in1');
criticNetwork = connectLayers(criticNetwork, 'CriticActionFC1', 'add/in2');

criticOpts = rlRepresentationOptions('LearnRate', 1e-02, 'GradientThreshold', 1);

critic = rlQValueRepresentation(criticNetwork, obsInfo, actInfo, 'Observation', {'State'}, 'Action', {'Action'}, criticOpts);

actorNetwork = [
    imageInputLayer([numObservations 1 1], 'Normalization', 'none', 'Name', 'State')
    fullyConnectedLayer(4, 'Name', 'actorFC')
    tanhLayer('Name', 'actorTanh')
    fullyConnectedLayer(numActions, 'Name', 'Action')];

% actorOptions = rlRepresentationOptions('LearnRate', 1e-03, 'GradientThreshold', 1, 'UseDevice', "gpu");
actorOptions = rlRepresentationOptions('LearnRate', 1e-03, 'GradientThreshold', 1);

actor = rlDeterministicActorRepresentation(actorNetwork, obsInfo, actInfo, 'Observation', {'State'}, 'Action', {'Action'}, actorOptions);

% Agent
agentOpts = rlDDPGAgentOptions('SampleTime', Ts, 'TargetSmoothFactor', 1e-3, 'DiscountFactor', 1.0, 'MiniBatchSize', 64, 'ExperienceBufferLength', 1e6); 
agentOpts.NoiseOptions.Variance = 0.3;
agentOpts.NoiseOptions.VarianceDecayRate = 1e-5;

agent = rlDDPGAgent(actor, critic, agentOpts);

% agentOpts = rlDQNAgentOptions('SampleTime', Ts, 'TargetSmoothFactor', 1e-3, 'DiscountFactor', 1.0, 'MiniBatchSize', 48, 'ExperienceBufferLength', 1e6);
% agentOpts.EpsilonGreedyExploration.Epsilon = 0.9;
% agent = rlDQNAgent(critic, agentOpts);

%% Train agent
maxepisodes = 1000;
maxsteps = ceil(Tf/Ts);
trainOpts = rlTrainingOptions('MaxEpisodes', maxepisodes, 'MaxStepsPerEpisode', maxsteps, 'ScoreAveragingWindowLength', 20, 'Verbose', false, 'Plots', 'training-progress', 'StopTrainingCriteria', 'AverageReward', 'StopTrainingValue', 0);

trainingStats = train(agent, env, trainOpts);

simOpts = rlSimulationOptions('MaxSteps', maxsteps, 'StopOnError', 'on');
experiences = sim(env, agent, simOpts);

%% Test
% Ts = 1;
% load('sEMG_situations_1.mat');
% Fs = 1000; % sampling frequency
% N1 = length(TibialisAnteriorMuscle); % number of samples
% time = (0 : N1 - 1)'/Fs; % discrete time
% signalTibialisAnteriorMuscleTrain = [time TibialisAnteriorMuscle];
% signalGastrocnemiusMedialHeadTrain = [time GastrocnemiusMedialHead];
% signalGastrocnemiusLateralHeadTrain = [time GastrocnemiusLateralHead];
% signalRectusFemorisMuscleTrain = [time RectusFemorisMuscle];
% signalAdductorMagnusMuscleTrain = [time AdductorMagnusMuscle];
% pedalInputTrain= [time PedalInput];
% load('sEMG_situations_2.mat');
% N2 = length(TibialisAnteriorMuscle); % number of samples
% time = (N1 : N1 + N2 - 1)'/Fs; % discrete time
% signalTibialisAnteriorMuscleTrain = [signalTibialisAnteriorMuscleTrain; time TibialisAnteriorMuscle];
% signalGastrocnemiusMedialHeadTrain = [signalGastrocnemiusMedialHeadTrain; time GastrocnemiusMedialHead];
% signalGastrocnemiusLateralHeadTrain = [signalGastrocnemiusLateralHeadTrain; time GastrocnemiusLateralHead];
% signalRectusFemorisMuscleTrain = [signalRectusFemorisMuscleTrain; time RectusFemorisMuscle];
% signalAdductorMagnusMuscleTrain = [signalAdductorMagnusMuscleTrain; time AdductorMagnusMuscle];
% pedalInputTrain = [pedalInputTrain; time PedalInput];
% load('sEMG_situations_3.mat');
% N3 = length(TibialisAnteriorMuscle); % number of samples
% time = (N1 + N2 : N1 + N2 + N3 - 1)'/Fs; % discrete time
% signalTibialisAnteriorMuscleTrain = [signalTibialisAnteriorMuscleTrain; time TibialisAnteriorMuscle];
% signalGastrocnemiusMedialHeadTrain = [signalGastrocnemiusMedialHeadTrain; time GastrocnemiusMedialHead];
% signalGastrocnemiusLateralHeadTrain = [signalGastrocnemiusLateralHeadTrain; time GastrocnemiusLateralHead];
% signalRectusFemorisMuscleTrain = [signalRectusFemorisMuscleTrain; time RectusFemorisMuscle];
% signalAdductorMagnusMuscleTrain = [signalAdductorMagnusMuscleTrain; time AdductorMagnusMuscle];
% pedalInputTrain = [pedalInputTrain; time PedalInput];
% load('sEMG_situations_4.mat');
% N4 = length(TibialisAnteriorMuscle); % number of samples
% time = (N1 + N2 + N3 : N1 + N2 + N3 + N4 - 1)'/Fs; % discrete time
% signalTibialisAnteriorMuscleTrain = [signalTibialisAnteriorMuscleTrain; time TibialisAnteriorMuscle];
% signalGastrocnemiusMedialHeadTrain = [signalGastrocnemiusMedialHeadTrain; time GastrocnemiusMedialHead];
% signalGastrocnemiusLateralHeadTrain = [signalGastrocnemiusLateralHeadTrain; time GastrocnemiusLateralHead];
% signalRectusFemorisMuscleTrain = [signalRectusFemorisMuscleTrain; time RectusFemorisMuscle];
% signalAdductorMagnusMuscleTrain = [signalAdductorMagnusMuscleTrain; time AdductorMagnusMuscle];
% pedalInputTrain = [pedalInputTrain; time PedalInput];
% load('sEMG_situations_5.mat');
% N5 = length(TibialisAnteriorMuscle); % number of samples
% time = (N1 + N2 + N3 + N4 : N1 + N2 + N3 + N4 + N5 - 1)'/Fs; % discrete time
% signalTibialisAnteriorMuscleTrain = [signalTibialisAnteriorMuscleTrain; time TibialisAnteriorMuscle];
% signalGastrocnemiusMedialHeadTrain = [signalGastrocnemiusMedialHeadTrain; time GastrocnemiusMedialHead];
% signalGastrocnemiusLateralHeadTrain = [signalGastrocnemiusLateralHeadTrain; time GastrocnemiusLateralHead];
% signalRectusFemorisMuscleTrain = [signalRectusFemorisMuscleTrain; time RectusFemorisMuscle];
% signalAdductorMagnusMuscleTrain = [signalAdductorMagnusMuscleTrain; time AdductorMagnusMuscle];
% pedalInputTrain = [pedalInputTrain; time PedalInput];
% load('sEMG_situations_6.mat');
% N6 = length(TibialisAnteriorMuscle); % number of samples
% time = (N1 + N2 + N3 + N4 + N5 : N1 + N2 + N3 + N4 + N5 + N6 - 1)'/Fs; % discrete time
% signalTibialisAnteriorMuscleTrain = [signalTibialisAnteriorMuscleTrain; time TibialisAnteriorMuscle];
% signalGastrocnemiusMedialHeadTrain = [signalGastrocnemiusMedialHeadTrain; time GastrocnemiusMedialHead];
% signalGastrocnemiusLateralHeadTrain = [signalGastrocnemiusLateralHeadTrain; time GastrocnemiusLateralHead];
% signalRectusFemorisMuscleTrain = [signalRectusFemorisMuscleTrain; time RectusFemorisMuscle];
% signalAdductorMagnusMuscleTrain = [signalAdductorMagnusMuscleTrain; time AdductorMagnusMuscle];
% pedalInputTrain = [pedalInputTrain; time PedalInput];
% load('sEMG_situations_7.mat');
% N7 = length(TibialisAnteriorMuscle); % number of samples
% time = (N1 + N2 + N3 + N4 + N5 + N6 : N1 + N2 + N3 + N4 + N5 + N6 + N7 - 1)'/Fs; % discrete time
% signalTibialisAnteriorMuscleTrain = [signalTibialisAnteriorMuscleTrain; time TibialisAnteriorMuscle];
% signalGastrocnemiusMedialHeadTrain = [signalGastrocnemiusMedialHeadTrain; time GastrocnemiusMedialHead];
% signalGastrocnemiusLateralHeadTrain = [signalGastrocnemiusLateralHeadTrain; time GastrocnemiusLateralHead];
% signalRectusFemorisMuscleTrain = [signalRectusFemorisMuscleTrain; time RectusFemorisMuscle];
% signalAdductorMagnusMuscleTrain = [signalAdductorMagnusMuscleTrain; time AdductorMagnusMuscle];
% pedalInputTrain = [pedalInputTrain; time PedalInput];
% load('sEMG_situations_8.mat');
% N8 = length(TibialisAnteriorMuscle); % number of samples
% time = (N1 + N2 + N3 + N4 + N5 + N6 + N7 : N1 + N2 + N3 + N4 + N5 + N6 + N7 + N8 - 1)'/Fs; % discrete time
% signalTibialisAnteriorMuscleTrain = [signalTibialisAnteriorMuscleTrain; time TibialisAnteriorMuscle];
% signalGastrocnemiusMedialHeadTrain = [signalGastrocnemiusMedialHeadTrain; time GastrocnemiusMedialHead];
% signalGastrocnemiusLateralHeadTrain = [signalGastrocnemiusLateralHeadTrain; time GastrocnemiusLateralHead];
% signalRectusFemorisMuscleTrain = [signalRectusFemorisMuscleTrain; time RectusFemorisMuscle];
% signalAdductorMagnusMuscleTrain = [signalAdductorMagnusMuscleTrain; time AdductorMagnusMuscle];
% pedalInputTrain = [pedalInputTrain; time PedalInput];
% load('sEMG_situations_9.mat');
% N9 = length(TibialisAnteriorMuscle); % number of samples
% time = (N1 + N2 + N3 + N4 + N5 + N6 + N7 + N8 : N1 + N2 + N3 + N4 + N5 + N6 + N7 + N8 + N9 - 1)'/Fs; % discrete time
% signalTibialisAnteriorMuscleTrain = [signalTibialisAnteriorMuscleTrain; time TibialisAnteriorMuscle];
% signalGastrocnemiusMedialHeadTrain = [signalGastrocnemiusMedialHeadTrain; time GastrocnemiusMedialHead];
% signalGastrocnemiusLateralHeadTrain = [signalGastrocnemiusLateralHeadTrain; time GastrocnemiusLateralHead];
% signalRectusFemorisMuscleTrain = [signalRectusFemorisMuscleTrain; time RectusFemorisMuscle];
% signalAdductorMagnusMuscleTrain = [signalAdductorMagnusMuscleTrain; time AdductorMagnusMuscle];
% pedalInputTrain = [pedalInputTrain; time PedalInput];
% load('sEMG_situations_10.mat');
% N10 = length(TibialisAnteriorMuscle); % number of samples
% time = (N1 + N2 + N3 + N4 + N5 + N6 + N7 + N8 + N9 : N1 + N2 + N3 + N4 + N5 + N6 + N7 + N8 + N9 + N10 - 1)'/Fs; % discrete time
% signalTibialisAnteriorMuscleTrain = [signalTibialisAnteriorMuscleTrain; time TibialisAnteriorMuscle];
% signalGastrocnemiusMedialHeadTrain = [signalGastrocnemiusMedialHeadTrain; time GastrocnemiusMedialHead];
% signalGastrocnemiusLateralHeadTrain = [signalGastrocnemiusLateralHeadTrain; time GastrocnemiusLateralHead];
% signalRectusFemorisMuscleTrain = [signalRectusFemorisMuscleTrain; time RectusFemorisMuscle];
% signalAdductorMagnusMuscleTrain = [signalAdductorMagnusMuscleTrain; time AdductorMagnusMuscle];
% pedalInputTrain = [pedalInputTrain; time PedalInput];
% Tf = time(end); 

% Save results
%save("signalProcessingAgent.mat", "agent");

%% Load pre-trained agents
% load('signalProcessingAgent.mat', 'agent');
% simOpts = rlSimulationOptions('MaxSteps', maxsteps, 'StopOnError', 'on');
% experiences = sim(env, agent, simOpts);