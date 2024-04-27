clc; clear all; close all; s = zeros(1,256);
for i = 1:256
s(i) = i;
end
msg_1 = input('Enter the message for encryption: '); message = [];
message = [message double(char(msg_1))];
key = [2 4 6 8 2 1 6 1];
t = zeros(1,256);
for i = 1:256
t(i) = mod(i,length(key));
end
%KSA
i = 0; j =0;
for i = 1:256
j = mod(j+s(i)+t(i),256) + 1;
s([i j]) = s([j i]);
j = j-1;
end
%PRGA
i = 0; j = 0; k = [];
for m = 1:length(message)
i = mod(i+1,256);
j = mod(j + s(i),256);
s([i j]) = s([j i]);
k = [k s(mod(s(i) + s(j),256))];
end
encrypted_message = [];
for i = 1:length(message)
encrypted_message = [encrypted_message bitxor(message(i),k(i))];
end
disp("Encrypted Cipher Text: "); disp(char(encrypted_message)); decrypted_message = [];
for i = 1:length(message)
decrypted_message = [decrypted_message bitxor(encrypted_message(i),k(i))]; end
disp(decrypted_message)
disp('Deciphered message: '); disp(char(decrypted_message))
