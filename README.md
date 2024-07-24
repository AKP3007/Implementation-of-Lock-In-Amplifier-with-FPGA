***All the code files in this repository are a result of the work done on the software front in an attempt to Implement a Digital Lock-In Amplifier using a Cyclone-II FPGA Mini Development Board based on Altera's Cyclone-II EP2C5144TC8N FPGA.***

**Some Important Information to effectively use the code files provided in the repository are as follows:-**
1. All the code files in the repository need additional software and hardware tools to incorporate the desired functionality. On the software front, the Arduino IDE software is required to program the Arduino Board as well as check the desired outputs while softwares like Intel's Quartus-II and ModelSim for Design & Synthesis and Simulation respectively; while on the hardware side, the respective pins have to be connected between the PCF8591, the FPGA Mini Development Board and the Arduino Board using jumper wires while interfacing the PCF8591 with the FPGA Development Board or Arduino Board respectively. 
2. The files meant for interfacing the FPGA Development Board with the PCF8591 must be kept in one folder to function properly.
3. The following are some resources that might be helpful in programming the FPGA as mentioned in the first point:-
   a) https://robu.in/wp-content/uploads/2019/04/Cyclone-II-Device-Handbook.pdf :- Cyclone-II Device Handbook for more details about the specifications of the components on the FPGA.
   b) https://robu.in/wp-content/uploads/2019/04/FPGA-board-schematics.pdf :- This Board Schematics or PIN Map can help with choosing the right PIN for PIN Mapping 
   c) https://www.nxp.com/docs/en/data-sheet/PCF8591.pdf :- Datasheet of PCF8591 to know the specifications of the components on it as well as th PIN configuration.
   d) ![image](https://github.com/user-attachments/assets/c2d76826-81aa-4ac0-9258-1b6841f1da36) :- Diagram for interfacing PCF8591 with Arduino Board taken from https://electropeak.com/learn/interfacing-pcf8591-ad-da-analog-digital-module-with-arduino/
   e) https://www.intel.com/content/www/us/en/software-kit/711791/intel-quartus-ii-web-edition-design-software-version-13-0sp1-for-windows.html :- Quartus-II and ModelSim software compatible with the given Cyclone-II FPGA can be found here.
   f) https://www.arduino.cc/en/software :- Link for Arduino IDE software Download.
   g) https://xdevs.com/doc/HP_Agilent_Keysight/HP%2054610B%20User%20%26%20Service.pdf :- Manual of the Oscilloscope Used.

   
The credit for all these above links go to their respective owners.
