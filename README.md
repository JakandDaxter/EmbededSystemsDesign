# EmbededSystemsDesign
ESD 1

Educational Objective

The educational objective of this lab is to investigate the creation of digital signal processing circuitry using VHDL and the implementation of these algorithms in the resources of the Cyclone V FPGA.

Technical Objective

The technical objective of this laboratory is to design and verify both a high pass and a low pass FIR filter in VHDL. These filters will be used to process an audio signal in the next lab.


Background

Filtering is a process of adjusting a signal – for example, removing noise. Noise in a sound waveform is represented by small, but frequent changes to the amplitude of the signal. A simple logic circuit that achieves the task of noise-filtering is an averaging Finite Impulse Response (FIR) filter. A schematic diagram of the filters for this lab is given in figure 1.

• Each Z-1 block represents an enabled register that only latches its input data when its enable signal is active

• Each triangle represents a multiplier that multiplies the input signal with the corresponding coefficient (see table below).

• Each circle represents an adder
For this filter, the input and output data signals are signed 16 bit fixed-point numbers
The filter design will be the same for both the high-pass and the low-pass filter. The difference between the two is in the coefficients, as seen in table 1.