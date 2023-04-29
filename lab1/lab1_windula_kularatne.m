%% 1. Plot the Raw EEG data.

% Loading the data using "load"
% After loading the data, you should have "t", "Fs", "channelnames", 
% "spread", "signal" -variables available

% Your code here
data = load("EEGdata.mat")

t = data.t
signal = data.signal
spread = data.spread
channelnames = data.channelnames

% Plot raw EEG signal
Fig1 = figure;
figure(Fig1);
% Using the 'spread' matrix by adding it to 'signal' to separate the data
% If you want to understand how the spread works in practice, plot the data
% without adding it to the signal.
plot(t, signal + spread);
title('Raw EEG signal');
xlabel('time');
ylabel('amplitude');
legend(channelnames);

%% 2.1 Lowpass, notch and highpass filters greated via filter design tool

% Create filters according to the instructions using "fdatool".
% Copy the code from created filters AT THE END OF THIS FILE!
lp_fir=FIR_LP()
notch = IIR_notch()
hp_fir = FIR_HP()

%% 2.2.Filtering the EEG signal

% Filtering noise, PLI, and trends:

% Lowpass filter the raw eeg (signal) using "filter" function:
% Syntax: filtered_signal = filter(filter_function, signal_to_be_filtered)

lp_signal = filter(FIR_LP,signal)% Your code here

% Apply the IIR notch filter as a forwards & backwards filter for the
% previously LP filtered signal. NOTE! "filtfilt" accepts only the filter
% coefficients a and b!

% Get filter coefficients a (Denominator) and b (Numerator) from Notch
% filter function
a = IIR_notch().Denominator;
b = IIR_notch().Numerator % your code here

% Notch filter the signal using "filtfilt"
% Syntax: filtered_signal = filtfilt(b, a, signal_to_be_filtered)
% Note, that you are supposed to apply the IIR notch filter for the
% previously LP filtered signal (lp_signal), not raw eeg.

notch_signal = filtfilt(b,a,lp_signal)% your code here

% Highpass filter the previously Notch filtered signal (notch_signal)
% Use "filter" function
% Syntax: filtered_signal = filter(filter_function, signal_to_be_filtered)

hp_signal = filter(FIR_HP,notch_signal) % your code here

% Plotting the filtered EEG signal
% Note: plot (hp_signal + spread)
% Your code here
title('Filtered EEG signal');
plot(t, hp_signal + spread);
xlabel('time');
ylabel('amplitude');
legend(channelnames);


%% 3. Adaptive Filtering

% Using the 'dsp.LMSfilter' function. Default method: LMS

LMS_filter = dsp.LMSFilter('Length', 11, 'StepSize', 0.6, 'WeightsOutputPort', false);

% Using the LMS filter object to filter each previously LP, notch, and HP
% filtered EEGdata (hp_signal) individually using the EOG1 and EOG2
% channels (Ch14 and Ch15).
%
% Syntax: [out1, out2] = step(LMSfilter, eog_channel_in, eeg_signal_matrix_in))

% Storing the final LP, notch, and HP filtered EEG signal in a variable
filtered_signal = hp_signal;

% EOG1 (ch14):
for j=1:10; %10 iterations to stabilize the filter
    for i=1:size(filtered_signal,2); % size returns the size of the matrix
        [out1, out2] = step(LMS_filter, filtered_signal(:,14), filtered_signal(:,i));
        filtered_signal(:,i) = out2;
    end
end

% Plotting EOG1 LMS filtered EEG signals using the time vector t

% Your code here:
% Note: plot (filtered_signal + spread);
title('EOG1 LMS filtered EEG signal');
plot(t, filtered_signal + spread);
xlabel('time');
ylabel('amplitude');
% EOG2 (ch15):
% Make similar for loop for EOG2 (ch15) as done before for EOG1
% Your code here
for j=1:10; %10 iterations to stabilize the filter
    for i=1:size(filtered_signal,2); % size returns the size of the matrix
        [out1, out2] = step(LMS_filter, filtered_signal(:,15), filtered_signal(:,i));
        filtered_signal(:,i) = out2;
    end
end


% Plotting now EOG1 and EOG2 LMS filtered EEG signals
% Note: plot (filtered_signal + spread)
% Your code here:
title('EOG1 and EOG2 LMS filtered EEG signal');
title('EOG1 LMS filtered EEG signal');
plot(t, filtered_signal + spread);
xlabel('time');
ylabel('amplitude');


