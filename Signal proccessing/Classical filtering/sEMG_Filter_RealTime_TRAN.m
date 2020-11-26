%% sEMG real-time signal denoising using classical filters - TRAN Gia Quoc Bao

%% Default commands
clear all;
close all;
clc;

%% Analyze signals

load('sEMG_1.mat');
Fs = 1000; % sampling frequency
N = length(TibialisAnteriorMuscle); % number of samples
time = (0 : N - 1)'/Fs; % discrete time

%% Digital low-pass FIR filtercv

fc1 = 2*50/Fs; % the cut frequency is 50 Hz - need to decide
deltaWindow1 = 0.005;
sizeWindow1 = round(3.3/deltaWindow1 - 1);
filter1 = fir1(sizeWindow1, fc1, 'low'); 

% Off-line filtering (just to comppare, not for use in practice)
TibialisAnteriorMuscle_Filtered1_Offline = filter(filter1, 1, TibialisAnteriorMuscle);
GastrocnemiusMedialHead_Filtered1_Offline = filter(filter1, 1, GastrocnemiusMedialHead);
GastrocnemiusLateralHead_Filtered1_Offline = filter(filter1, 1, GastrocnemiusLateralHead);
RectusFemorisMuscle_Filtered1_Offline = filter(filter1, 1, RectusFemorisMuscle);
AdductorMagnusMuscle_Filtered1_Offline = filter(filter1, 1, AdductorMagnusMuscle);

% Real-time filtering
TibialisAnteriorMuscle_Filtered1_Online = zeros(N, 1);
GastrocnemiusMedialHead_Filtered1_Online = zeros(N, 1);
GastrocnemiusLateralHead_Filtered1_Online = zeros(N, 1);
RectusFemorisMuscle_Filtered1_Online = zeros(N, 1);
AdductorMagnusMuscle_Filtered1_Online = zeros(N, 1);

zTibialisAnteriorMuscle_Filtered1 = zeros(1, length(filter1) - 1);
zGastrocnemiusMedialHead_Filtered1 = zeros(1, length(filter1) - 1);
zGastrocnemiusLateralHead_Filtered1 = zeros(1, length(filter1) - 1);
zRectusFemorisMuscle_Filtered1 = zeros(1, length(filter1) - 1);
zAdductorMagnusMuscle_Filtered1 = zeros(1, length(filter1) - 1);

horizonSize = 10; % explanation: each time we have horizonSize new samples, we perform filtering
movingHorizon = 0 : horizonSize : N;
for i = 1 : length(movingHorizon) - 1
  i1 = movingHorizon(i) + 1;
  i2 = movingHorizon(i + 1);
  [TibialisAnteriorMuscle_Filtered1_Online(i1 : i2), zTibialisAnteriorMuscle_Filtered1] = filter(filter1, 1, TibialisAnteriorMuscle(i1 : i2), zTibialisAnteriorMuscle_Filtered1);
  [GastrocnemiusMedialHead_Filtered1_Online(i1 : i2), zGastrocnemiusMedialHead_Filtered1] = filter(filter1, 1, GastrocnemiusMedialHead(i1 : i2), zGastrocnemiusMedialHead_Filtered1);
  [GastrocnemiusLateralHead_Filtered1_Online(i1 : i2), zGastrocnemiusLateralHead_Filtered1] = filter(filter1, 1, GastrocnemiusLateralHead(i1 : i2), zGastrocnemiusLateralHead_Filtered1);
  [RectusFemorisMuscle_Filtered1_Online(i1 : i2), zRectusFemorisMuscle_Filtered1] = filter(filter1, 1, RectusFemorisMuscle(i1 : i2), zRectusFemorisMuscle_Filtered1);
  [AdductorMagnusMuscle_Filtered1_Online(i1 : i2), zAdductorMagnusMuscle_Filtered1] = filter(filter1, 1, AdductorMagnusMuscle(i1 : i2), zAdductorMagnusMuscle_Filtered1);
end

%% Error between offline & real-time
errorTibialisAnteriorMuscle_Filtered1 = abs(TibialisAnteriorMuscle_Filtered1_Online - TibialisAnteriorMuscle_Filtered1_Offline);
errorGastrocnemiusMedialHead_Filtered1 = abs(GastrocnemiusMedialHead_Filtered1_Online - GastrocnemiusMedialHead_Filtered1_Offline);
errorGastrocnemiusLateralHead_Filtered1 = abs(GastrocnemiusLateralHead_Filtered1_Online - GastrocnemiusLateralHead_Filtered1_Offline);
errorRectusFemorisMuscle_Filtered1 = abs(RectusFemorisMuscle_Filtered1_Online - RectusFemorisMuscle_Filtered1_Offline);
errorAdductorMagnusMuscle_Filtered1 = abs(AdductorMagnusMuscle_Filtered1_Online - AdductorMagnusMuscle_Filtered1_Offline);

