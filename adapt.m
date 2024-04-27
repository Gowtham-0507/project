clear all;
close all;
snr= randi([10,30],1,15);
snr=sort(snr);
err=[];
for i=1:length(snr)
    if(snr(i)>=0 && snr(i)<13)
    a=randi([0,1],1,1000);b=pskmod(a,2);
    end
    if(snr(i)>=13 && snr(i)<20)
    a=randi([0,3],1,1000); b=pskmod(a,4);
    end
    if(snr(i)>=20 && snr(i)<26)
    a=randi([0,15],1,1000); b=qammod(a,16);
    end
    if(snr(i)>=26 && snr(i)<=30)
    a=randi([0,63],1,1000);b=qammod(a,64);
    end
    N0=1/10^(snr(i)/10);
    g=awgn(b,snr(i));
    n=sqrt(N0/2)*(randn(1,length(a))+1i*randn(1,length(a)));
    f=g+n;
    if(snr(i)>=0 && snr(i)<13)
    d=pskdemod(f,2);
    end
    if(snr(i)>=13 && snr(i)<20)
    d=pskdemod(f,4);
    end
    if(snr(i)>=20 && snr(i)<26)
    d=qamdemod(f,16);
    end
    if(snr(i)>=26 && snr(i)<=30)
    d=qamdemod(f,64);
    end
    [n,r]=biterr(a,d);
    if(r==0)
    r=1e-7; end
    err=[err r];
end
subplot(2,1,1);semilogy(snr,err,'linewidth',1);
xlabel('SNR(db)');
ylabel('BER'); title({'AMC';'SNR Vs BER'});
thruput=[];
for i=1:length(snr)
    if(snr(i)>=0 && snr(i)<13)
    thruput=[thruput 1]; end
    if(snr(i)>=13 && snr(i)<20)
    thruput=[thruput 2]; end
    if(snr(i)>=20 && snr(i)<=25)
    thruput=[thruput 4]; end
    if(snr(i)>=26 && snr(i)<=30)
    thruput=[thruput 6];
    end
end
subplot(2,1,2); plot(snr ,thruput);
xlabel('SNR(db)'); ylabel('Throughput');
title({'AMC';'SNR Vs throughput'});s;
