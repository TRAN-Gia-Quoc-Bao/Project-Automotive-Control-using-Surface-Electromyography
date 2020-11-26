%% RL with ICA

%% sEMG signal classification using DNN - TRAN Gia Quoc Bao

% Default commands
clc;
clear all;
close all;

%% Load data
Ts = 1;
load('sEMG_situations_1.mat');
Fs = 1000; % sampling frequency
N1 = length(TibialisAnteriorMuscle); % number of samples
time = (0 : N1 - 1)'/Fs; % discrete time
inputPedal = [time PedalInput];
data = [TibialisAnteriorMuscle'; GastrocnemiusMedialHead'; GastrocnemiusLateralHead'; RectusFemorisMuscle'; AdductorMagnusMuscle'];

load('sEMG_situations_2.mat');
N2 = length(TibialisAnteriorMuscle); % number of samples
time = (N1 : N1 + N2 - 1)'/Fs; % discrete time
inputPedal = [inputPedal; time PedalInput];
data = [data [TibialisAnteriorMuscle'; GastrocnemiusMedialHead'; GastrocnemiusLateralHead'; RectusFemorisMuscle'; AdductorMagnusMuscle']];

load('sEMG_situations_3.mat');
N3 = length(TibialisAnteriorMuscle); % number of samples
time = (N1 + N2 : N1 + N2 + N3 - 1)'/Fs; % discrete time
inputPedal = [inputPedal; time PedalInput];
data = [data [TibialisAnteriorMuscle'; GastrocnemiusMedialHead'; GastrocnemiusLateralHead'; RectusFemorisMuscle'; AdductorMagnusMuscle']];

time = (0 : length(inputPedal) - 1)'/Fs;

%% Perform ICA with 4 components
[icasig4] = fastica(data, 'numOfIC', 4, 'g', 'tanh', 'maxNumIterations', 5000, 'maxFinetune' , 500);
% figure; plot(time, icasig4(2,:));   grid on;
inputSignal = [time icasig4(2,:)'];

%% Create environment
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

Tf = time(end); 

rng(0);

% Network 
statePath = [
    imageInputLayer([numObservations 1 1], 'Normalization', 'none', 'Name', 'State')
    fullyConnectedLayer(64, 'Name', 'CriticStateFC1')
    reluLayer('Name', 'CriticRelu1')
    fullyConnectedLayer(32, 'Name', 'CriticStateFC2')
];
actionPath = [
    imageInputLayer([numActions 1 1],'Normalization','none','Name','Action')
    fullyConnectedLayer(32,'Name','CriticActionFC1')];
commonPath = [
    additionLayer(2,'Name','add')
    tanhLayer('Name','CriticCommonTanh')
    fullyConnectedLayer(1,'Name','CriticOutput')];

criticNetwork = layerGraph();

criticNetwork = addLayers(criticNetwork, statePath);
criticNetwork = addLayers(criticNetwork, actionPath);
criticNetwork = addLayers(criticNetwork, commonPath);
criticNetwork = connectLayers(criticNetwork, 'CriticStateFC2', 'add/in1');
criticNetwork = connectLayers(criticNetwork, 'CriticActionFC1', 'add/in2');

criticOpts = rlRepresentationOptions('LearnRate', 1e-03, 'GradientThreshold', 1, 'UseDevice', "gpu");

critic = rlQValueRepresentation(criticNetwork, obsInfo, actInfo, 'Observation', {'State'}, 'Action', {'Action'}, criticOpts);

actorNetwork = [
    imageInputLayer([numObservations 1 1], 'Normalization', 'none', 'Name', 'State')
    fullyConnectedLayer(4, 'Name', 'actorFC')
    tanhLayer('Name', 'actorTanh')
    fullyConnectedLayer(numActions, 'Name', 'Action')];

actorOptions = rlRepresentationOptions('LearnRate', 1e-03, 'GradientThreshold', 1, 'UseDevice', "gpu");

actor = rlDeterministicActorRepresentation(actorNetwork, obsInfo, actInfo, 'Observation', {'State'}, 'Action', {'Action'}, actorOptions);

% Agent
agentOpts = rlDDPGAgentOptions('SampleTime', Ts, 'TargetSmoothFactor', 1e-3, 'DiscountFactor', 1.0, 'MiniBatchSize', 64, 'ExperienceBufferLength', 1e6); 
agentOpts.NoiseOptions.Variance = 0.3;
agentOpts.NoiseOptions.VarianceDecayRate = 1e-5;

agent = rlDDPGAgent(actor, critic, agentOpts);

%% Train agent
maxepisodes = 800;
maxsteps = ceil(Tf/Ts);
trainOpts = rlTrainingOptions('MaxEpisodes', maxepisodes, 'MaxStepsPerEpisode', maxsteps, 'ScoreAveragingWindowLength', 20, 'Verbose', false, 'Plots', 'training-progress', 'StopTrainingCriteria', 'AverageReward', 'StopTrainingValue', 0);

trainingStats = train(agent, env, trainOpts);

simOpts = rlSimulationOptions('MaxSteps', maxsteps, 'StopOnError', 'on');
experiences = sim(env, agent, simOpts);

%% Test
Ts = 1;
load('sEMG_situations_4.mat');
Fs = 1000; % sampling frequency
N = length(TibialisAnteriorMuscle); % number of samples
time = (0 : N - 1)'/Fs; % discrete time
Tf = time(end); 

data = [TibialisAnteriorMuscle'; GastrocnemiusMedialHead'; GastrocnemiusLateralHead'; RectusFemorisMuscle'; AdductorMagnusMuscle'];
[icasig4] = fastica(data, 'numOfIC', 4, 'g', 'tanh', 'maxNumIterations', 5000, 'maxFinetune' , 500);
inputSignal = [time icasig4(2,:)'];
inputPedal = [time PedalInput];