%% sEMG signal denoising using Wiener filter _ TRAN Gia Quoc Bao

%% Default commands
close all;
clear all;
clc;

%% Convert to .mat for compatibility with MATLAB
% sEMG_1 = readtable('EMG_measurement_2.csv');
% TibialisAnteriorMuscle      = sEMG_1{:, 2};
% GastrocnemiusMedialHead     = sEMG_1{:, 3};
% GastrocnemiusLateralHead    = sEMG_1{:, 4};
% RectusFemorisMuscle         = sEMG_1{:, 5};
% AdductorMagnusMuscle        = sEMG_1{:, 6};
% PedalInput                  = sEMG_1{:, 7};
% save('sEMG_activities_2.mat', 'TibialisAnteriorMuscle', 'GastrocnemiusMedialHead', 'GastrocnemiusLateralHead', 'RectusFemorisMuscle', 'AdductorMagnusMuscle', 'PedalInput'); % save to .mat for later

%% Load & visualize signals

load('sEMG_situations_10.mat');
Fs = 1000; % sampling frequency
N = length(TibialisAnteriorMuscle); % number of samples
time = (0 : N - 1)'/Fs; % discrete time

% Get & store the mean values to add back later
meanTibialisAnteriorMuscle = mean(TibialisAnteriorMuscle); 
meanGastrocnemiusMedialHead = mean(GastrocnemiusMedialHead);
meanGastrocnemiusLateralHead = mean(GastrocnemiusLateralHead);
meanRectusFemorisMuscle = mean(RectusFemorisMuscle);
meanAdductorMagnusMuscle = mean(AdductorMagnusMuscle);

% Detrending
TibialisAnteriorMuscle = TibialisAnteriorMuscle - meanTibialisAnteriorMuscle;
GastrocnemiusMedialHead = GastrocnemiusMedialHead - meanGastrocnemiusMedialHead;
GastrocnemiusLateralHead = GastrocnemiusLateralHead - meanGastrocnemiusLateralHead;
RectusFemorisMuscle = RectusFemorisMuscle - meanRectusFemorisMuscle;
AdductorMagnusMuscle = AdductorMagnusMuscle - meanAdductorMagnusMuscle;

% figure('Name', 'Visualization of sEMG signals', 'NumberTitle', 'off');
% subplot(511);
% plot(time, TibialisAnteriorMuscle, 'LineWidth', 1);
% xlim([0 263.33]);
% grid on;
% set(gca, 'FontSize', 20);
% xlabel('Time (seconds)');
% ylabel('sEMG (\muV)');
% title('Activities of the tibialis anterior muscle');
% axes('position', [0.5 0.15 0.3 0.3]);
% box on;
% indexOfInterest = (50 < time & time < 52);
% plot(time(indexOfInterest), TibialisAnteriorMuscle(indexOfInterest), 'LineWidth', 1);
% grid on;
% subplot(512);
% plot(time, GastrocnemiusMedialHead, 'LineWidth', 1);
% grid on;
% set(gca, 'FontSize', 10);
% xlabel('Time (seconds)');
% ylabel('sEMG (\muV)');
% title('Activities of the gastrocnemius medial head');
% subplot(513);
% plot(time, GastrocnemiusLateralHead, 'LineWidth', 1);
% grid on;
% set(gca, 'FontSize', 10);
% xlabel('Time (seconds)');
% ylabel('sEMG (\muV)');
% title('Activities of the gastrocnemius lateral head');
% subplot(514);
% plot(time, RectusFemorisMuscle, 'LineWidth', 1);
% grid on;
% set(gca, 'FontSize', 10);
% xlabel('Time (seconds)');
% ylabel('sEMG (\muV)');
% title('Activities of the rectus femoris muscle');
% subplot(515);
% plot(time, AdductorMagnusMuscle, 'LineWidth', 1);
% grid on;
% set(gca, 'FontSize', 10);
% xlabel('Time (seconds)');
% ylabel('sEMG (\muV)');
% title('Activities of the adductor magnus muscle');

%% Obtain & visualize the signals' Power Spectral Density

Nblocks = 512; % size of the blocks for which the FFT is calculated
rec = round(3*Nblocks/4) ; % 75pc overlap between blocks