errorRMSTibialisAnteriorMuscle_Filtered1 = rms(TibialisAnteriorMuscle_Filtered1_Online - TibialisAnteriorMuscle_Filtered1_Offline);
errorRMSGastrocnemiusMedialHead_Filtered1 = rms(GastrocnemiusMedialHead_Filtered1_Online - GastrocnemiusMedialHead_Filtered1_Offline);
errorRMSGastrocnemiusLateralHead_Filtered1 = rms(GastrocnemiusLateralHead_Filtered1_Online - GastrocnemiusLateralHead_Filtered1_Offline);
errorRMSRectusFemorisMuscle_Filtered1 = rms(RectusFemorisMuscle_Filtered1_Online - RectusFemorisMuscle_Filtered1_Offline);
errorRMSAdductorMagnusMuscle_Filtered1 = rms(AdductorMagnusMuscle_Filtered1_Online - AdductorMagnusMuscle_Filtered1_Offline);

%% Plot results
figure(1);
subplot(511);
plot(time, TibialisAnteriorMuscle, 'g', time, TibialisAnteriorMuscle_Filtered1_Offline, 'b', time, TibialisAnteriorMuscle_Filtered1_Online, 'r');
grid on;
xlabel('Time (seconds)');
ylabel('sEMG (\muV)');
legend('Original', 'Offline low-pass filtered', 'Online low-pass filtered', 'Location', 'northwest');
title('Activities of the tibialis anterior muscle');
subplot(512);
plot(time, GastrocnemiusMedialHead, 'g', time, GastrocnemiusMedialHead_Filtered1_Offline, 'b', time, GastrocnemiusMedialHead_Filtered1_Online, 'r');
grid on;
xlabel('Time (seconds)');
ylabel('sEMG (\muV)');
legend('Original', 'Offline low-pass filtered', 'Online low-pass filtered', 'Location', 'northwest');
title('Activities of the gastrocnemius medial head');
subplot(513);
plot(time, GastrocnemiusLateralHead, 'g', time, GastrocnemiusLateralHead_Filtered1_Offline, 'b', time, GastrocnemiusLateralHead_Filtered1_Online, 'r');
grid on;
xlabel('Time (seconds)');
ylabel('sEMG (\muV)');
legend('Original', 'Offline low-pass filtered', 'Online low-pass filtered', 'Location', 'northwest');
title('Activities of the gastrocnemius lateral head');
subplot(514);
plot(time, RectusFemorisMuscle, 'g', time, RectusFemorisMuscle_Filtered1_Offline, 'b', time, RectusFemorisMuscle_Filtered1_Online, 'r');
grid on;
xlabel('Time (seconds)');
ylabel('sEMG (\muV)');
legend('Original', 'Offline low-pass filtered', 'Online low-pass filtered', 'Location', 'northwest');
title('Activities of the rectus femoris muscle');
subplot(515);
plot(time, AdductorMagnusMuscle, 'g', time, AdductorMagnusMuscle_Filtered1_Offline, 'b', time, AdductorMagnusMuscle_Filtered1_Online, 'r');
grid on;
xlabel('Time (seconds)');
ylabel('sEMG (\muV)');
legend('Original', 'Offline low-pass filtered', 'Online low-pass filtered', 'Location', 'northwest');
title('Activities of the adductor magnus muscle');

%% Plot errors
% figure(2);
% subplot(511);
% plot(time, errorTibialisAnteriorMuscle_Filtered1, 'r');
% grid on;
% xlabel('Time (seconds)');
% ylabel('sEMG (\muV)');
% title('Real-time - offline filtering error - tibialis anterior muscle');
% subplot(512);
% plot(time, errorGastrocnemiusMedialHead_Filtered1, 'r');
% grid on;
% xlabel('Time (seconds)');
% ylabel('sEMG (\muV)');
% title('Real-time - offline filtering error - gastrocnemius medial head');
% subplot(513);
% plot(time, errorGastrocnemiusLateralHead_Filtered1, 'r');
% grid on;
% xlabel('Time (seconds)');
% ylabel('sEMG (\muV)');
% title('Real-time - offline filtering error - gastrocnemius lateral head');
% subplot(514);
% plot(time, errorRectusFemorisMuscle_Filtered1, 'r');
% grid on;
% xlabel('Time (seconds)');
% ylabel('sEMG (\muV)');
% title('Real-time - offline filtering error - rectus femoris muscle');
% subplot(515);
% plot(time, errorAdductorMagnusMuscle_Filtered1, 'r');
% grid on;
% xlabel('Time (seconds)');
% ylabel('sEMG (\muV)');
% title('Real-time - offline filtering error - adductor magnus muscle');