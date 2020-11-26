%% sEMG signal denoising using classical filters - TRAN Gia Quoc Bao

% The steps are:
% 1. Perform frequency domain analysis (use function Spectrum.m)
% 2. Decide the filter's specifications
% 3. Calculate the filter's coefficients
% 4. Analyze the designed filter (using the function FilterVisu.m)
% 5. Apply the filter to the signal
% 6. Check the filtered signal in frequency domain (use function Spectrum.m)
% 7. Compare results

%% Default commands
clear all;
close all;
clc;

%% Analyze signals

load('sEMG_1.mat');
Fs = 1000; % sampling frequency
N = length(TibialisAnteriorMuscle); % number of samples
time = (0 : N - 1)'/Fs; % discrete time

% Step 1
% [magnitudeTibialisAnteriorMuscle, frequencyTibialisAnteriorMuscle] = Spectrum('Tibialis Anterior Muscle sEMG signal', TibialisAnteriorMuscle, Fs);
% [magnitudeGastrocnemiusMedialHead, frequencyGastrocnemiusMedialHead] = Spectrum('Gastrocnemius Medial Head sEMG signal', GastrocnemiusMedialHead, Fs);
% [magnitudeGastrocnemiusLateralHead, frequencyGastrocnemiusLateralHead] = Spectrum('Gastrocnemius Lateral Head sEMG signal', GastrocnemiusLateralHead, Fs);
% [magnitudeRectusFemorisMuscle, frequencyRectusFemorisMuscle] = Spectrum('Rectus Femoris Muscle sEMG signal', RectusFemorisMuscle, Fs);
% [magnitudeAdductorMagnusMuscle, frequencyAdductorMagnusMuscle] = Spectrum('Adductor Magnus Muscle sEMG signal', AdductorMagnusMuscle, Fs);

%% Digital low-pass FIR filter

% Step 2
fc1 = 2*50/Fs; % the cut frequency is 50 Hz - need to decide
deltaWindow1 = 0.005;
sizeWindow1 = round(3.3/deltaWindow1 - 1);

% Step 3
filter1 = fir1(sizeWindow1, fc1, 'low'); 

% Step 4
% [magnitude1, phase1, frequency1] = FilterVisu('low-pass filter', filter1, 1, sizeWindow1, Fs);

% Step 5
TibialisAnteriorMuscle_Filtered1 = filter(filter1, 1, TibialisAnteriorMuscle);
GastrocnemiusMedialHead_Filtered1 = filter(filter1, 1, GastrocnemiusMedialHead);
GastrocnemiusLateralHead_Filtered1 = filter(filter1, 1, GastrocnemiusLateralHead);
RectusFemorisMuscle_Filtered1 = filter(filter1, 1, RectusFemorisMuscle);
AdductorMagnusMuscle_Filtered1 = filter(filter1, 1, AdductorMagnusMuscle);

% Step 6
% [magnitudeTibialisAnteriorMuscle_Filtered1, frequencyTibialisAnteriorMuscle_Filtered1] = Spectrum('Tibialis Anterior Muscle sEMG signal after filter 1 (low-pass)', TibialisAnteriorMuscle_Filtered1, Fs);
% [magnitudeGastrocnemiusMedialHead_Filtered1, frequencyGastrocnemiusMedialHead_Filtered1] = Spectrum('Gastrocnemius Medial Head sEMG signal after filter 1 (low-pass)', GastrocnemiusMedialHead_Filtered1, Fs);
% [magnitudeGastrocnemiusLateralHead_Filtered1, frequencyGastrocnemiusLateralHead_Filtered1] = Spectrum('Gastrocnemius Lateral Head sEMG signal after filter 1 (low-pass)', GastrocnemiusLateralHead_Filtered1, Fs);
% [magnitudeRectusFemorisMuscle_Filtered1, frequencyRectusFemorisMuscle_Filtered1] = Spectrum('Rectus Femoris Muscle sEMG signal after filter 1 (low-pass)', RectusFemorisMuscle_Filtered1, Fs);
% [magnitudeAdductorMagnusMuscle_Filtered1, frequencyAdductorMagnusMuscle_Filtered1] = Spectrum('Adductor Magnus Muscle sEMG signal after filter 1 (low-pass)', AdductorMagnusMuscle_Filtered1, Fs);

%% Step 7
figure();
subplot(511);
plot(time, TibialisAnteriorMuscle, 'b', time, TibialisAnteriorMuscle_Filtered1, 'r');
grid on;
set(gca, 'FontSize', 12);
% xlabel('Time (seconds)');
ylabel('sEMG (\muV)');
legend('Original', 'Low-pass filtered', 'Location', 'northwest');
title('Activities of the tibialis anterior muscle');
subplot(512);
plot(time, GastrocnemiusMedialHead, 'b', time, GastrocnemiusMedialHead_Filtered1, 'r');
grid on;
set(gca, 'FontSize', 12);
% xlabel('Time (seconds)');
ylabel('sEMG (\muV)');
legend('Original', 'Low-pass filtered', 'Location', 'northwest');
title('Activities of the gastrocnemius medial head muscle');
subplot(513);
plot(time, GastrocnemiusLateralHead, 'b', time, GastrocnemiusLateralHead_Filtered1, 'r');
grid on;
set(gca, 'FontSize', 12);
% xlabel('Time (seconds)');
ylabel('sEMG (\muV)');
legend('Original', 'Low-pass filtered', 'Location', 'northwest');
title('Activities of the gastrocnemius lateral head muscle');
subplot(514);
plot(time, RectusFemorisMuscle, 'b', time, RectusFemorisMuscle_Filtered1, 'r');
grid on;
set(gca, 'FontSize', 12);
% xlabel('Time (seconds)');
ylabel('sEMG (\muV)');
legend('Original', 'Low-pass filtered', 'Location', 'northwest');
title('Activities of the rectus femoris muscle');
subplot(515);
plot(time, AdductorMagnusMuscle, 'b', time, AdductorMagnusMuscle_Filtered1, 'r');
grid on;
set(gca, 'FontSize', 12);
xlabel('Time (seconds)');
ylabel('sEMG (\muV)');
legend('Original', 'Low-pass filtered', 'Location', 'northwest');
title('Activities of the adductor magnus muscle');