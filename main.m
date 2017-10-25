%% Andrew Stroz, Xander Griff

%% Setup and Data Import
A = importdata('408A1_ECG_25.txt');
samples = 0:length(A)-1;         % Sample Indices Vector
Fs = 250;             % Sampling Frequency (Hz)
t = samples/Fs;         % Time Vector (seconds)

%% Plotting ECG data versus time
figure
plot(t,A); % 60 Seconds worth of data / 15000 samples at 250 Hz
title('ECG Signal');
xlabel('Time (s)');
ylabel('Voltage (V)');

%% Computing and Plotting Amplitude Spectrum
L = length(A)
Y = fft(A)
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;
figure
plot(f,P1);
ylim([0 0.1]);
title('Amplitude Spectrum of ECG Signal');
xlabel('f (Hz)');
ylabel('Magnitude |P1(f)|');
%% First 10 Seconds of ECG Signal Data
data = A - 8; %remove dc offset
figure
plot(t(1,1:(2501)),data(1:(2501),1)); 
title('First 10 Seconds of ECG Data');
xlabel('Time (s)');
ylabel('Voltage (V)');
data_10s = data(1:(2501),1);
time_10s = t(1,1:(2501));

% Visual Inspection on ECG QRS Peaks for the First 10 Seconds
% #     TIME
% 1     0.42
% 2     1.22
% 3     2.06
% 4     2.87
% 5     3.70
% 6     4.55
% 7     5.31
% 8     6.07
% 9     6.79
% 10    7.53
% 11    8.25
% 12    8.97
% 13    9.77

%% Last 10 Seconds

data_Last10s = data(12501:15000,1);
time_Last10s = t(1,12501:15000);

%% Average PQRST Period based on 10 Second Observations

pqrst_times = [0.42,1.22,2.06,2.87,3.70,4.55,5.31,6.07,6.79,7.53,8.25,8.97,9.77];
pqrst_length = length(pqrst_times) - 1;
d = 1;
periods = [];

for c = 1:pqrst_length
    period = pqrst_times(c+1) - pqrst_times(c);
    periods(d) = period;
    d = d + 1;
end

pqrst_avg_T = mean(periods);
pqrst_avg_f = 1 / pqrst_avg_T;

%% Calling QRS Detection Function for First 10s
[peaksFirst10s,locationsFirst10s,processedQRSDataFirst10s] = qrsTiming(data_10s,time_10s);
disp(locationsFirst10s)

%% Plotting of Results
figure
subplot(2,1,1)       
plot(time_10s,data_10s);
title('ECG Signal First 10 Seconds');
xlabel('Time (s)');
ylabel('Voltage (V)');

subplot(2,1,2)       
plot(time_10s,processedQRSDataFirst10s,locationsFirst10s,peaksFirst10s,'or'); 
title('QRS Detection on First 10 Seconds of ECG Signal');
xlabel('Time (s)');
ylabel('Voltage (V)');

%% Plotting of First 10s Detected Points
figure
plot(time_10s,data_10s,locationsFirst10s,data_10s((locationsFirst10s*250)+1),'or');
title('First 10 Seconds of ECG Data Dectected QRS Peaks');
xlabel('Time (s)');
ylabel('Voltage (V)');

%% Calling QRS Detection Function for Last 10s
[peaksLast10s,locationsLast10s,processedQRSDataLast10s] = qrsTiming(data_Last10s,time_Last10s);
disp(locationsLast10s)

%% Plotting of Results
figure
subplot(2,1,1)      
plot(time_Last10s,data_Last10s);
title('ECG Signal Last 10 Seconds');
xlabel('Time (s)');
ylabel('Voltage (V)');

subplot(2,1,2)       
plot(time_Last10s,processedQRSDataLast10s,locationsLast10s,peaksLast10s,'or');
title('QRS Detection on Last 10 Seconds of ECG Signal');
xlabel('Time (s)');
ylabel('Voltage (V)');

%% Plotting of Last 10s Detected Points
locLast = locationsLast10s-50;
locLast = uint32(locLast*250) + 1;
figure
plot(time_Last10s,data_Last10s,locationsLast10s,data_Last10s(locLast),'or');
title('Last 10 Seconds of ECG Data Dectected QRS Peaks');
xlabel('Time (s)');
ylabel('Voltage (V)');













