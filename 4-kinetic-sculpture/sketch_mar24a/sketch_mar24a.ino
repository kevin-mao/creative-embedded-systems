#include <WiFi.h>
#include <HTTPClient.h>
#define USE_SERIAL Serial
#include <ESP32Servo.h>

Servo myservo; // create servo object to control a servo
int posVal = 0; // variable to store the servo position
int servoPin = 13; // Servo motor pin

int outPorts[] = {14, 27, 26, 25}; // stepper motor pins

const char *ssid_Router     = "Columbia University"; //Enter the router name

String address = "http://165.227.76.232:3000/km3290/running";

void setup(){
  myservo.setPeriodHertz(50); // standard 50 hz servo
  myservo.attach(servoPin, 500, 2500); // attaches the servo on servoPin to the servo object
  
  USE_SERIAL.begin(115200);
  
  // set pins to output
  for (int i = 0; i < 4; i++) {
    pinMode(outPorts[i], OUTPUT);
  }

  WiFi.begin(ssid_Router);
  USE_SERIAL.println(String("Connecting to ")+ssid_Router);
  while (WiFi.status() != WL_CONNECTED){
    delay(500);
    USE_SERIAL.print(".");
  }
  USE_SERIAL.println("\nConnected, IP address: ");
  USE_SERIAL.println(WiFi.localIP());
  USE_SERIAL.println("Setup End");
}

//Suggestion: the motor turns precisely when the ms range is between 3 and 20
void moveSteps(bool dir, int steps, byte ms) {
  float servoStep = 0;
  for (unsigned long i = 0; i < steps; i++) {
    // servo turn
    if (dir) {
      myservo.write(servoStep); // tell servo to go to position in variable 'pos'
    } else {
      myservo.write(180-servoStep);
    }
    servoStep += 180.0/steps;

    // step turn
    moveOneStep(dir); // Rotate a step
    delay(constrain(ms,3,20)); // Control the speed
  }
}

void moveOneStep(bool dir) {
  // Define a variable, use four low bit to indicate the state of port
  static byte out = 0x01;
  // Decide the shift direction according to the rotation direction
  if (dir) { // ring shift left
    out != 0x08 ? out = out << 1 : out = 0x01;
  } else { // ring shift right
    out != 0x01 ? out = out >> 1 : out = 0x08;
  }
  // Output singal to each port
  for (int i = 0; i < 4; i++) {
    digitalWrite(outPorts[i], (out & (0x01 << i)) ? HIGH : LOW);
  }
}

void loop() {
  if((WiFi.status() == WL_CONNECTED)) {
    HTTPClient http;
    http.begin(address);
 
    int httpCode = http.GET(); // start connection and send HTTP header
    if (httpCode == HTTP_CODE_OK) { 
        String response = http.getString();
        if (response.equals("false")) {
            delay(2000);
        } else if(response.equals("true")) {
          // Rotate a half turn
          moveSteps(true, 16 * 64, 3);

          // Rotate a half turn towards another direction
          moveSteps(false, 16 * 64, 3);
         
        }
        USE_SERIAL.println("Response was: " + response);
    } else {
        USE_SERIAL.printf("[HTTP] GET... failed, error: %s\n", http.errorToString(httpCode).c_str());
    }
    http.end();
  }
}
