rng(666);

[ic_y_lp,mxmt_y_lp,unmxmt_y_lp] = fastica(y_lp)

plot(data.t,ic_y_lp)

[ic_y_notch,mxmt_y_notch,unmxmt_y_notch] = fastica(y_notch)

plot(data.t,ic_y_notch)

[ic_y_hp,mxmt_y_hp,unmxmt_y_hp] = fastica(y_hp)

plot(data.t,ic_y_hp)