%% 4. BSS artifact removal with Independent Component Analysis (ICA

% setting the random number generator
rng(666);

% Use previously LP, notch, and HP filtered EEG signal (hp_signal) as an 
% input. DO NOT use the LMS filtered signals.

% Transpose "icasig_rescaled" for plotting
hp_signal_transpose = hp_signal' % your code here

% Use the FastICA toolbox command "fastica" to generate ICA decomposition
% for transposed signal. Syntax: [icasig, A, W] = fastica(input_signal);
[icasig, A, W] = fastica(hp_signal_transpose)% your code here

% Rescale "icasig" for plotting (e.g., divide by 100):
icasig_rescaled = icasig./100 % your code here

% Plotting the ICs of the EEG signal

% Transpose "icasig_rescaled" for plotting
transposed_icasig_rescaled = icasig_rescaled' % your code here

% Plot ICs of the EEG signal
% Note: plot (transposed_icasig_rescaled + spread);
% Your code here
title('ICs of the EEG signal');
plot(t, transposed_icasig_rescaled + spread);
xlabel('time');
ylabel('amplitude');
% Take a look of the ICs that you just plotted ("ICs of the EEG signal").
% Observe the ICs and note the components that are artifacts.
% Remove artifacts by zeroing those components from the IC matrix.
% For example for CH2: icasig(2, :) = 0. Note that there are more channels
% from which the artifacts should be removed!

icasig(1,:) = 0;

% Multiply the modified IC matrix "icasig" FROM THE LEFT with the mixing
% matrix "A"
modified_icasig = A*icasig % your code here

% Plot ICA BSS artifact cleaned EEG signals
% Transpose modified_icasig
modified_icasig_transpose = modified_icasig' % your code here

% Note: plot (modified_icasig_transpose + spread);
% your code here
title('Artefact cleaned EEG signal');
plot(t, modified_icasig_transpose + spread);
xlabel('time');
ylabel('amplitude');

%% Filters

% Copy the code from you your LP, HP and Notch filters here. 
% IMPORTANT: Add close parameter 'end' at the end of each function (all 
% functions in a script must be closed with an 'end')
%
% Example:
% % My cool filter
% function Hd = lp_filter
%   filter code here
% end 
%
function Hd = FIR_HP
%FIR_HP Returns a discrete-time filter object.

% MATLAB Code
% Generated by MATLAB(R) 9.13 and Signal Processing Toolbox 9.1.
% Generated on: 28-Mar-2023 19:07:04

% FIR least-squares Highpass filter designed using the FIRLS function.

% All frequency values are in Hz.
Fs = 200;  % Sampling Frequency

N     = 500;  % Order
Fstop = 0.1;  % Stopband Frequency
Fpass = 0.5;  % Passband Frequency
Wstop = 1;    % Stopband Weight
Wpass = 1;    % Passband Weight

% Calculate the coefficients using the FIRLS function.
b  = firls(N, [0 Fstop Fpass Fs/2]/(Fs/2), [0 0 1 1], [Wstop Wpass]);
Hd = dfilt.dffir(b);

% [EOF]

function Hd = FIR_LP
%FIR_LP Returns a discrete-time filter object.

% MATLAB Code
% Generated by MATLAB(R) 9.13 and DSP System Toolbox 9.15.
% Generated on: 28-Mar-2023 19:10:51

% FIR Window Lowpass filter designed using the FIR1 function.

% All frequency values are in Hz.
Fs = 200;  % Sampling Frequency

N    = 200;      % Order
Fc   = 90;       % Cutoff Frequency
flag = 'scale';  % Sampling Flag

% Create the window vector for the design algorithm.
win = hamming(N+1);

% Calculate the coefficients using the FIR1 function.
b  = fir1(N, Fc/(Fs/2), 'low', win, flag);
Hd = dfilt.dffir(b);

% [EOF]

function Hd = IIR_notch
%IIR_NOTCH Returns a discrete-time filter object.

% MATLAB Code
% Generated by MATLAB(R) 9.13 and DSP System Toolbox 9.15.
% Generated on: 28-Mar-2023 19:08:34

% IIR Notching filter designed using the IIRNOTCH function.

% All frequency values are in Hz.
Fs = 200;  % Sampling Frequency

Fnotch = 50;  % Notch Frequency
Q      = 35;  % Q-factor
Apass  = 3;   % Bandwidth Attenuation

BW = Fnotch/Q;

% Calculate the coefficients using the IIRNOTCHPEAK function.
[b, a] = iirnotch(Fnotch/(Fs/2), BW/(Fs/2), Apass);
Hd     = dfilt.df2(b, a);

% [EOF]