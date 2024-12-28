
% parameters
Fs = 16000; % Sampling frequency
duration = 0.04; % Duration of each tone in seconds
num_samples = Fs * duration; % Number of samples per tone
t = (0:num_samples-1) / Fs; % Time vector

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dtmf_freqs = [697 770 852 941; 1209 1336 1477 0];
freq_indices = round(dtmf_freqs/Fs*num_samples) + 1;  
dtmf_row = containers.Map({'1', '2', '3', '4', '5', '6', '7', '8', '9', '0', '*', '#'}, ...
                          {1, 2, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4});
dtmf_col = containers.Map({'1', '2', '3', '4', '5', '6', '7', '8', '9', '0', '*', '#'}, ...
                          {1, 2, 3, 1, 2, 3, 1, 2, 3, 2, 1, 3});

tones = [
    [zeros(1, 320), sin(2 * pi * dtmf_freqs(1, dtmf_row('1')) * t) + sin(2 * pi * dtmf_freqs(2, dtmf_col('1')) * t), zeros(1, 320)];
    [zeros(1, 320), sin(2 * pi * dtmf_freqs(1, dtmf_row('2')) * t) + sin(2 * pi * dtmf_freqs(2, dtmf_col('2')) * t), zeros(1, 320)];
    [zeros(1, 320), sin(2 * pi * dtmf_freqs(1, dtmf_row('3')) * t) + sin(2 * pi * dtmf_freqs(2, dtmf_col('3')) * t), zeros(1, 320)];
    [zeros(1, 320), sin(2 * pi * dtmf_freqs(1, dtmf_row('4')) * t) + sin(2 * pi * dtmf_freqs(2, dtmf_col('4')) * t), zeros(1, 320)];
    [zeros(1, 320), sin(2 * pi * dtmf_freqs(1, dtmf_row('5')) * t) + sin(2 * pi * dtmf_freqs(2, dtmf_col('5')) * t), zeros(1, 320)];
    [zeros(1, 320), sin(2 * pi * dtmf_freqs(1, dtmf_row('6')) * t) + sin(2 * pi * dtmf_freqs(2, dtmf_col('6')) * t), zeros(1, 320)];
    [zeros(1, 320), sin(2 * pi * dtmf_freqs(1, dtmf_row('7')) * t) + sin(2 * pi * dtmf_freqs(2, dtmf_col('7')) * t), zeros(1, 320)];
    [zeros(1, 320), sin(2 * pi * dtmf_freqs(1, dtmf_row('8')) * t) + sin(2 * pi * dtmf_freqs(2, dtmf_col('8')) * t), zeros(1, 320)];
    [zeros(1, 320), sin(2 * pi * dtmf_freqs(1, dtmf_row('9')) * t) + sin(2 * pi * dtmf_freqs(2, dtmf_col('9')) * t), zeros(1, 320)];
    [zeros(1, 320), sin(2 * pi * dtmf_freqs(1, dtmf_row('0')) * t) + sin(2 * pi * dtmf_freqs(2, dtmf_col('0')) * t), zeros(1, 320)];
    [zeros(1, 320), sin(2 * pi * dtmf_freqs(1, dtmf_row('*')) * t) + sin(2 * pi * dtmf_freqs(2, dtmf_col('*')) * t), zeros(1, 320)];
    [zeros(1, 320), sin(2 * pi * dtmf_freqs(1, dtmf_row('#')) * t) + sin(2 * pi * dtmf_freqs(2, dtmf_col('#')) * t), zeros(1, 320)]
    ];

disp 'input: 697 Hz + 852 Hz; filter checks for 697 Hz'
Y1 = goertzel(tones(3,:), freq_indices);
max(Y1)-min(Y1);

disp 'input: 697 Hz + 852 Hz; filter checks for 852 Hz'
Y2 = goertzel(tones(3,:), freq_indices);
max(Y2)-min(Y2);

disp 'input: 697 Hz + 852 Hz; filter checks for 1336 Hz'
Y3 = goertzel(tones(3,:))
max(Y3)-min(Y3);

Y1
Y2
Y3

tiledlayout(4,1)
nexttile
plot(Y1)
nexttile
plot(Y2)
nexttile
plot(Y3)
nexttile
plot(tones(1,:))

function [Y, res] = simGoertzel(X, f, fs)
    c = 2 * cos(2 * pi * (f/fs));
    Y = zeros(size(X));
    res = zeros(size(X));

    % Y(1) = 0 because X(-1) = 0, Y(-1) = 0, Y(-2) = 0
    Y(2) = X(1); 

    for m = 3:length(Y)
        Y(m) = X(m-1) - Y(m-1) + (c * Y(m-2));
        res(m) = Y(m-2)^2 + Y(m-1)^2 %- (Y(m-2)*Y(m-1))
    end
end