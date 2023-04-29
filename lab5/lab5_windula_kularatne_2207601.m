%% 1. Raw SSEP signals and ensemble averaging

data = load('data_5.mat');
data_samples = data.data_samples;

raw_data = data_samples.raw_data;
Fs = data_samples.Fs;
amplitude_unit = data_samples.amplitude_unit;

scaled_data = raw_data * amplitude_unit * 1e6;
ensemble_avg = mean(scaled_data);

t = (0:size(scaled_data, 2)-1) / Fs * 1e3;

figure;
plot(t, scaled_data');
hold on;
plot(t, ensemble_avg, 'k', 'LineWidth', 2);
xlabel('Time (ms)');
ylabel('Amplitude (μV)');
title('Raw SSEP Signals and Ensemble Average');



%% 2. SNR estimation

M = size(scaled_data, 1);
N = size(scaled_data, 2);

sigma_v2_n = sum((scaled_data - ensemble_avg).^2) / M;
sigma_v2 = mean(sigma_v2_n);

Es_n = ensemble_avg.^2;
Es = mean(Es_n);

SNR = 10 * log10(Es / sigma_v2);
SNR_improvement = 20 * log10(sqrt(M));
SNR_avg_signal = SNR + SNR_improvement;


%% 3. Chirp modeling

% Edit chirp_features function to use 'lin' model and disable prefiltering
out = chirp_features(data_samples);

fitted_chirp = out.fitted_chirp;
chirp_delay = out.fit_delay;
first_peak_amp = out.fit_first_peak_amplitude;
second_peak_amp = out.fit_second_peak_amplitude;
first_peak_delay = out.fit_first_peak_location;
second_peak_delay = out.fit_second_peak_location;

figure;
plot(t, scaled_data');
hold on;
plot(t, ensemble_avg, 'k', 'LineWidth', 2);
plot(t, fitted_chirp, 'LineWidth', 2);
xlabel('Time (ms)');
ylabel('Amplitude (μV)');
title('Raw SSEP Signals, Ensemble Average and Fitted Chirp');

% Plot delays and amplitudes as dashed lines
y_lim = get(gca, 'YLim');
line([chirp_delay, chirp_delay]*1e3, y_lim, 'Color', 'k', 'LineStyle', '--');
line([first_peak_delay, first_peak_delay]*1e3, y_lim, 'Color', 'k', 'LineStyle', '--');
line([second_peak_delay, second_peak_delay]*1e3, y_lim, 'Color', 'k', 'LineStyle', '--');
line([0, max(t)], [first_peak_amp, first_peak_amp], 'Color', 'k', 'LineStyle', '--');
line([0, max(t)], [second_peak_amp, second_peak_amp], 'Color', 'k', 'LineStyle', '--');


