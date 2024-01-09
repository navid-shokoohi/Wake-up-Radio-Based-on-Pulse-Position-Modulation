% Receiver
fs = 1e6;
fc = 433e6;
SamplesPerFrame = 7152;
M = 16;
Nsymb = 100;

rng(0, 'twister');
data = randi([1, M], 1, Nsymb);

% Configure the receiver
rx = sdrrx('Pluto');
rx.CenterFrequency = fc;
rx.BasebandSampleRate = fs;
rx.Gain = 0;
rx.SamplesPerFrame = SamplesPerFrame;
rx.OutputDataType = "double";

% Receive the signal
receivedSignal = rx();

% Reshape the received signal to match the transmitted signal
receivedSignal = reshape(receivedSignal, [], 1);

% Cast received signal to double for comparison
receivedSignalDouble = double(receivedSignal);

% Load transmitted data and dictionary
load('transmitted_data.mat', 'header_data_ppm', 'dictionary_ppm');

% Extract the PPM part of header_data_ppm (excluding the header)
ppm_data_received = header_data_ppm(513:end);

% Reshape dictionary_ppm to match the size of ppm_data_received
dictionary_ppm = reshape(dictionary_ppm, [], 1);

% Perform cross-correlation between received signal and dictionary
correlation = xcorr(ppm_data_received, dictionary_ppm);

% Find the index of the maximum correlation
[~, maxIndex] = max(abs(correlation));

% Shift the received signal to align with the dictionary
receivedSignalDouble = circshift(receivedSignalDouble, [maxIndex-1, 0]);

% Time align received signal
receivedSignalDouble = circshift(receivedSignalDouble, [maxIndex-1, 0]);

% Trim the received signal to the appropriate length
receivedSignalDouble = receivedSignalDouble(1:length(dictionary_ppm));

% Perform envelope detection
envelope = abs(receivedSignalDouble);

% Scale received signal to match transmitted signal
scalingFactor = max(abs(data)) / max(envelope);
receivedSignalDouble = receivedSignalDouble * scalingFactor;

% ML decoding (simple approach, replace with your decoding algorithm)
[~, idx_ml] = max(envelope);

% Display the receivedSignalDouble and dictionary_ppm values
disp('receivedSignalDouble:');
disp(receivedSignalDouble(1:10).');
disp('dictionary_ppm:');
disp(dictionary_ppm(1:10).');

% Ensure that the dimensions match for element-wise multiplication
if numel(receivedSignalDouble) ~= numel(dictionary_ppm)
    error('Dimensions do not match for element-wise multiplication.');
end

% Perform element-wise multiplication
receivedSignalDouble = receivedSignalDouble .* dictionary_ppm;

% Display the receivedSignalDouble and dictionary_ppm values
disp('receivedSignalDouble after multiplication:');
disp(receivedSignalDouble(1:10).');
disp('dictionary_ppm:');
disp(dictionary_ppm(1:10).');

% Check if there are any NaN or Inf values in receivedSignalDouble or dictionary_ppm
if any(isnan(receivedSignalDouble)) || any(isinf(receivedSignalDouble))
    error('NaN or Inf values found in receivedSignalDouble.');
end

if any(isnan(dictionary_ppm)) || any(isinf(dictionary_ppm))
    error('NaN or Inf values found in dictionary_ppm.');
end

% Display the maximum correlation sum and index
disp("Maximum Correlation Sum: " + max(correlation));
disp("Maximum Correlation Index: " + maxIndex);

% Display the ML indices for each symbol
disp("ML Receiver Index: " + idx_ml);

% Evaluate if there are errors
min_length = min(length(idx_ml), length(data));
errors = sum(idx_ml(1:min_length) - 1 ~= data(1:min_length));
disp("Number of Errors: " + errors);

% Time align received signal
t_received_aligned = (0:length(receivedSignalDouble)-1) / fs;

% Trim the received time vector to the appropriate length
t_received_aligned = t_received_aligned(1:length(dictionary_ppm));

% Perform envelope detection
envelope = abs(receivedSignalDouble);

% Scale received signal to match transmitted signal
scalingFactor = max(abs(data)) / max(envelope);
receivedSignalDouble = receivedSignalDouble * scalingFactor;

% ML ( MAXIMUM LIKELIHOOD ) decoding (simple approach, replace with your decoding algorithm)
[~, idx_ml] = max(envelope);

% Display the receivedSignalDouble and dictionary_ppm values
disp('receivedSignalDouble:');
disp(receivedSignalDouble(1:10).');
disp('dictionary_ppm:');
disp(dictionary_ppm(1:10).');

% Ensure that the dimensions match for element-wise multiplication
if numel(receivedSignalDouble) ~= numel(dictionary_ppm)
    error('Dimensions do not match for element-wise multiplication.');
end

% Perform element-wise multiplication
receivedSignalDouble = receivedSignalDouble .* dictionary_ppm;

% Display the receivedSignalDouble and dictionary_ppm values
disp('receivedSignalDouble after multiplication:');
disp(receivedSignalDouble(1:10).');
disp('dictionary_ppm:');
disp(dictionary_ppm(1:10).');

% Check if there are any NaN or Inf values in receivedSignalDouble or dictionary_ppm
if any(isnan(receivedSignalDouble)) || any(isinf(receivedSignalDouble))
    error('NaN or Inf values found in receivedSignalDouble.');
end

if any(isnan(dictionary_ppm)) || any(isinf(dictionary_ppm))
    error('NaN or Inf values found in dictionary_ppm.');
end

% Display the maximum correlation sum and index
disp("Maximum Correlation Sum: " + max(correlation));
disp("Maximum Correlation Index: " + maxIndex);

% Display the ML indices for each symbol
disp("ML Receiver Index: " + idx_ml);

% Evaluate if there are errors
min_length = min(length(idx_ml), length(data));
errors = sum(idx_ml(1:min_length) - 1 ~= data(1:min_length));
disp("Number of Errors: " + errors);

% Time vector for transmitted signal
t_transmitted = (0:length(receivedSignal) - 1) / fs;

% Time vector for received signal
t_received = (0:length(receivedSignalDouble) - 1) / fs;

% Compare Tx and Rx signals visually
figure;
subplot(3, 1, 1);
plot(t_transmitted, real(receivedSignal), 'b');
xlabel('Time (s)');
ylabel('Amplitude');
title('Real part of Header and PPM Data');

subplot(3, 1, 2);
plot(t_transmitted, imag(receivedSignal), 'r');
xlabel('Time (s)');
ylabel('Amplitude');
title('Imaginary part of Header and PPM Data');


subplot(3, 1, 3);
plot(t_transmitted, abs(receivedSignal), 'g');
xlabel('Time (s)');
ylabel('Amplitude');
title('Envelope of Header and PPM Data');


% Display the transmitted and received symbol vectors
disp("Transmitted Symbol Vector: ");
disp(data);

disp("Received Symbol Vector: ");
disp(idx_ml);

% Evaluate if there are errors
errors = sum(idx_ml(1:min_length) - 1 ~= data(1:min_length));
disp("Number of Errors: " + errors);
