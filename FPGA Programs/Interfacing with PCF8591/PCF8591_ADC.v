//The below code file must be put in the same folder as that of the i2c_Master.v or else it may not function properly. This code is for controlling the ADC operation of the interfaced PCF8591 and read the analog inputs from the respective pins by doing any modifications as necessary. By default the code is set to read analog input from pin AIN0. 
`include "I2C_Master.v"
module PCF8591_ADC (
  input wire clk,
  input wire reset,
  input wire i2cDataValid, // Signal indicates when valid data is available on the I2C bus.
  input wire [7:0] i2cData, // 8-bit input carries the data read from the PCF8591.
  output wire [7:0] adcData // 8-bit output provides the converted analog data from the PCF8591.
);

  // PCF8591 Control Signals to control the read and write operations. 
  wire i2cRead; 
  wire i2cWrite;  
  
  // PCF8591 ADC Data 
  wire [7:0] pcf8591Data; // This wire holds the 8-bit data read from the PCF8591.
  wire pcf8591DataValid; // This wire indicates when the data on pcf8591Data is valid.
  
  // PCF8591 AIN0 Read Control
  reg [7:0] pcf8591Address = 8'b1001000;  // PCF8591 device address
  reg i2cStart; 
  reg i2cStop;
  reg [7:0] i2cTransferAddress;
  reg [7:0] i2cTransferData;
  reg i2cTransferRead;
  reg i2cTransferWrite;
  reg i2cTransferActive;
  
always @(posedge clk) begin 
   if (reset) begin  // All i2c signals set to default if reset is on HIGH state.
        i2cStart <= 1'b0;
        i2cStop <= 1'b0;
        i2cTransferAddress <= 8'b0;
        i2cTransferData <= 8'b0;
        i2cTransferRead <= 1'b0;
        i2cTransferWrite <= 1'b0;
        i2cTransferActive <= 1'b0;
    end else begin
    if (!i2cTransferActive && ~i2cStop) begin // If no transfer is active and i2cStop is not set, it initiates a new transfer by setting i2cStart to 1 and i2cStop to 0, and prepares the address and data for writing.
            i2cStart <= 1'b1;
            i2cStop <= 1'b0;
            i2cTransferAddress <= {pcf8591Address, 1'b1};  // Read address
            i2cTransferData <= 8'b0;
            i2cTransferRead <= 1'b1;
            i2cTransferWrite <= 1'b0;
            i2cTransferActive <= 1'b1;
    end else if (i2cTransferActive) begin // If i2cTransferActive is active or true, then the I2C Transfer is in progress with the read signals being active.
            i2cStart <= 1'b0;
            i2cStart <= 1'b0;
            i2cStop <= 1'b0;
            i2cTransferAddress <= {pcf8591Address, 1'b0};  // Write address
            i2cTransferData <= 8'b01000000;  // Control byte to select AIN0, the same needs to be replaced with  8'b01000001 (for AIN1),  8'b01000010 (for AIN2) and  8'b01000011 (for AIN3) respectively.
            i2cTransferRead <= 1'b0;
            i2cTransferWrite <= 1'b1;
            i2cTransferActive <= 1'b1;
    end else begin // // If none of the above condition is met then all the signals are reset to their default states.
            i2cStart <= 1'b0;
            i2cStop <= 1'b1;
            i2cTransferAddress <= 8'b0;
            i2cTransferData <= 8'b0;
            i2cTransferRead <= 1'b0;
            i2cTransferWrite <= 1'b0;
            i2cTransferActive <= 1'b0;
    end
  end
end

  // Connect PCF8591 ADC Module to I2C Master Control Signals
  assign i2cRead = i2cTransferRead; // Connects the I2C read signal
  assign i2cWrite = i2cTransferWrite; // Connects the I2C write signal
  
  // Connect PCF8591 ADC Module to I2C Master Data Signals
  assign pcf8591Data = i2cData; // Connects the data from the I2C bus to the PCF8591 data signal
  assign pcf8591DataValid = i2cDataValid; // Connects the data valid signal from the I2C bus to the PCF8591
  
  // Connect PCF8591 ADC Data to Output
  assign adcData = pcf8591Data; // Outputs the data from the PCF8591 to the adcData signal

endmodule
