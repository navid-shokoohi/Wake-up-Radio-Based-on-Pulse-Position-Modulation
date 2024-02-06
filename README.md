WAKE_UP RADIO BASED PULSE POSITION MODULATION

This repository contains MATLAB scripts for implementing a Pulse Position Modulation (PPM) communication system. The system consists of two parts: the transmitter and the receiver, each designed to run on a PC with MATLAB installed.
Transmitter

The transmitter script (transmitter.m) generates PPM signals and transmits them using software-defined radio (SDR) hardware. Here's a brief overview of the transmitter functionality:

    Random data generation: Random symbols are generated according to the specified parameters.
    PPM Generation: Pulse Position Modulation (PPM) frames are generated based on the random data and a predefined dictionary.
    Configuration: The transmitter is configured with the appropriate settings for the SDR hardware, such as center frequency, baseband sample rate, and gain.
    Signal Transmission: The PPM signal is transmitted using the SDR hardware.

Receiver

The receiver script (receiver.m) captures the transmitted PPM signal using SDR hardware and decodes the received symbols. Here's a summary of the receiver functionality:

    Signal Reception: The receiver captures the transmitted signal using the configured SDR hardware.
    Signal Processing: The received signal is processed to align with the transmitted dictionary and perform envelope detection.
    Decoding: Maximum Likelihood (ML) decoding is performed to determine the received symbols.
    Error Evaluation: The received symbols are compared with the transmitted symbols to evaluate the number of errors.

Dependencies

Both scripts require MATLAB and the Communications Toolbox. Additionally, the receiver script requires access to compatible SDR hardware, such as the Pluto SDR.
Usage

    Ensure MATLAB and the required toolboxes are installed.
    Connect the SDR hardware (e.g., Pluto SDR) to the computer.
    Run the transmitter script (transmitter.m) to transmit PPM signals.
    Run the receiver script (receiver.m) to receive and decode the transmitted signals.

Please ensure that the transmitter and receiver are configured with compatible settings (e.g., center frequency, baseband sample rate) to ensure successful communication.

For detailed instructions and parameter configurations, refer to the comments within the MATLAB scripts.
License

This project is licensed under the MIT License. Feel free to modify and distribute the code for your purposes.

For any questions or issues, please create an issue on the GitHub repository. We welcome contributions and feedback.