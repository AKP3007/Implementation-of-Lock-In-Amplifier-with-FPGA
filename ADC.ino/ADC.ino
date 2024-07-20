// Arduino Code for reading the analog inputs from different pins of PCF8591 and converting the ADC convereted values to analog values for easier understanding.
// Include Adafruit PCF8591 library
#include <Adafruit_PCF8591.h>
// Define the reference voltage for ADC conversion
#define ADC_REFERENCE_VOLTAGE 5.0

// Create an instance of the PCF8591 module
Adafruit_PCF8591 pcf =   Adafruit_PCF8591();

void setup() {
  // put your setup code here, to run once:
Serial.begin(9600);
  Serial.println("# Adafruit PCF8591 demo");
  if (!pcf.begin()) {
    Serial.println("# PCF8591 not found!");
    while (1) delay(10);
      }
  Serial.println("# PCF8591 found");
  pcf.enableDAC(true);
}
////Uncomment these lines of the code (i.e. 21-32) while commenting the lines from 22-46 of the code to take reading from PCF8591's Photoresistor(AIN2)'s readings.
int AIN0; // Declare AIN0 globally

void loop() {
  AIN0 = pcf.analogRead(0);
  pcf.analogWrite(AIN0);
  Serial.print("AIN0: ");
  Serial.print(AIN0);
  Serial.print(", ");
  Serial.print(int_to_volts(AIN0, 8, ADC_REFERENCE_VOLTAGE));
  Serial.println("V");
  delay(500);
}
/* Uncomment these lines of the code (i.e. 33-45) while commenting the remaining lines from 22-59 of the code to take reading from PCF8591's Thermistor(AIN1)'s readings.

int AIN1; / Declare AIN1 globally

void loop() {
  AIN1 = pcf.analogRead(1);
  pcf.analogWrite(AIN1);
  Serial.print("AIN1: ");
  Serial.print(AIN1);
  Serial.print(", ");
  Serial.print(int_to_volts(AIN1, 8, ADC_REFERENCE_VOLTAGE));
  Serial.println("V");
  delay(500);
}
//Uncomment these lines of the code (i.e. 47-58) while commenting the lines from 22-46 of the code to take reading from PCF8591's Photoresistor(AIN2)'s readings.
int AIN2; // Declare AIN2 globally

void loop() {
  AIN2 = pcf.analogRead(2);
  pcf.analogWrite(AIN2);
  Serial.print("AIN2: ");
  Serial.print(AIN2);
  Serial.print(", ");
  Serial.print(int_to_volts(AIN2, 8, ADC_REFERENCE_VOLTAGE));
  Serial.println("V");
  delay(500);
}
*/
float int_to_volts(uint16_t dac_value, uint8_t bits, float logic_level) {
  return (((float)dac_value / ((1 << bits) - 1)) * logic_level);
}
