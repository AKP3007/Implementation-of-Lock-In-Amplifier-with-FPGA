// The below code file must be put in the same folder as that of the i2c_Master.v or else it may not function properly. This code is for controlling the DAC operation of the interfaced PCF8591 and read the digtal inputs from the FPGA and convert it to analog signal to be received through the AOUT pin of PCF8591.
`include "I2C_Master.v"
module PCF8591_DAC (
  input wire clk,
  input wire reset,
  output reg [7:0] dacDataOut,
  inout wire sda,
  inout wire scl
);

  // I2C Control Signals
  wire [7:0] i2cAddress;
  wire i2cRead;
  wire i2cWrite;
  
  // I2C Data Signals
  wire [7:0] i2cDataOut;
  wire [7:0] i2cDataIn;
  wire i2cDataValid;
  
// This section sets up the address and data for the PCF8591 device
  reg [7:0] pcf8591Address = 8'b1001000;  // PCF8591 device address
  reg [7:0] pcf8591Data;
  wire pcf8591DataValid;
  
  // Clock Domain Crossing // // This block generates a 100kHz I2C clock from the system clock and handles the data transfer to the PCF8591 when the conditions are met.
    if (reset) begin
  reg [3:0] i2cClkCounter = 4'b0;
  reg i2cClk;
  
  always @(posedge clk) begin
      pcf8591Data <= 8'b0;
    end else begin
      i2cClkCounter <= i2cClkCounter + 1;
      if (i2cClkCounter >= 24) begin  // Generate 100kHz I2C clock from system clock to match the I2C communication frequency.
        i2cClkCounter <= 4'b0;
        i2cClk <= ~i2cClk;
      end
      if (i2cDataValid && (i2cAddress == pcf8591Address) && i2cWrite) begin
        pcf8591Data <= i2cDataIn;
      end
    end
  end
  
  // PCF8591 DAC Write Control //These registers control the I2C transfer operations, including start and stop conditions, address, data, and read/write operations.
  reg i2cStart;
  reg i2cStop;
  reg [7:0] i2cTransferAddress;
  reg [7:0] i2cTransferData;
  reg i2cTransferRead;
  reg i2cTransferWrite;
  reg i2cTransferActive;
  
  always @(posedge i2cClk) begin //When the reset signal is active, all control signals and data registers are reset to their default values.
    if (reset) begin
      i2cStart <= 1'b0;
      i2cStop <= 1'b0;
      i2cTransferAddress <= 8'b0;
      i2cTransferData <= 8'b0;
      i2cTransferRead <= 1'b0;
      i2cTransferWrite <= 1'b0;
      i2cTransferActive <= 1'b0;
    end else begin
      if (!i2cTransferActive && ~i2cStop) begin // If no transfer is active and the stop condition is not set, this block initiates a new I2C transfer by setting i2cStart to 1 and preparing the transfer data and address.
        i2cStart <= 1'b1;
        i2cStop <= 1'b0;
        i2cTransferAddress <=  pcf8591Address;
        i2cTransferData <= 8'b01000000; //  Control byte to enable DAC
        i2cTransferRead <= 1'b0;
        i2cTransferWrite <= 1'b1;
        i2cTransferActive <= 1'b1;
      end else if (i2cTransferActive) begin // If a transfer is already active, this block continues the transfer by maintaining the active state and updating the transfer address and data.
        i2cStart <= 1'b0;
        i2cStop <= 1'b0;
        i2cTransferAddress <= pcf8591Address;
        i2cTransferData <= pcf8591Data; // Data to be written to DAC
        i2cTransferRead <= 1'b0;
        i2cTransferWrite <= 1'b1;
        i2cTransferActive <= 1'b1;
      end else begin // If neither of the above conditions is met, this block ends the I2C transfer by setting i2cStop to 1 and resetting the control signals and data registers.
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
  
  // Connect I2C Master Module to PCF8591 DAC Write Control Signals
  assign i2cAddress = i2cTransferAddress; // Connects the I2C address line to the transfer address
  assign i2cRead = i2cTransferRead; // Connects the I2C read signal to the transfer read signal
  assign i2cWrite = i2cTransferWrite; // Connects the I2C write signal to the transfer write signal
  assign i2cDataOut = i2cTransferData; //  Connects the I2C data output to the transfer data
  
  // Connect PCF8591 DAC Write Data
  assign pcf8591DataValid = i2cDataValid && (i2cAddress == pcf8591Address) && i2cWrite; // Validates the data for the PCF8591 DAC write operation by check if or not the following conditions are met:- 1. The data on the I2C bus is valid., 2. The I2C address matches the PCF8591 device address.and 3. The I2C operation is a write operation. 
  
endmodule
