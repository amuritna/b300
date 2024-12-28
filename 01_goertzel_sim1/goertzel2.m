
% parameters
Fs = 16000; % Sampling frequency
duration = 0.02; % Duration of each tone in seconds
num_samples = Fs * duration; % Number of samples per tone
t = (0:num_samples-1) / Fs; % Time vector

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dtmf_freqs = [697 770 852 941; 1209 1336 1477 0];
dtmf_row = containers.Map({'1', '2', '3', '4', '5', '6', '7', '8', '9', '0', '*', '#'}, ...
                          {1, 2, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4});
dtmf_col = containers.Map({'1', '2', '3', '4', '5', '6', '7', '8', '9', '0', '*', '#'}, ...
                          {1, 2, 3, 1, 2, 3, 1, 2, 3, 2, 1, 3});

tones = [
    sin(2 * pi * dtmf_freqs(1, dtmf_row('1')) * t) + sin(2 * pi * dtmf_freqs(2, dtmf_col('1')) * t);
    sin(2 * pi * dtmf_freqs(1, dtmf_row('2')) * t) + sin(2 * pi * dtmf_freqs(2, dtmf_col('2')) * t);
    sin(2 * pi * dtmf_freqs(1, dtmf_row('3')) * t) + sin(2 * pi * dtmf_freqs(2, dtmf_col('3')) * t);
    sin(2 * pi * dtmf_freqs(1, dtmf_row('4')) * t) + sin(2 * pi * dtmf_freqs(2, dtmf_col('4')) * t);
    sin(2 * pi * dtmf_freqs(1, dtmf_row('5')) * t) + sin(2 * pi * dtmf_freqs(2, dtmf_col('5')) * t);
    sin(2 * pi * dtmf_freqs(1, dtmf_row('6')) * t) + sin(2 * pi * dtmf_freqs(2, dtmf_col('6')) * t);
    sin(2 * pi * dtmf_freqs(1, dtmf_row('7')) * t) + sin(2 * pi * dtmf_freqs(2, dtmf_col('7')) * t);
    sin(2 * pi * dtmf_freqs(1, dtmf_row('8')) * t) + sin(2 * pi * dtmf_freqs(2, dtmf_col('8')) * t);
    sin(2 * pi * dtmf_freqs(1, dtmf_row('9')) * t) + sin(2 * pi * dtmf_freqs(2, dtmf_col('9')) * t);
    sin(2 * pi * dtmf_freqs(1, dtmf_row('0')) * t) + sin(2 * pi * dtmf_freqs(2, dtmf_col('0')) * t);
    sin(2 * pi * dtmf_freqs(1, dtmf_row('*')) * t) + sin(2 * pi * dtmf_freqs(2, dtmf_col('*')) * t);
    sin(2 * pi * dtmf_freqs(1, dtmf_row('#')) * t) + sin(2 * pi * dtmf_freqs(2, dtmf_col('#')) * t)
    ];

testY1 = simGoertzel(tones(1,:), 697, Fs);
max(testY1)-min(testY1)
testY2 = simGoertzel(tones(1,:), 941, Fs);
max(testY2)-min(testY2)
testY3 = simGoertzel(tones(1,:), 1336, Fs);
max(testY3)-min(testY3)

%tiledlayout(3,1)
%nexttile
%plot(testY1)
%nexttile
%plot(testY2)
%nexttile
%plot(testY3)

plot(testY1)
hold on
plot(testY2)
plot(testY3)
hold off


% Generate the tone
sound(tones(1,:), Fs)
pause(0.2)
sound(tones(2,:), Fs)
pause(0.2)
sound(tones(3,:), Fs)
pause(0.2)
sound(tones(4,:), Fs)
pause(0.2)
sound(tones(5,:), Fs)
pause(0.2)
sound(tones(6,:), Fs)
pause(0.2)
sound(tones(7,:), Fs)
pause(0.2)
sound(tones(8,:), Fs)
pause(0.2)
sound(tones(9,:), Fs)
pause(0.2)
sound(tones(10,:), Fs)
pause(0.2)
sound(tones(11,:), Fs)
pause(0.2)
sound(tones(12,:), Fs)


function Y = simGoertzel(X, f, fs)
    c = 2 * cos(2 * pi * (f/fs))
    Y = zeros(size(X));
    % Y(1) = 0 because X(-1) = 0, Y(-1) = 0, Y(-2) = 0
    Y(2) = X(1); 

    for m = 3:length(Y)
        Y(m) = X(m-1) - Y(m-1) + (c * Y(m-2));
    end
end