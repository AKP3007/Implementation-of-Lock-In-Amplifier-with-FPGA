//Arduino code for DAC of 2 bytes Digiatl Data requested from Arduino Board and read the output  from AOUT pin of PCF8591 for checking the DAC conversion capabilities of PCF8591.
#include <Wire.h>
#include <Adafruit_PCF8591.h>

Adafruit_PCF8591 pcf = Adafruit_PCF8591();

void setup() {
    Serial.begin(9600);
  if (!pcf.begin()) {
    Serial.println("# PCF8591 not found!");
    while (1) delay(10);
      }
  Serial.println("# PCF8591 found");
  Wire.begin();
  //pcf.enableDAC(true);
}

void loop() {
 Wire.beginTransmission(0x48);  // Address of the PCF8591 module
  Wire.write(0);                 // Set control byte to 0 (analog input channel 0)
  Wire.endTransmission();
  Wire.requestFrom(0x48, 1);     // Request 2 bytes of data from the PCF8591
  if (Wire.available()){// >= 2)
    int analogValue = Wire.read();          // Read the first byte (MSB)
    Serial.println(analogValue);
  delay(500);  // Delay between readings
}

