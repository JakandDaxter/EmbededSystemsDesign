quartus_sh -t compile.tcl
cd output_files
quartus_pgm -c USB-Blaster -m JTAG -o P;top_level.sof
pause