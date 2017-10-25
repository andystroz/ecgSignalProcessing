function y = graphCompareFFT(x,y,Fs,Fs2)

%% Computing and Plotting Amplitude Spectrum
L = length(x)
Y = fft(x)
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;

Lw = length(y)
Yw = fft(y)
P2w = abs(Yw/Lw);
P1w = P2w(1:Lw/2+1);
P1w(2:end-1) = 2*P1w(2:end-1);
fw = Fs2*(0:(Lw/2))/Lw;




figure
subplot(2,1,1)       % add first plot in 2 x 1 grid
plot(f,P1) 
ylim([0 0.1])
title('Amplitude Spectrum of ECG Signal')
xlabel('f (Hz)')
ylabel('|P1(f)|')

subplot(2,1,2)       % add second plot in 2 x 1 grid
plot(fw,P1w) 
ylim([0 0.1])
title('Amplitude Spectrum of ECG Signal')
xlabel('f (Hz)')
ylabel('|P1(f)|')
