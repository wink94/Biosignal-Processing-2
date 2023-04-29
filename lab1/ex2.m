
data = load("EEGdata.mat")

plot(data.t,data.signal);

spread_data = data.signal

Hd1=FIR_LP()

y_lp = Hd1.filter(spread_data);
plot(data.t,y_lp);


Hd2=IIR_notch()

y_notch = filtfilt(Hd2.Numerator,Hd2.Denominator,spread_data)
plot(data.t,y_notch)
% add titles


Hd3=FIR_HP()

y_hp = Hd3.filter(y_notch)
plot(data.t,y_hp)

