% Analyze signals in frequency domain - TRAN Gia Quoc Bao

function [magnitudePositiveFrequencies, frequency] = Spectrum(nameOfSignal, sig, fs)

% This function is to analyze signals in frequency domain.
% Input: signal's name, signal samples, and sampling frequency
% Output: plot of signal's FFT, with zero-padding

% This is to find the power of 2 nearest and bigger than the signal's size.
% In other words, for visual improvements using zero-padding:
N = length(sig);
P = pow2(ceil(log2(N)));

% This is to find the FFT:
fft_of_signal_0pad = fft(sig, P)/P;
fft_of_signal_0pad = fftshift(fft_of_signal_0pad);
magnitude = abs(fft_of_signal_0pad);

% Then we need to multiply this by 2 because we deleted half of the FFT 
% => lost half the power. So we get this power back by multiplying by 2.
% Still we will not get the exact amplitude for each component because the 
% zero-padding will redistribute the signal's power.

magnitudePositiveFrequencies = 2*magnitude(P/2 : end);
i = -(P - 1)/2 : (P - 1)/2;
F = i/P*fs;
frequency = F(P/2 : end);

figure();
plot(frequency, magnitudePositiveFrequencies);
grid on;
set(gca, 'FontSize', 20);
xlim([0 fs/2]); % the FFT only exists from 0 to half of the sampling frequency
xlabel("Frequency (Hz)");
ylabel("Magnitude");
title("The magnitude spectrum of the " +nameOfSignal);
legend("The magnitude spectrum of the " +nameOfSignal);

% The reason why we divided the fft by the signal's length (line 9) is 
% because we want to normalise this FFT so later we can compare 2 ffts.
% For example, if 2 signals s1 and s2 have peaks at the same frequency f 
% but the peak of s1 is higher, we say that f is less important to s2 
% than to s1. We need normalization to compare across different signals.