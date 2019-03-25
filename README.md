# EmbededSystemsDesign
Education Objective

The educational objective of this laboratory is to investigate the creation of custom IP to interface with the NIOS II on the Avalon Switch Fabric. This lab is two parts, combined with Lab 5. Lab 4 focuses on the creation of the core, and Lab 5 on the software interfacing with the component.

Technical Objective

The technical objective of this laboratory is to design an embedded system for the Nios II processor and DE1-SoC development board that will control a servo motor to sweep between two angles.
The embedded system should contain a custom IP that creates the appropriate Pulse-Width Modulation (PWM) signal to sweep the servo-motor’s arm. The system also contains 8 switches for entering the start and stop angles, 2 pushbuttons for “locking” in the angles and 5 seven-segment displays for displaying the start and stop angles.

The system operates as follows:

• The user inputs the start or minimum angle (> 45) in binary using the switches and locks it in
with KEY3.

• The user inputs the stop or maximum angle (<135) in binary using the switches and locks it in
with KEY2.

• The C program passes the angle information to the servo controller.

• The servo controller outputs a waveform to the servo motor that causes it to continuously
sweep from the minimum angle to the maximum angle and back again.

• The angles can be changed at any time and in any order.

