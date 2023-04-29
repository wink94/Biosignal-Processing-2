
data = load("EEGdata.mat")

signal_data = data.signal
spread_data = data.spread

plot_data = signal_data + spread_data

time_data = data.t

plot(time_data,plot_data)