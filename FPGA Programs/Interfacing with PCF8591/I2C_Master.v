module I2C_Master (
  input wire clk,
  input wire reset,
  output wire sda,
  inout wire scl
);

  // I2C Control Signals
  wire [7:0] i2cAddress; //8-bit wire holds the address of the I2C slave device (with the last bit containing the Resd/Write operation) that the master wants to communicate with.
  wire i2cRead; // read operation from the slave device.
  wire i2cWrite; // write operation to the slave device.
  
  // I2C Data Signals
  wire [7:0] i2cDataOut;// 8-bit wire carries data from the master to the slave during a write operation.
  wire [7:0] i2cDataIn;// 8-bit wire carries data from the slave to the master during a read operation.
  wire i2cDataValid;//  signal indicates that the data on i2cDataIn is valid and can be read by the master.
  
  // I2C Master Module Instantiation
  I2C_Master_Module i2c_master_inst (
    .clk(clk),
    .reset(reset),
    .sda(sda),
    .scl(scl),
    .i2cAddress(i2cAddress),
    .i2cRead(i2cRead),
    .i2cWrite(i2cWrite),
    .i2cDataOut(i2cDataOut),
    .i2cDataIn(i2cDataIn),
    .i2cDataValid(i2cDataValid)
  );
  
  // PCF8591 Analog Input Read Request
  reg [7:0] pcf8591Address = 8'b1001000;  // PCF8591 device address
  reg [7:0] pcf8591Data;// Data read from PCF8591
  wire pcf8591DataValid;// Used to know if the data on the I2C bus is valid and ready to be read by the master or written to the slave.

  // The following always block ensures that the code gets excecuted only when a posedge of clock is encountered. Additionally, when the reset is at LOW; the code checks if i2cDataValid is true, the slave address (i2cAddress) matches the pcf8591Address and i2cRead is true. Once all these conditions are met, pcf8591Data is updated with the value of i2cDataIn. 
  always @(posedge clk) begin
    if (reset) begin 
      pcf8591Data <= 8'b0; 
    end else begin
      if (i2cDataValid && (i2cAddress == pcf8591Address) && i2cRead) begin
        pcf8591Data <= i2cDataIn;
      end
    end
  end
  
  // PCF8591 Analog Input Read Control
  reg i2cStart; // Control signals for starting the I2C Communication.
  reg i2cStop; // Control signals for stopping the I2C communication.
  reg [7:0] i2cTransferAddress; // The address of the I2C device (PCF8591) to communicate with.
  reg [7:0] i2cTransferData; // Data to be transferred over the I2C bus.
  reg i2cTransferRead; // Control signals for read operations.
  reg i2cTransferWrite; // Control signals for write operations. 
  reg i2cTransferActive; // Indicates whether an I2C transfer is currently active.
  
  always @(posedge clk) begin
    if (reset) begin // All i2c signals set to default if reset is on HIGH state.
      i2cStart <= 1'b0;
      i2cStop <= 1'b0;
      i2cTransferAddress <= 8'b0;
      i2cTransferData <= 8'b0;
      i2cTransferRead <= 1'b0;
      i2cTransferWrite <= 1'b0;
      i2cTransferActive <= 1'b0;
    end else begin
      if (i2cTransferActive) begin // If i2cTransferActive is active or true, then the I2C Transfer is in progress with the read signals being active.
        i2cStart <= 1'b0;
        i2cStop <= 1'b0;
        i2cTransferAddress <= pcf8591Address;
        i2cTransferData <= 8'b0;
        i2cTransferRead <= 1'b1;
        i2cTransferWrite <= 1'b0;
        i2cTransferActive <= 1'b1;
      end else if (!i2cTransferActive && ~i2cStop) begin // If no transfer is active and i2cStop is not set, it initiates a new transfer by setting i2cStart and i2cStop to 1, and prepares the address and data for writing.
        i2cStart <= 1'b1;
        i2cStop <= 1'b1;
        i2cTransferAddress <= 8'b0;
        i2cTransferData <= pcf8591Address;
        i2cTransferRead <= 1'b0;
        i2cTransferWrite <= 1'b1;
        i2cTransferActive <= 1'b1;
      end else begin // If none of the above condition is met then all the signals are reset to their default states.
        i2cStart <= 1'b0;
        i2cStop <= 1'b0;
        i2cTransferAddress <= 8'b0;
        i2cTransferData <= 8'b0;
        i2cTransferRead <= 1'b0;
        i2cTransferWrite <= 1'b0;
        i2cTransferActive <= 1'b0;
      end
    end
  end
  
  // Connect I2C Master Module to PCF8591 Analog Input Read Control Signals
  assign i2cAddress = i2cTransferAddress; // Assigns the I2C address from the transfer address signal.
  assign i2cRead = i2cTransferRead; // Assigns the read control signal for the I2C transfer.
  assign i2cWrite = i2cTransferWrite; // Assigns the write control signal for the I2C transfer.
  assign i2cDataOut = i2cTransferData; // Assigns the data to be transferred out via I2C.
  
  // Connect PCF8591 Analog Input Read Data to Output
  // These assignments ensure that the data read from the PCF8591 is correctly validated and output through the SDA line.
  assign pcf8591DataValid = i2cDataValid && (i2cAddress == pcf8591Address) && i2cRead; // This line ensures that the data from the PCF8591 is valid if the I2C data is valid, the I2C address matches the PCF8591 address, and a read operation is in progress.
  assign sda= pcf8591Data; // This assigns the data from the PCF8591 to the serial data line (SDA).

endmodule
