clc;

WAV_SRC = '../input_audio_32kHz.wav';

% input audio
[yt, Fs] = audioread(WAV_SRC); 
N = 16;
t = 0:15;
xn = yt((N*200)+1:N*201).'; % Z(100, :);

% built-in function
f_bi = fft(xn);
subplot(211);
plot(t, abs(real(f_bi)));
hold on;
plot(t, abs(imag(f_bi)));
hold off;
title('built-in FFT');

% manual function
f_man = fft16(xn);
subplot(212); 
plot(t, abs(real(f_man)));
hold on;
plot(t, abs(imag(f_man)));
hold off;
title('manual FFT');

% function declaration
function y = fft16(x)
[x1, x2, x3, x4, y] = deal(zeros(16, 1));

% 8 x 2 computations
for mm = 0:1:7
    twiddle = exp(-2*pi*1i*mm*1/16);
    x1(mm+1) = x(mm+1)  + x(mm+9);
    x1(mm+9) = (x(mm+1) - x(mm+9)) * twiddle;
end

% 4 x 4 computations
for mm = 0:1:3
   	twiddle = exp(-2*pi*1i*mm*1/8);
   	x2(mm+1)  = x1(mm+1)  + x1(mm+5);
   	x2(mm+5)  = (x1(mm+1) - x1(mm+5)) * twiddle;
   	x2(mm+9)  = (x1(mm+9) + x1(mm+13));
   	x2(mm+13)  = (x1(mm+9) - x1(mm+13)) * twiddle;
end

% 2 x 8 computations
for mm = 0:1:1
   	twiddle = exp(-2*pi*1i*mm*1/4);

   	x3(mm+1)  = x2(mm+1)  + x2(mm+3);
   	x3(mm+3)  = (x2(mm+1) - x2(mm+3)) * twiddle;
   	x3(mm+5)  = (x2(mm+5) + x2(mm+7));
   	x3(mm+7)  = (x2(mm+5) - x2(mm+7)) * twiddle;
   	x3(mm+9)  = (x2(mm+9) + x2(mm+11));
   	x3(mm+11)  = (x2(mm+9) - x2(mm+11)) * twiddle;  
   	x3(mm+13)  = (x2(mm+13) + x2(mm+15));
   	x3(mm+15)  = (x2(mm+13) - x2(mm+15)) * twiddle; 	
end

% 16 computations
twiddle = exp(-2*pi*1i*0*1/2);

x4(1) = x3(1)  + x3(2);
x4(2) = (x3(1)  - x3(2)) * twiddle;
x4(3) = x3(3)  + x3(4);
x4(4) = (x3(3)  - x3(4)) * twiddle;
x4(5) = x3(5)  + x3(6);
x4(6) = (x3(5)  - x3(6)) * twiddle;
x4(7) = x3(7)  + x3(8);
x4(8) = (x3(7)  - x3(8)) * twiddle;
x4(9) = x3(9)  + x3(10);
x4(10) = (x3(9)  - x3(10)) * twiddle;
x4(11) = x3(11)  + x3(12);
x4(12) = (x3(11)  - x3(12)) * twiddle;
x4(13) = x3(13)  + x3(14);
x4(14) = (x3(13)  - x3(14)) * twiddle;
x4(15) = x3(15)  + x3(16);
x4(16) = (x3(15)  - x3(16)) * twiddle;
         
%reorder
y(1) = x4(1);
y(2) = x4(9);
y(3) = x4(5);
y(4) = x4(13);
y(5) = x4(3);
y(6) = x4(11);
y(7) = x4(7);
y(8) = x4(15);
y(9) = x4(2);
y(10) = x4(10);
y(11) = x4(6);
y(12) = x4(14);
y(13) = x4(4);
y(14) = x4(12);
y(15) = x4(8);
y(16) = x4(16);

end