% We estimate the spectrum on Nblocks + 1 points, i.e. with a spectral 
% resolution of Fs / (2 * Nblocks)
% [PSD_TibialisAnteriorMuscle Freq_TibialisAnteriorMuscle] = pwelch(TibialisAnteriorMuscle, hanning(Nblocks), rec, 2*Nblocks, Fs);  
% [PSD_GastrocnemiusMedialHead Freq_GastrocnemiusMedialHead] = pwelch(GastrocnemiusMedialHead, hanning(Nblocks), rec, 2*Nblocks, Fs);
% [PSD_GastrocnemiusLateralHead Freq_GastrocnemiusLateralHead] = pwelch(GastrocnemiusLateralHead, hanning(Nblocks), rec, 2*Nblocks, Fs);
% [PSD_RectusFemorisMuscle Freq_RectusFemorisMuscle] = pwelch(RectusFemorisMuscle, hanning(Nblocks), rec, 2*Nblocks, Fs);
% [PSD_AdductorMagnusMuscle Freq_AdductorMagnusMuscle] = pwelch(AdductorMagnusMuscle, hanning(Nblocks), rec, 2*Nblocks, Fs);

% figure('Name', 'Visualization of PSD of signals', 'NumberTitle', 'off');
% subplot(511);
% plot(Freq_TibialisAnteriorMuscle, 10*log10(PSD_TibialisAnteriorMuscle), 'LineWidth', 4); % magnitude in decibel
% grid on;
% set(gca, 'FontSize', 20);
% xlabel('Frequency (Hz)');
% ylabel('Magnitude (dB)');
% title('Power spectral density (in dB) of the observed tibialis anterior muscle signal');
% subplot(512);
% plot(Freq_GastrocnemiusMedialHead, 10*log10(PSD_GastrocnemiusMedialHead), 'LineWidth', 4); % magnitude in decibel
% grid on;
% set(gca, 'FontSize', 20);
% xlabel('Frequency (Hz)');
% ylabel('Magnitude (dB)');
% title('Power spectral density (in dB) of the observed gastrocnemius medial head signal');
% subplot(513);
% plot(Freq_GastrocnemiusLateralHead, 10*log10(PSD_GastrocnemiusLateralHead), 'LineWidth', 4); % magnitude in decibel
% grid on;
% set(gca, 'FontSize', 20);
% xlabel('Frequency (Hz)');
% ylabel('Magnitude (dB)');
% title('Power spectral density (in dB) of the observed gastrocnemius lateral head signal');
% subplot(514);
% plot(Freq_RectusFemorisMuscle, 10*log10(PSD_RectusFemorisMuscle), 'LineWidth', 4); % magnitude in decibel
% grid on;
% set(gca, 'FontSize', 20);
% xlabel('Frequency (Hz)');
% ylabel('Magnitude (dB)');
% title('Power spectral density (in dB) of the observed rectus femoris muscle signal');
% subplot(515);
% plot(Freq_AdductorMagnusMuscle, 10*log10(PSD_AdductorMagnusMuscle), 'LineWidth', 4); % magnitude in decibel
% grid on;
% set(gca, 'FontSize', 20);
% xlabel('Frequency (Hz)');
% ylabel('Magnitude (dB)');
% title('Power spectral density (in dB) of the observed adductor magnus muscle signal');

%% Signal filtering
% 3.1/N < 0.5*(deltaF)/Fs = 0.5*4/1000 = 1/500 
Nrif = 1500;

[auto_TibialisAnteriorMuscle, lags] = xcorr(TibialisAnteriorMuscle, 'unbiased');

% figure('Name', 'Autocorrelation of y');
% plot(lags/Fs, auto_TibialisAnteriorMuscle, 'LineWidth', 2); 
% grid on;
% set(gca, 'FontSize', 20);
% xlabel('Time (s)');
% ylabel('Autocorrelation of y');
% title('Autocorrelation of y');

M = 0.033*Fs; 
% Signal 1: 0.035; 2: 0.033; 3: 0.038; 4: 0.039; 5: 0.036; 6: 0.037; 
% 7: 0.034; 8: 0.036; 9: 0.034; 10: 0.033
TibialisAnteriorMuscle = TibialisAnteriorMuscle(M + 1 : end); % y now designates the observed signal
GastrocnemiusMedialHead = GastrocnemiusMedialHead(M + 1 : end);
GastrocnemiusLateralHead = GastrocnemiusLateralHead(M + 1 : end);
RectusFemorisMuscle = RectusFemorisMuscle(M + 1 : end);
AdductorMagnusMuscle = AdductorMagnusMuscle(M + 1 : end);

