%% Deep reinforcement learning using a LSTM network _ TRAN Gia Quoc Bao

%% Default commands
close all;
clear all;
clc;

%% Environment
obsInfo = rlNumericSpec([2 1], 'LowerLimit', [-inf -inf]', 'UpperLimit', [inf inf]');
% obsInfo = rlNumericSpec([1 1], 'LowerLimit', [-inf]', 'UpperLimit', [inf]');
obsInfo.Name = 'observations';
obsInfo.Description = 'observations';
numObservations = obsInfo.Dimension(1);

actInfo = rlFiniteSetSpec([1 1]);
actInfo.Name = 'brake';
numActions = actInfo.Dimension(1);

env = rlSimulinkEnv('sEMG_DRL_LSTM', 'sEMG_DRL_LSTM/RL Agent', obsInfo, actInfo);
env.ResetFcn = @(in)localResetFcn(in);

%% Input
Ts = 1;
load('sEMG_situations_1.mat');
Fs = 1000; % sampling frequency
N1 = length(TibialisAnteriorMuscle); % number of samples
time = (0 : N1 - 1)'/Fs; % discrete time
inputSignal = [time TibialisAnteriorMuscle];
inputPedal = [time PedalInput];

Tf = time(end); 

%% Network
criticNetwork = [
    sequenceInputLayer(numObservations, 'Normalization', 'none', 'Name', 'State')
    fullyConnectedLayer(50, 'Name', 'CriticStateFC1')
    reluLayer('Name', 'CriticRelu1')
    lstmLayer(20, 'OutputMode', 'sequence', 'Name', 'CriticLSTM'); % bidirectional LSTM is not supported 
    fullyConnectedLayer(20, 'Name', 'CriticStateFC2')
    reluLayer('Name', 'CriticRelu2')
    fullyConnectedLayer(2, 'Name', 'Output')];
criticOptions = rlRepresentationOptions('LearnRate', 1e-3, 'GradientThreshold', 1, 'UseDevice', "gpu");
critic = rlQValueRepresentation(criticNetwork, obsInfo, actInfo, 'Observation', 'State', criticOptions);
agentOptions = rlDQNAgentOptions('UseDoubleDQN', false, 'TargetSmoothFactor', 5e-3, 'ExperienceBufferLength', 1e6, 'SequenceLength', 20);
agentOptions.EpsilonGreedyExploration.EpsilonDecay = 1e-4;
agent = rlDQNAgent(critic, agentOptions);

%plot(layerGraph(criticNetwork));

%% Training agent
maxepisodes = 1000;
maxsteps = ceil(Tf/Ts);
trainOpts = rlTrainingOptions('MaxEpisodes', maxepisodes, 'MaxStepsPerEpisode', maxsteps, 'ScoreAveragingWindowLength', 20, 'Verbose', false, 'Plots', 'training-progress', 'StopTrainingCriteria', 'AverageReward', 'StopTrainingValue', 0);

trainingStats = train(agent, env, trainOpts);

%simOpts = rlSimulationOptions('MaxSteps', maxsteps, 'StopOnError', 'on');
%experiences = sim(env, agent, simOpts);