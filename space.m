clc;
clear all;
close all;
n = randi([0,1],1,16384);
a = reshape(n,length(n),1);
bpskmod = pskmod(a,2);
snr = 0:1:30; 
h1 = 2+1j; h2 = 1-2j;
y = []; M= []; Op = []; OpwoutSTBC = []; 
q = 1;
for l = 1:length(snr) 
    for p = 1:2:length((n))-1 
        c1 = (h1*bpskmod(p,1))+(h2*bpskmod(p+1,1));
        M(p,q) = awgn(c1,snr(l),'measured'); 
        c2 = (-h1*conj(bpskmod(p+1,1)))+(h2*conj(bpskmod(p,1))); 
        M(p+1,q) = awgn(c2,snr(l),'measured');
    end 
    for r = 1:2:(length(n) -1 )
        y(r,q) = (conj(h1)*M(r,1)) + h2*conj(M(r+1,1)); 
        y(r+1,q) = (conj(h2)*M(r,1)) - h1*conj(M(r+1,1));
    end
    t1 = pskdemod(y,2);
    Op(l,:) = reshape (t1,1,length(n));
    [number,ratio] = biterr(Op,n); 
end 
semilogy(snr,ratio,'pentagram--C','Color','black') 
xlabel("SNR(in dB"); ylabel("BER"); hold on
%without STBC
for l = 1:length(snr) 
    rec = awgn((h1*bpskmod),snr(l),"measured");
    demod = pskdemod(rec,2); 
    OpwoutSTBC(l,:) = reshape(demod,1,length(n)); 
    [number1,ratio1] = biterr(OpwoutSTBC,n);
end 
semilogy(snr,ratio1,'-k') 
grid on 
legend('BER with STBC','BER without STBC')
xlabel("SNR(in dB"); ylabel("BER"); title("SNR vs BER")
