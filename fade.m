clc, clear all; close all; 
fs = 4000; f1 = 1000; f2 = 400;
ts = 0:(1/fs):1-(1/fs); 
signal1 = exp(complex(0,2*pi*f1*ts)); 
signal2 = exp(complex(0,2*pi*f2*ts)); 
message = signal1+signal2; 
delayed = [zeros(1,77) message(1:length(message)-77)]; 
%FREQUENCY RESPONSE
freqres = fft(message); 
figure; 
magnitudeplot = abs(freqres); 
plot(1:fs,magnitudeplot); 
title({'Input Signal';'Frequency Response'}); 
xlabel('Frequency(Hz)'); 
ylabel('Amplitude(V)'); 
figure; freqres2=fft(delayed); 
plot(1:fs,abs(freqres2)); 
title({'Delayed Input signal';'Frequency Response'}); 
xlabel('Frequency(Hz)'); ylabel('Amplitude(V)');
%Slow and Flat Fading
h = randn + (1i*randn); 
y1 = message.*h; freqres = fft(y1); 
magnitudeplot = abs(fft(y1)); 
figure; plot(1:fs,magnitudeplot(1:fs)); title('Slow and Flat Fading'); xlabel('Frequency(Hz)'); ylabel('Amplitude(V)');
%Slow and Frequency Selective Fading
h1 = randn + (1i*randn); 
h2 = randn + (1i*randn); 
trans2 = (h1.*message) + (h2.*delayed); 
magnitudeplot = abs(fft(trans2)); 
figure; 
plot(1:fs,magnitudeplot); 
title('Slow and Frequency Selective Fading'); 
xlabel('Frequency(Hz)'); ylabel('Amplitude(V)');
%Fast and Flat Fading
fd = 10;
%doppler frequency 
hs = randi([0 1],1,length(ts)) +(1i*randi([0 1],1,length(ts))); 
[b,a] = butter(12,((2*fd)/1000)); 
lpf = filter(b,a,hs); 
trans3 = lpf.*message; 
magnitudeplot = abs(fft(trans3)); 
figure; 
plot(1:fs,magnitudeplot); title('Fast and Flat Fading'); xlabel('Frequency(Hz)'); ylabel('Amplitude(V)');
% Fast and Frequency Selective Fading
ht = randi([0 1],1,length(ts)) +1i*(randi([0 1],1,length(ts))); 
lpf1 = filter(b,a,ht); 
trans4 = (lpf1.*message) +(lpf1.*delayed); 
magnitudeplot = abs(fft(trans4)); 
figure; 
plot(1:fs,magnitudeplot); 
title('Fast and Frequency Selective Fading'); xlabel('Frequency(Hz)'); ylabel('Amplitude(V)');

