%% sEMG signal classification using DNN - TRAN Gia Quoc Bao

% Default commands
clc;
clear all;
close all;

%% Load data
Ts = 1;
load('sEMG_situations_1.mat');
Fs = 1000; % sampling frequency
N = length(TibialisAnteriorMuscle); % number of samples
time = (0 : N - 1)'/Fs; % discrete time

%% Processing
% [magnitudeTibialisAnteriorMuscle, frequencyTibialisAnteriorMuscle] = Spectrum('Tibialis Anterior Muscle sEMG signal', TibialisAnteriorMuscle, Fs);

data = [TibialisAnteriorMuscle'; GastrocnemiusMedialHead'; GastrocnemiusLateralHead'; RectusFemorisMuscle'; AdductorMagnusMuscle'];

% figure('Name', 'All the sEMG signals');
% subplot(511);
% plot(time, data(1,:));
% subplot(512);
% plot(time, data(2,:));
% subplot(513);
% plot(time, data(3,:));
% subplot(514);
% plot(time, data(4,:));
% subplot(515);
% plot(time, data(5,:));

%% 2 features: not so good - too few features
% [icasig2] = fastica(data, 'numOfIC', 2, 'g', 'tanh', 'maxNumIterations', 2000, 'maxFinetune' , 200);
% figure('Name', 'Extraction - 2 features');
% subplot(211);   plot(time, icasig2(1,:)); xlim([0 263]);  grid on; set(gca, 'FontSize', 12); title('First estimated component');
% subplot(212);   plot(time, icasig2(2,:)); xlim([0 263]);  grid on; set(gca, 'FontSize', 12); title('Second estimated component');

%% 3 features: the middle one OK
% [icasig3] = fastica(data, 'numOfIC', 3, 'g', 'tanh', 'maxNumIterations', 2000, 'maxFinetune' , 200);
% figure('Name', 'Extraction - 3 features');
% subplot(311);   plot(time, icasig3(1,:));   grid on;
% subplot(312);   plot(time, icasig3(2,:));   grid on;
% subplot(313);   plot(time, icasig3(3,:));   grid on;

%% 4 features: the 2nd one is good
[icasig4] = fastica(data, 'numOfIC', 4, 'g', 'tanh', 'maxNumIterations', 5000, 'maxFinetune' , 500);
% figure('Name', 'Extraction - 4 features');
% subplot(411);   plot(time, icasig4(1,:)); xlim([0 263]); set(gca, 'FontSize', 10); grid on; title('First estimated component');
% subplot(412);   plot(time, icasig4(2,:)); xlim([0 263]); set(gca, 'FontSize', 10); grid on; title('Second estimated component');
% subplot(413);   plot(time, icasig4(3,:)); xlim([0 263]); set(gca, 'FontSize', 10); grid on; title('Third estimated component');
% subplot(414);   plot(time, icasig4(4,:)); xlim([0 263]); set(gca, 'FontSize', 10); grid on; title('Fourth estimated component');
% figure; plot(time, icasig4(1,:));   grid on;

%% 5 features: the 1st one is just as good as the last case
[icasig5] = fastica(data, 'numOfIC', 5, 'g', 'tanh', 'maxNumIterations', 2000, 'maxFinetune' , 200);
% figure('Name', 'Extraction - 5 features');
% subplot(511);   plot(time, icasig5(1,:)); xlim([0 263]); set(gca, 'FontSize', 10); grid on; title('First estimated component');
% subplot(512);   plot(time, icasig5(2,:)); xlim([0 263]); set(gca, 'FontSize', 10); grid on; title('Second estimated component');
% subplot(513);   plot(time, icasig5(3,:)); xlim([0 263]); set(gca, 'FontSize', 10); grid on; title('Third estimated component');
% subplot(514);   plot(time, icasig5(4,:)); xlim([0 263]); set(gca, 'FontSize', 10); grid on; title('Fourth estimated component');
% subplot(515);   plot(time, icasig5(5,:)); xlim([0 263]); set(gca, 'FontSize', 10); grid on; title('Fifth estimated component');