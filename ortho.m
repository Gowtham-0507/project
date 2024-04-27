clc;clear all;close all;
x=randi([0,1],1,4096);
snr=0:30;
biterror=[];
for i=1:4
     if(i==1)
     y=pskmod(x,2^i);
     end
     if(i==2)
     y=pskmod(x,2^i);
     end
     if(i==3)
     y=qammod(x,2^(i+1));
     end
     if(i==4)
     y=qammod(x,2^(i+2));
     end
     p=reshape(y,64,64);
     q=ifft(p,64);
     s=reshape(q,1,4096);
     be=[];
     for j=0:1:30
         h=1/sqrt(rand(1,1)+i*sqrt(rand(1,1)));
         r=h*s;
         n=awgn(r,j,'measured');
         m=inv(h)*n;
         p1=reshape(m,64,64);
         q1=fft(p1,64);
         s1=reshape(q1,1,4096);
         if(i==1)
            y1=pskdemod(s1,2);
         end
         if(i==2)
            y1=pskdemod(s1,4);
         end
         if(i==3)
            y1=qamdemod(s1,16);
         end
         if(i==4)
            y1=qamdemod(s1,64);
         end
         [num,e]=symerr(y1,x);
         be=[be e];
         end
     biterror(i,:)=be;
end
semilogy(snr,biterror(1,:),'k');hold on;
semilogy(snr,biterror(2,:),'m');hold on;
semilogy(snr,biterror(3,:),'r');hold on;
semilogy(snr,biterror(4,:),'b');hold on;
xlabel('SNR(dB)');ylabel('BER');
title('SNR VS BER');legend('BPSK','QPSK','16QAM','64QAM');