L = length(TibialisAnteriorMuscle); % signal size observed (in number of samples)
time = time(M + 1 : end) ; % time domain associated with y (in seconds)

TibialisAnteriorMuscle_Delayed = TibialisAnteriorMuscle(1 : L); % signal y delayed by M samples
GastrocnemiusMedialHead_Delayed = GastrocnemiusMedialHead(1 : L);
GastrocnemiusLateralHead_Delayed = GastrocnemiusLateralHead(1 : L);
RectusFemorisMuscle_Delayed = RectusFemorisMuscle(1 : L);
AdductorMagnusMuscle_Delayed = AdductorMagnusMuscle(1 : L);

% To build matrix gamma_sy we do as said earlier:
[inter_TibialisAnteriorMuscle, lags] = xcorr(TibialisAnteriorMuscle, TibialisAnteriorMuscle_Delayed, Nrif, 'unbiased');
inter_TibialisAnteriorMuscle = inter_TibialisAnteriorMuscle((Nrif + 1) : end);

[inter_GastrocnemiusMedialHead, lags] = xcorr(GastrocnemiusMedialHead, GastrocnemiusMedialHead_Delayed, Nrif, 'unbiased');
inter_GastrocnemiusMedialHead = inter_GastrocnemiusMedialHead((Nrif + 1) : end);

[inter_GastrocnemiusLateralHead, lags] = xcorr(GastrocnemiusLateralHead, GastrocnemiusLateralHead_Delayed, Nrif, 'unbiased');
inter_GastrocnemiusLateralHead = inter_GastrocnemiusLateralHead((Nrif + 1) : end);

[inter_RectusFemorisMuscle, lags] = xcorr(RectusFemorisMuscle, RectusFemorisMuscle_Delayed, Nrif, 'unbiased');
inter_RectusFemorisMuscle = inter_RectusFemorisMuscle((Nrif + 1) : end);

[inter_AdductorMagnusMuscle, lags] = xcorr(AdductorMagnusMuscle, AdductorMagnusMuscle_Delayed, Nrif, 'unbiased');
inter_AdductorMagnusMuscle = inter_AdductorMagnusMuscle((Nrif + 1) : end);

lags = lags((Nrif + 1) : end)/Fs;  % in seconds
% To build matrix gamma_y we find the autocorrelation of y
auto_TibialisAnteriorMuscle = xcorr(TibialisAnteriorMuscle, TibialisAnteriorMuscle, Nrif, 'unbiased');
auto_TibialisAnteriorMuscle = auto_TibialisAnteriorMuscle((Nrif + 1) : end);

auto_GastrocnemiusMedialHead = xcorr(GastrocnemiusMedialHead, GastrocnemiusMedialHead, Nrif, 'unbiased');
auto_GastrocnemiusMedialHead = auto_GastrocnemiusMedialHead((Nrif + 1) : end);

auto_GastrocnemiusLateralHead = xcorr(GastrocnemiusLateralHead, GastrocnemiusLateralHead, Nrif, 'unbiased');
auto_GastrocnemiusLateralHead = auto_GastrocnemiusLateralHead((Nrif + 1) : end);

auto_RectusFemorisMuscle = xcorr(RectusFemorisMuscle, RectusFemorisMuscle, Nrif, 'unbiased');
auto_RectusFemorisMuscle = auto_RectusFemorisMuscle((Nrif + 1) : end);

auto_AdductorMagnusMuscle = xcorr(AdductorMagnusMuscle, AdductorMagnusMuscle, Nrif, 'unbiased');
auto_AdductorMagnusMuscle = auto_AdductorMagnusMuscle((Nrif + 1) : end);

% Plot the results
% figure('Name', 'Correlations');
% subplot(211);
% plot(lags, inter_TibialisAnteriorMuscle, 'LineWidth', 4); 
% xlim([0 0.2]);
% grid on;
% set(gca, 'FontSize', 20);
% xlabel('Time [s]');
% ylabel('Intercorrelation signal - noise');
% title('Estimated intercorrelation between the observed signal and the periodic noise');
% subplot(212);
% plot(lags, auto_TibialisAnteriorMuscle, 'LineWidth', 4); 
% xlim([0 0.2]);
% grid on;
% set(gca, 'FontSize', 20);
% xlabel('Time [s]');
% ylabel('Autocorrelation of the observed signal');
% title('Estimated autocorrelation of the observed signal');

