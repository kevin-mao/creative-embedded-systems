/**
 * Linear Motion. 
 * 
 * Changing a variable to create a moving line.  
 * When the line moves off the edge of the window, 
 * the variable is set to 0, which places the line
 * back at the bottom of the screen. 
 */
import processing.net.*;
Client myClient;
float a;
String s;
byte[] byteBuffer = new byte[10];

void setup() {
  size(640, 360);
  stroke(255);
  a = height/2;
  myClient = new Client(this, "127.0.0.1", 50007);
}

void draw() {
  int byteCount = myClient.readBytes(byteBuffer); 
  if (byteCount > 0 ) {
    // Convert the byte array to a String
    String myString = new String(byteBuffer);
    
    // No idea why I need to do this - int() returns 0
    int increase = int(float(myString));
    println(increase);
  } 
  background(51);
  line(0, a, width, a);  
  a = a - 0.5;
  if (a < 0) { 
    a = height; 
  }
}
