%% Setting up EEGLAB

data = load("data_3.mat");


Fs = data.Fs;
signal = data.signal;
t = data.t;
channelNames = data.channelNames;

figure; topoplot([],'channelLocations.locs','style','blank','electrodes','labelpoint');


%% Signal power and topographic analysis

window = 30 * Fs; % 30-second window
overlap = 29 * Fs; % 29-second overlap
F_desired = 0.1:0.1:32;

n_channels = size(signal, 1);
S = cell(n_channels, 1);
P = cell(n_channels, 1);
T = cell(n_channels, 1);
F = cell(n_channels, 1);


for ch = 1:n_channels
    [S{ch}, F{ch}, T{ch}, P{ch}] = spectrogram(signal(ch, :), window, overlap, F_desired, Fs);
end

% Calculate the total power in each of the 13 channels
total_power = zeros(n_channels, size(P{1}, 2));
for ch = 1:n_channels
    total_power(ch, :) = sum(P{ch});
end

% Plot the log10 of the total power at the 13 channels using the 'topoplot' function
time_points = [0, 2, 5, 7] * 60; % Time points in seconds (start, 2min, 5min, 7min)
time_idx = arrayfun(@(t) find(T{1} >= t, 1), time_points);

figure;
for i = 1:length(time_points)
    subplot(2, 2, i);
    topoplot(log10(total_power(:, time_idx(i))), 'channelLocations.locs', 'maplimits', 'maxmin');
    title(sprintf('Total Power at %d min', time_points(i) / 60));
    colorbar;
end


frontal_channels = [3,4,10,1]; 
rear_channels = [9,12,7,13];

frontal_sum = sum(total_power(frontal_channels, :));
rear_sum = sum(total_power(rear_channels, :));

% Plot the combined signals
figure;
hold on;
plot(T{1}/60, frontal_sum, 'b');
plot(T{1}/60, rear_sum, 'r');
hold off;
xlabel('Time (min)');
ylabel('Amplitude');
legend('Frontal Sum', 'Rear Sum');
title('Frontal and Rear Electrodes Combined Signals');

%% Relative powers and topographic analysis


% Calculate the relative power in the alpha and delta bands for each of the 13 channels
alpha_range = [8, 13];
delta_range = [0.1, 4];
alpha_idx = find(F{1} >= alpha_range(1) & F{1} <= alpha_range(2));
delta_idx = find(F{1} >= delta_range(1) & F{1} <= delta_range(2));

alpha_power = zeros(n_channels, size(P{1}, 2));
delta_power = zeros(n_channels, size(P{1}, 2));

for ch = 1:n_channels
    alpha_power(ch, :) = sum(P{ch}(alpha_idx, :)) ./ sum(P{ch});
    delta_power(ch, :) = sum(P{ch}(delta_idx, :)) ./ sum(P{ch});
end

% Plot the topographic maps of relative alpha and delta power
figure;
for i = 1:length(time_points)
    % Plot alpha power
    subplot(4, 2, 2 * i - 1);
    topoplot(alpha_power(:, time_idx(i)), 'channelLocations.locs', 'maplimits', [0, 1]);
    title(sprintf('Alpha Power at %d ', time_points(i) / 60));
    colorbar;

    % Plot delta power
    subplot(4, 2, 2 * i);
    topoplot(delta_power(:, time_idx(i)), 'channelLocations.locs', 'maplimits', [0, 1]);
    title(sprintf('Delta Power at %d ', time_points(i) / 60));
    colorbar;
end


