function [peaks,locations,qrsProcessed] = qrsTiming(data,timeScale)

%% Baseline Wander Filtering Strategies
% PURPOSE: Get ride of baseline wander, which will give us a flatter 
%          baseline signal for greater ease of QRS detection
%

% Step 1: Process signal with IIR Filter of 0.5 Hz Highpass
highpass = baselineWanderHighpassFilter;
z = filter(highpass,data);
% Step 2: Time Reversal
flipped = flipud(z);
% Step 3: Process signal with IIR Filter of 0.5 Hz Highpass
w = filter(highpass,flipped);
% Step 4: Time Reversal
blwFiltered = flipud(w);   

%% Powerline Interference Filtering Strategies
% PURPOSE: Filter out powerline interference (50/60Hz sinusoidal
%          interference) which makes delineation of lower amplitude signals
%          less reliable.

bandstop = powerlineInterferenceBandstopFilter;
pliFilteredBandstop = filter(bandstop,blwFiltered);

%% QRS Signal Preprocessing Strategies
% PURPOSE: Enhance QRS complex while eliminating or supressing irrelevant 
%          ECG signal components.


% STEPS:
%   STEP 1. Linear Filtration
%       * Center @ 10-25Hz with 5-10Hz bandwidth bandpass

qrsBandpass = qrsPreprocessingBandpass;
r = filter(qrsBandpass,pliFilteredBandstop);
flipped_r = flipud(r);
r = filter(qrsBandpass,flipped_r);
r = flipud(r);

%   STEP 2. Non-Linear Transformation
%       * Squaring of bandpass-filtered 
r(r<0) = 0; 
qrsProcessed = r.^2;

%% QRS Detection Strategies
% PURPOSE: Use the prominence of the QRS complex as a basis for heart
%          beat detection.


% STRATEGY: Amplitude threshold sensing plus added tests
% Using the MATLAB findpeaks function the height and location of the peaks
% are found with a minimum time seperation of 0.5 seconds and a height of
% 0.2
[pks,locs] = findpeaks(qrsProcessed,timeScale,'MinPeakDistance',0.2,'MinPeakHeight',0.5);

locations = locs;
peaks = pks;




