clc; clear all; close all;
message = randi([0,1],1,10000);
snr = 0:2:40; mod = 2;
L = 2; r = 3;
n = length(message); M = 25; w = zeros(1,M);
wi = zeros(1,M); E = []; mu = 0.0005;
msg_bpsk = pskmod(message,mod);
ber_without_LMS = []; ber_with_LMS = [];
for k = 1:length(snr)
msg_rx = awgn(msg_bpsk, snr(k), 'measured');
for i = M:n
E(i) = msg_bpsk(i) - wi*msg_rx(i:-1:i-M+1)';
wi = wi + 2*mu*E(i)*msg_rx(i:-1:i-M+1);
end
msg_eq = zeros(n,1);
for i = M:n
j = msg_rx(i:-1:i-M+1);
msg_eq(i) = ((wi)*(j)');
end
Demod_with_LMS = pskdemod(msg_eq,mod)';
Demod_without_LMS = pskdemod(msg_rx,mod);
[n1,r1] = biterr(message,Demod_with_LMS);
[n2,r2] = biterr(message,Demod_without_LMS);
ber_without_LMS = [ber_without_LMS,r1];
ber_with_LMS = [ber_with_LMS,r2];
end
grid on;
semilogy(snr,ber_with_LMS,'
-*k','LineWidth',1.2);
hold on;
semilogy(snr,ber_without_LMS,'
--k','LineWidth',1.8)
hold on
title('SNR VS BER'); xlabel('SNR(dB)');ylabel('BER');
legend('BER WITHOUT EQUALIZATION','BER WITH LMS');
