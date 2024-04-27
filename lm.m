clc; clear all; close all;
message = randi([0,1],1,10000);
snr = 0:2:40; mod = 2;
L = 2; r = 3;
modulated_bpsk_msg = pskmod(message,mod);
h0 = 1; h1 = 0.7;
H = zeros(r,r+L-1);
for p = 1:r
H(p,p:p+L-1) = [h0 h1];
end
x = [];
X = modulated_bpsk_msg; X_1 = circshift(X,1);
X_1(1) = 0; X1 = circshift(X,-1);
X1(end) = 0; X2 = circshift(X,-2);
X2(end-1:end)= 0; x = [X2;X1;X;X_1];
C = ((H*H')\H)*[0;0;1;0];
ber_without_ZFE = []; ber_with_ZFE = [];
for p = 1:length(snr)
y = awgn([h0 h1]*[X;X_1],snr(p),'measured');
Noise = y - ([h0 h1]*[X;X_1]);
Noise_1 = circshift(Noise,-1);
Noise_1(end) = 0; Noise_2 = circshift(Noise,-2);
Noise_1(end-1:end) = 0;
Y = (H*x)+ [Noise_2;Noise_1;Noise]; X_PRIME = C.'*Y;
Demodulated_BPSK_msg_with_ZFE =pskdemod(X_PRIME',mod);
Demodulated_BPSK_msg_without_ZFE = pskdemod(y',mod);
[number1,ratio1] = biterr(message,Demodulated_BPSK_msg_with_ZFE');
[number2,ratio2] = biterr(message,Demodulated_BPSK_msg_without_ZFE');
ber_with_ZFE = [ber_with_ZFE,ratio1];
ber_without_ZFE = [ber_without_ZFE,ratio2];
end
semilogy(snr,ber_with_ZFE,'
-k','LineWidth',1.6)
hold on
semilogy(snr,ber_without_ZFE,'
--k','LineWidth',1.8)
hold on
title('SNR VS BER'); xlabel('SNR(dB)');ylabel('BER');
legend('BER WITHOUT EQUALIZATION','BER WITH ZFE');
