%% 1. Linear time series analysis

data = load('data_4.mat');

Fs = data.Fs;
t = data.t;
signal = data.signal;

t1 = data.t1;
t2 = data.t2;

% Calculate the spectrogram
window = 30 * Fs;
overlap = 29 * Fs;
[S, F, T, P] = spectrogram(signal, window, overlap, [0.1:0.1:32], Fs);

% Calculate spectral entropy
SE = zeros(1, size(P, 2));
for i = 1:size(P, 2)
    norm_P = P(:, i) / sum(P(:, i));
    SE(i) = -sum(norm_P .* log2(norm_P));
end

% Plot raw EEG signal, spectrogram, and spectral entropy
figure;
subplot(3, 1, 1);
plot(t, signal);
ylim([-1000 1000]);
title('Raw EEG Signal');

subplot(3, 1, 2);
imagesc(T, F, log10(P), [-4 6]);
axis xy;
title('Spectrogram');

subplot(3, 1, 3);
plot(T, SE);
title('Spectral Entropy');

% Store and plot EEG segments

ictal_period = (t1/60+5.2);

interictal_period = (t1/60+3);

signal1 = signal(:, t >= ictal_period(1) & t <= ictal_period(end));
signal2 = signal(:, t >= interictal_period(1) & t <= interictal_period(end));


figure;
subplot(2, 1, 1);
plot(t1, signal1);
ylim([-1000 1000]);
title('Ictal EEG Segment');

subplot(2, 1, 2);
plot(t1, signal2);
ylim([-1000 1000]);
title('Interictal EEG Segment');

%% 2. Nonlinear methods


ictal_segment = signal(208*Fs : 440*Fs);

figure;
plot(t2, ictal_segment);
ylim([-1000 1000]);
title('Raw EEG Segment');

delta = 67;
X = [ictal_segment(1:end-delta); ictal_segment(1+delta:end)];

% Define colors for 2D plot
preictal_start = 100 * Fs;
preictal_end = preictal_start + 10 * Fs;
ictal_end = preictal_end + 32 * Fs;
postictal_end = ictal_end + 10 * Fs;

figure;
hold on;
plot(X(1, 1:preictal_start), X(2, 1:preictal_start), 'r.');
plot(X(1, preictal_start:preictal_end), X(2, preictal_start:preictal_end), 'k.');
plot(X(1, preictal_end:ictal_end), X(2, preictal_end:ictal_end), 'c.');
plot(X(1, ictal_end:postictal_end), X(2, ictal_end:postictal_end), 'k.');
plot(X(1, postictal_end:end), X(2, postictal_end:end), 'r.');
title('2D Embedding');
hold off;