% The filter's response is found by solving the Wiener-Hopf equation: gamma_sy = gamma_y*w 
gamma_y_TibialisAnteriorMuscle = toeplitz(auto_TibialisAnteriorMuscle);
gamma_sy_TibialisAnteriorMuscle = inter_TibialisAnteriorMuscle;
w_TibialisAnteriorMuscle = (inv(gamma_y_TibialisAnteriorMuscle))*gamma_sy_TibialisAnteriorMuscle;

gamma_y_GastrocnemiusMedialHead = toeplitz(auto_GastrocnemiusMedialHead);
gamma_sy_GastrocnemiusMedialHead = inter_GastrocnemiusMedialHead;
w_GastrocnemiusMedialHead = (inv(gamma_y_GastrocnemiusMedialHead))*gamma_sy_GastrocnemiusMedialHead;

gamma_y_GastrocnemiusLateralHead = toeplitz(auto_GastrocnemiusLateralHead);
gamma_sy_GastrocnemiusLateralHead = inter_GastrocnemiusLateralHead;
w_GastrocnemiusLateralHead = (inv(gamma_y_GastrocnemiusLateralHead))*gamma_sy_GastrocnemiusLateralHead;

gamma_y_RectusFemorisMuscle = toeplitz(auto_RectusFemorisMuscle);
gamma_sy_RectusFemorisMuscle = inter_RectusFemorisMuscle;
w_RectusFemorisMuscle = (inv(gamma_y_RectusFemorisMuscle))*gamma_sy_RectusFemorisMuscle;

gamma_y_AdductorMagnusMuscle = toeplitz(auto_AdductorMagnusMuscle);
gamma_sy_AdductorMagnusMuscle = inter_AdductorMagnusMuscle;
w_AdductorMagnusMuscle = (inv(gamma_y_AdductorMagnusMuscle))*gamma_sy_AdductorMagnusMuscle;

% From here we can filter the signal
noise_TibialisAnteriorMuscle_Est = filter(w_TibialisAnteriorMuscle, 1, TibialisAnteriorMuscle_Delayed);
noise_GastrocnemiusMedialHead_Est = filter(w_GastrocnemiusMedialHead, 1, GastrocnemiusMedialHead_Delayed);
noise_GastrocnemiusLateralHead_Est = filter(w_GastrocnemiusLateralHead, 1, GastrocnemiusLateralHead_Delayed);
noise_RectusFemorisMuscle_Est = filter(w_RectusFemorisMuscle, 1, RectusFemorisMuscle_Delayed);
noise_AdductorMagnusMuscle_Est = filter(w_AdductorMagnusMuscle, 1, AdductorMagnusMuscle_Delayed);
% And then subtract the estimated noise from the signal for the estimated x
TibialisAnteriorMuscle_Filtered = TibialisAnteriorMuscle - noise_TibialisAnteriorMuscle_Est;
GastrocnemiusMedialHead_Filtered = GastrocnemiusMedialHead - noise_GastrocnemiusMedialHead_Est;
GastrocnemiusLateralHead_Filtered = GastrocnemiusLateralHead - noise_GastrocnemiusLateralHead_Est;
RectusFemorisMuscle_Filtered = RectusFemorisMuscle - noise_RectusFemorisMuscle_Est;
AdductorMagnusMuscle_Filtered = AdductorMagnusMuscle - noise_AdductorMagnusMuscle_Est;

%% Verify results
% [PSD_Noise_TibialisAnteriorMuscle_Est Freq_Noise_TibialisAnteriorMuscle_Est] = pwelch(noise_TibialisAnteriorMuscle_Est, hanning(Nblocks), rec, 2*Nblocks, Fs); 
% [PSD_TibialisAnteriorMuscle_Filtered Freq_TibialisAnteriorMuscle_Filtered] = pwelch(TibialisAnteriorMuscle_Filtered, hanning(Nblocks), rec, 2*Nblocks, Fs); 

