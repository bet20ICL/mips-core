# IAC_CW
Implementation of MIPS CPU in Iverilog for IAC Coursework

Components:
- regfile : done
- ALU : done 
- skeleton : done
- testbench : work in progress
- control :

questions:
- memory byte how to determine if it's word or byte (how do we implement this?)
- reset  (can we use a jump instruction that jump to reset address, can jumps go to every address? no, how do we resolve 


answers:
- have a flag that does it but can also do it at the recieving end ()
- extra logic, aka hard code it

fatal errors numbers:
- 0 : no errors / success
- 5 : cpu didn't return anything in time
- 1 : wrong value