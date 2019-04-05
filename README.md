# EmbededSystemsDesign
ESD 1

Educational Objective

The educational objective of this lab is to further investigate the use of the component editor to create a custom IP module block that can be instantiated in QSYS, to understand the difference between 8/16/32- bit memory access, and to reinforce concepts of using functions, polling and interrupts.

Technical Objective

The technical objective of this laboratory is to use the Component Editor in the QSYS to add custom IP to a Nios II system. The custom IP being added is a RAM module that will utilize the Cyclone V FPGA block RAM. A RAM confidence test, which can be used for board debug, will be developed. The RAM test will run continuously until the user presses KEY1 on the DE1-SoC board, thus generating an interrupt that will terminate the test.