% figure('Name', 'Results in spectral domain');
% plot(Freq_TibialisAnteriorMuscle, 10*log10(PSD_TibialisAnteriorMuscle), 'b', Freq_Noise_TibialisAnteriorMuscle_Est, 10*log10(PSD_Noise_TibialisAnteriorMuscle_Est), 'k', Freq_TibialisAnteriorMuscle_Filtered, 10*log10(PSD_TibialisAnteriorMuscle_Filtered), 'r', 'LineWidth', 2); % magnitude in decibel
% plot(Freq_TibialisAnteriorMuscle, 10*log10(PSD_TibialisAnteriorMuscle), 'b', Freq_TibialisAnteriorMuscle_Filtered, 10*log10(PSD_TibialisAnteriorMuscle_Filtered), 'r', 'LineWidth', 2); % magnitude in decibel
% grid on;
% set(gca, 'FontSize', 20);
% xlabel('Frequency (Hz)');
% ylabel('Magnitude (dB)');
% legend('PSD of the observed tibialis anterior muscle signal', 'PSD of the estimated noise', 'PSD of the filtered tibialis anterior muscle signal');
% legend('PSD of the observed tibialis anterior muscle signal', 'PSD of the filtered tibialis anterior muscle signal');
% title('Results in spectral domain');

%% Now we re-add the mean to get the full signal
TibialisAnteriorMuscle_Filtered = TibialisAnteriorMuscle_Filtered + meanTibialisAnteriorMuscle;
TibialisAnteriorMuscleOriginal = TibialisAnteriorMuscle + meanTibialisAnteriorMuscle;

GastrocnemiusMedialHead_Filtered = GastrocnemiusMedialHead_Filtered + meanGastrocnemiusMedialHead;
GastrocnemiusMedialHeadOriginal = GastrocnemiusMedialHead + meanGastrocnemiusMedialHead;

GastrocnemiusLateralHead_Filtered = GastrocnemiusLateralHead_Filtered + meanGastrocnemiusLateralHead;
GastrocnemiusLateralHeadOriginal = GastrocnemiusLateralHead + meanGastrocnemiusLateralHead;

RectusFemorisMuscle_Filtered = RectusFemorisMuscle_Filtered + meanRectusFemorisMuscle;
RectusFemorisMuscleOriginal = RectusFemorisMuscle + meanRectusFemorisMuscle;

AdductorMagnusMuscle_Filtered = AdductorMagnusMuscle_Filtered + meanAdductorMagnusMuscle;
AdductorMagnusMuscleOriginal = AdductorMagnusMuscle + meanAdductorMagnusMuscle;

% figure('Name', 'Visualization of sEMG signals', 'NumberTitle', 'off');
% subplot(211);
% plot(time, TibialisAnteriorMuscleOriginal, 'b'); 
% grid on;
% set(gca, 'FontSize', 14);
% xlabel('Time (seconds)');
% ylabel('sEMG (\muV)');
% xlim([0 262.667]);
% title('The tibialis anterior muscle signal before filtering');
% axes('position', [0.2 0.55 0.15 0.15]);
% box on;
% indexOfInterest = (50 < time & time < 52);
% plot(time(indexOfInterest), TibialisAnteriorMuscleOriginal(indexOfInterest), 'LineWidth', 1);
% grid on;
% subplot(212);
% plot(time, TibialisAnteriorMuscle_Filtered, 'r', 'LineWidth', 1);
% grid on;
% set(gca, 'FontSize', 14);
% xlabel('Time (seconds)');
% ylabel('sEMG (\muV)');
% xlim([0 262.667]);
% title('The tibialis anterior muscle signal after filtering');
% axes('position', [0.2 0.05 0.15 0.15]);
% box on;
% indexOfInterest = (50 < time & time < 52);
% plot(time(indexOfInterest), TibialisAnteriorMuscle_Filtered(indexOfInterest), 'LineWidth', 1);
% grid on;

%% Save to database
%save('TibialisAnteriorMuscle_activities_filtered_10', 'TibialisAnteriorMuscle_Filtered'); % save to .mat for later
save('data_situations_filtered_10', 'TibialisAnteriorMuscle_Filtered', 'GastrocnemiusMedialHead_Filtered', 'GastrocnemiusLateralHead_Filtered', 'RectusFemorisMuscle_Filtered', 'AdductorMagnusMuscle_Filtered'); % save to .mat for later