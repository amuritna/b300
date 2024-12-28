function dtmf_keypad
    % Create a figure for the GUI
    hFig = figure('Position', [100, 100, 300, 400], 'Name', 'DTMF Keypad', 'NumberTitle', 'off');
    
    % Define button labels
    button_labels = {'1', '2', '3'; '4', '5', '6'; '7', '8', '9'; '*', '0', '#'};
    
    % Create buttons
    for i = 1:4
        for j = 1:3
            uicontrol('Style', 'pushbutton', 'String', button_labels{i, j}, ...
                      'FontSize', 14, 'Position', [50 + (j-1)*70, 300 - (i-1)*70, 60, 60], ...
                      'Callback', @(src, event)play_tone(button_labels{i, j}));
        end
    end
end

function play_tone(digit)
    % Define DTMF frequencies
    dtmf_freqs = [697 770 852 941; 1209 1336 1477 0];
    
    % Define the DTMF mapping for digits 0-9, *, and #
    dtmf_map = containers.Map({'1', '2', '3', '4', '5', '6', '7', '8', '9', '0', '*', '#'}, ...
                              {[1 1], [1 2], [1 3], [2 1], [2 2], [2 3], [3 1], [3 2], [3 3], [4 2], [4 1], [4 3]});
    
    % Parameters
    Fs = 16000; % Sampling frequency
    duration = 0.02; % Duration of each tone in seconds
    num_samples = Fs * duration; % Number of samples per tone
    t = (0:num_samples-1) / Fs; % Time vector
    
    % Get the row and column for the digit
    row_col = dtmf_map(digit);
    row = row_col(1);
    col = row_col(2);
    
    % Generate the tone
    tone = sin(2 * pi * dtmf_freqs(1, row) * t) + sin(2 * pi * dtmf_freqs(2, col) * t);
    detect_dtmf(tone, Fs)
    
    % Play the tone
    sound(tone, Fs);
end

function detect_dtmf(dtmf_tone, dtmf_fs)

    % input dtmf tone: tone = sin(2 * pi * dtmf_freqs(1, row) * t) + sin(2 * pi * dtmf_freqs(2, col) * t);
    % to be multiplied with sin(2 * pi * dtmf_freqs(X) * t) and cos(2 * pi * dtmf_freqs(X) * t);

    dtmf_freqs = [697 770 852 941 1209 1336 1477 0];
    Fs = dtmf_fs;

    duration = 0.2; % Duration of each tone in seconds
    num_samples = Fs * duration; % Number of samples per tone
    t = (0:num_samples-1) / Fs; % Time vector
    
    % Lookup table
    lutSIN = [
        sin(2 * pi * dtmf_freqs(1) * t);
        sin(2 * pi * dtmf_freqs(2) * t);
        sin(2 * pi * dtmf_freqs(3) * t);
        sin(2 * pi * dtmf_freqs(4) * t);
        sin(2 * pi * dtmf_freqs(5) * t);
        sin(2 * pi * dtmf_freqs(6) * t);
        sin(2 * pi * dtmf_freqs(7) * t)
        ];

    lutCOS = [
        cos(2 * pi * dtmf_freqs(1) * t);
        cos(2 * pi * dtmf_freqs(2) * t);
        cos(2 * pi * dtmf_freqs(3) * t);
        cos(2 * pi * dtmf_freqs(4) * t);
        cos(2 * pi * dtmf_freqs(5) * t);
        cos(2 * pi * dtmf_freqs(6) * t);
        cos(2 * pi * dtmf_freqs(7) * t)
        ];
    

    size(dtmf_tone)
    size(lutSIN(1, 1:3200))

    format bank

    [
        sum(dtmf_tone .* lutSIN(1, 1:320))^2 + sum(dtmf_tone .* lutCOS(1, 1:320))^2
        sum(dtmf_tone .* lutSIN(2, 1:320))^2 + sum(dtmf_tone .* lutCOS(2, 1:320))^2
        sum(dtmf_tone .* lutSIN(3, 1:320))^2 + sum(dtmf_tone .* lutCOS(3, 1:320))^2
        sum(dtmf_tone .* lutSIN(4, 1:320))^2 + sum(dtmf_tone .* lutCOS(4, 1:320))^2
        sum(dtmf_tone .* lutSIN(5, 1:320))^2 + sum(dtmf_tone .* lutCOS(5, 1:320))^2
        sum(dtmf_tone .* lutSIN(6, 1:320))^2 + sum(dtmf_tone .* lutCOS(6, 1:320))^2
        sum(dtmf_tone .* lutSIN(7, 1:320))^2 + sum(dtmf_tone .* lutCOS(7, 1:320))^2
    ]


end
