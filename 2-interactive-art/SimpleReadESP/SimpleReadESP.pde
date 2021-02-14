/**
 * Simple Read
 * 
 * Read data from the serial port and change the color of a rectangle
 * when a switch connected to a Wiring or Arduino board is pressed and released.
 * This example works with the Wiring / Arduino program that follows below.
 */


import processing.serial.*;

Serial myPort;  // Create object from Serial class
int x, y;
String state;
String shape;

// xVal, yVal, zVal, buttonVal1, buttonVal2, switchVal
final int X = 0, Y = 1, Z = 2, BUTTON1 = 3, BUTTON2 = 4, SWITCH = 5;

int rad = 60;        // Width of the shape
float xpos, ypos;    // Starting position of shape    

float xspeed = 2.8;  // Speed of the shape
float yspeed = 2.2;  // Speed of the shape

int xdirection = 1;  // Left or Right
int ydirection = 1;  // Top to Bottom

void setup() {
  fullScreen();

  noStroke();
  frameRate(30);
  ellipseMode(RADIUS);
  xpos = width/2;
  ypos = height/2;

  textSize(32);
  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 9600);
  x = (width / 2) - 50;
  y = height-100;
  state = "off";
  shape = "tri";
}

String[] readData() {
  String raw = myPort.readStringUntil('\n');
  return split(raw, ",");
}

void drawCircles() {
  // Update the position of the shape
  xpos = xpos + ( xspeed * xdirection );
  ypos = ypos + ( yspeed * ydirection );

  // Test to see if the shape exceeds the boundaries of the screen
  // If it does, reverse its direction by multiplying by -1
  if (xpos > width-rad || xpos < rad) {
    xdirection *= -1;
  }
  if (ypos > height-rad || ypos < rad) {
    ydirection *= -1;
  }

  // Draw the shape
  ellipse(xpos, ypos, rad, rad);
}

void draw() {
  background(50);
  if ( myPort.available() > 0 && state.equals("off")) { 
    int switchVal = int(readData()[SWITCH].trim());

    if (switchVal == 0) {
      state = "on";
    }
  }
  if (state.equals("off")) {
    String s = "Flip the switch to explore!";
    text(s, width/2-200, height/2); 
  } else if (state.equals("over")) {
    String s = "You didn't conform to the norm!";
    text(s, width/2-200, height/2);
  } else {
    drawCircles();

    int xChange = 0;
    int yChange = 0;
    if ( myPort.available() > 0) {  // If data is available,
      String[] vals = readData();
      int xVal = int(vals[X].trim());
      if (int(vals[BUTTON1].trim()) == 0) {
        shape = "circle";
      }
      if (xVal < 1000) {
        xChange = -30;
      } else if (xVal > 3000) { 
        xChange = 30;
      }
      x += xChange;
      y += yChange;
    }
    if (shape.equals("circle")) {
      ellipse(x, y, rad, rad);
    } else if (shape.equals("tri")) {
      triangle(x, y, x+50, y-50, x+100, y);
    }
  }
}
