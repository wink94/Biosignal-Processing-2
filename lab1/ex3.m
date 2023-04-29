
lms = dsp.LMSFilter("Method","LMS","Length",11,StepSize=0.6,WeightsOutputPort='false')

num_channels = size(y_lp, 2);
num_iterations = 10;

eeg_y_lp_filtered_EOG1 = zeros(size(y_lp));
eeg_y_lp_filtered_EOG1_EOG2 = zeros(size(y_lp));
for channel = 1:num_channels
    for r = 1:num_iterations
         [~, eeg_y_lp_filtered_EOG1(:, channel)] = step(lms,  data.signal(:,end-1),y_lp(:,channel));
    end
    reset(lms)
    for r = 1:num_iterations
         [~, eeg_y_lp_filtered_EOG1_EOG2(:, channel)] = step(lms,eeg_y_lp_filtered_EOG1(:,end),eeg_y_lp_filtered_EOG1(:, channel));
    end
end
plot(data.t,eeg_y_lp_filtered_EOG1)
plot(data.t,eeg_y_lp_filtered_EOG1_EOG2)

reset(lms)
num_channels = size(y_notch, 2);
num_iterations = 10;

eeg_y_notch_filtered_EOG1 = zeros(size(y_notch));
eeg_y_notch_filtered_EOG1_EOG2 = zeros(size(y_notch));
for channel = 1:num_channels
    for r = 1:num_iterations
         [~, eeg_y_notch_filtered_EOG1(:, channel)] = step(lms,  data.signal(:,end-1),y_notch(:,channel));
    end
    reset(lms)
    for r = 1:num_iterations
         [~, eeg_y_notch_filtered_EOG1_EOG2(:, channel)] = step(lms,eeg_y_notch_filtered_EOG1(:,end),eeg_y_notch_filtered_EOG1(:, channel));
    end
end
plot(data.t,eeg_y_notch_filtered_EOG1)
plot(data.t,eeg_y_notch_filtered_EOG1_EOG2)


reset(lms)
num_channels = size(y_hp, 2);
num_iterations = 10;

eeg_y_hp_filtered_EOG1 = zeros(size(y_hp));
eeg_y_hp_filtered_EOG1_EOG2 = zeros(size(y_hp));
for channel = 1:num_channels
    for r = 1:num_iterations
         [~, eeg_y_hp_filtered_EOG1(:, channel)] = step(lms,  data.signal(:,end-1),y_hp(:,channel));
    end
    reset(lms)
    for r = 1:num_iterations
         [~, eeg_y_hp_filtered_EOG1_EOG2(:, channel)] = step(lms,eeg_y_hp_filtered_EOG1(:,end),eeg_y_hp_filtered_EOG1(:, channel));
    end
end
plot(data.t,eeg_y_hp_filtered_EOG1)
plot(data.t,eeg_y_hp_filtered_EOG1_EOG2)


