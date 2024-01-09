% Transmitter 
close all; clear all;

% Set the seed for the random number generator
rng(0, 'twister');  % You can use any integer value instead of 0

% Parameters
fs = 1e6;
fc = 433e6;

% PPM Generation
Nsymb = 100;
M = 16;
osr = 4;
nsample = M * osr;
iden_matrix = eye(M);

% Generate random data
data = randi([1, M], 1, Nsymb);

dictionary_ppm = iden_matrix;
sig_temp = dictionary_ppm(data, :)';
ppm_frame = reshape(sig_temp, 1, M * Nsymb);
frame_data = repelem(ppm_frame, 1, osr);
fd2 = reshape(frame_data, [], 1);

% Configure the transmitter
tx = sdrtx('Pluto');
tx.CenterFrequency = fc;
tx.BasebandSampleRate = fs;
tx.Gain = 0;
tx.ChannelMapping = 1;  % Adjust this based on your setup

% PPM data (fd2)
myrandom = fd2 + fd2 * 1j;  % Use complex numbers directly

% header + PPM data
header_seq1 = [1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0];
header_seq = repelem(header_seq1, 1, osr);
header = [zeros(1, 512) header_seq];  % Making Header in a single row

% seq_2 = horzcat(seq_1,seq_1);
header_data_ppm = horzcat(header, myrandom.');

% Ensure header_data_ppm is a column vector
header_data_ppm = header_data_ppm(:);

% Transmit the PPM signal (fd2)
tx.transmitRepeat(header_data_ppm(:));

% Time vector
t = (0:length(header_data_ppm) - 1) / fs;

% Plot real part
figure;
subplot(3, 1, 1);
plot(t, real(header_data_ppm), 'b');
xlabel('Time (s)');
ylabel('Amplitude');
title('Real part of Header and PPM Data');

% Plot imaginary part
subplot(3, 1, 2);
plot(t, imag(header_data_ppm), 'r');
xlabel('Time (s)');
ylabel('Amplitude');
title('Imaginary part of Header and PPM Data');

% Plot envelope (magnitude)
subplot(3, 1, 3);
plot(t, abs(header_data_ppm), 'g');
xlabel('Time (s)');
ylabel('Amplitude');
title('Envelope of Header and PPM Data');

% Save transmitted data and dictionary
save('transmitted_data.mat', 'header_data_ppm', 'dictionary_ppm');
