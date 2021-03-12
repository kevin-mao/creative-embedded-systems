#include <WebServer.h>
#include <WiFi.h>
#include <WiFiUdp.h>

const char* ssid = "Man cave 2";
const char* password = "12345678";
WiFiUDP Udp;
unsigned int localUdpPort = 4210;  //  port to listen on
char incomingPacket[255];  // buffer for incoming packets
int xyzPins[] = {36, 32, 14};

void setup()
{
  pinMode(xyzPins[2], INPUT_PULLUP);
  pinMode(25, INPUT_PULLUP);
  pinMode(27, INPUT_PULLUP);
  pinMode(33, INPUT_PULLUP);
  
  int status = WL_IDLE_STATUS;
  Serial.begin(115200);
  WiFi.begin(ssid, password);
  // Wait for connection
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("Connected to wifi");
  Udp.begin(localUdpPort);
  Serial.printf("Now listening at IP %s, UDP port %d\n", WiFi.localIP().toString().c_str(), localUdpPort);

  // we recv one packet from the remote so we can know its IP and port
  bool readPacket = false;
  while (!readPacket) {
    int packetSize = Udp.parsePacket();
    if (packetSize)
     {
      // receive incoming UDP packets
      Serial.printf("Received %d bytes from %s, port %d\n", packetSize, Udp.remoteIP().toString().c_str(), Udp.remotePort());
      int len = Udp.read(incomingPacket, 255);
      if (len > 0)
      {
        incomingPacket[len] = 0;
      }
      Serial.printf("UDP packet contents: %s\n", incomingPacket);
      readPacket = true;
    } 
  }
}

void loop()
{
  int xVal = analogRead(xyzPins[0]);
  int yVal = analogRead(xyzPins[1]);
  int zVal = digitalRead(xyzPins[2]);
  int buttonVal1 = digitalRead(25);
  int buttonVal2 = digitalRead(33);
  int switchVal = digitalRead(27);
  Serial.printf("%d,%d,%d,%d,%d,%d\n", xVal, yVal, zVal, buttonVal1, buttonVal2, switchVal);
  // once we know where we got the inital packet from, send data back to that IP address and port
  Udp.beginPacket(Udp.remoteIP(), Udp.remotePort());
  Udp.printf("%d,%d,%d,%d,%d,%d\n", xVal, yVal, zVal, buttonVal1, buttonVal2, switchVal);
  Udp.endPacket();
  delay(200);
}
