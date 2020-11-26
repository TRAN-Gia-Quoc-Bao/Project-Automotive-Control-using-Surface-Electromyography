% Analyze digital filters - TRAN Gia Quoc Bao

function [magnitude, phase, frequency] = FilterVisu(nameOfFilter, b, a, numberOfPoints, numberOfFrequency)

% This function is to analyze designed digital filters.
% Input: filter's name, filter's transfer function, number of points, and
% number of frequency (we will take the sampling frequency)
% Output: plot of filter's poles-zeros, magnitude & phase of frequency response

figure();
% Plot pole and zeros (input numerator first, then denominator)
subplot(311);
zplane(b, a);
grid on;
set(gca, 'FontSize', 20);
title("Poles and zeros of the " +nameOfFilter);
% From the 1st plot: we can check the filter's stability.

% Plot magnitude & phase of frequency response & frequency vector
[h, w] = freqz(b, a, numberOfPoints, numberOfFrequency);
magnitude = abs(h);
phase = angle(h);
frequency = w;

subplot(312);
plot(frequency, magnitude);
grid on;
set(gca, 'FontSize', 20);
xlabel("Frequency (Hz)");
ylabel("Magnitude spectrum");
title("The magnitude spectrum of the " +nameOfFilter);
legend("The magnitude spectrum of the " +nameOfFilter);
% From the 2nd plot: we can check the filter's type (low pass,...) and
% other specifications: deltaFreq,...

subplot(313);
plot(frequency, phase);
grid on;
set(gca, 'FontSize', 20);
xlabel("Frequency (Hz)");
ylabel("Phase spectrum");
title("The phase spectrum of the " +nameOfFilter);
legend("The phase spectrum of the " +nameOfFilter);
% From the 3rd plot: we can check the phase shift with respect to frequency
% (which component is shifted forward/ delayed by how many radians)