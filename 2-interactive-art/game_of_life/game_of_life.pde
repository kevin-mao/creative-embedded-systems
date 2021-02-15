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

int count;
int lastSwitch;
int restart ;
NPC[] npcArray; 

void setup() {
  fullScreen();
  smooth();

  textSize(32);
  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 9600);
  x = (width / 2) - 50;
  y = height-100;
  
  state = "off";
  shape = "tri";
  count = 0;
  lastSwitch = 0;
  restart = 0;
  
  npcArray = new NPC[10];
  initializeNPC();
}

void initializeNPC() {
  for(int i=0; i< npcArray.length; i++) { 
    npcArray[i] = new NPC((i+1) * 180, (i+1) * 100, 100);   
  }
}
  
String[] readData() {
  String raw = myPort.readStringUntil('\n');
  return split(raw, ",");
}

  
void drawNPCs() {
  // randomly switch states
  if (random(100) < 10 && lastSwitch >= 500) {
    count = 0;
    lastSwitch = 0;
    if (state.equals("circle")) {
      state = "square";
    } else if (state.equals("square")) {
      state = "circle";
    }
  }

  for(int i=0; i<npcArray.length; i++) {
    npcArray[i].update();
    npcArray[i].checkCollisions();
    npcArray[i].draw(state); 
  }
  lastSwitch++;
}

Boolean conforming() {
  return shape.equals(state);
}

void drawCharacter() {
    int xChange = 0;
    int yChange = 0;
    if ( myPort.available() > 0) {  // If data is available,
      String[] vals = readData();
      int xVal = int(vals[X].trim());
      int yVal = int(vals[Y].trim());
      
      // if flipped again, stop game
      Boolean flipped = int(vals[SWITCH].trim()) == 1;
      if (flipped) {
        state = "off";
        return;
      }
      if (int(vals[BUTTON1].trim()) == 0) {
        shape = "circle";
      } else if (int(vals[BUTTON2].trim()) == 0) {
        shape = "square";
      }
      
      if (xVal < 1000) {
        xChange = -40;
      } else if (xVal > 1000 && xVal < 1700) {
        xChange = -20;
      } else if (xVal > 2000 && xVal < 3000) {
        xChange = 20;
      } else if (xVal > 3000) { 
        xChange = 40;
      }
      
      
      if (yVal < 1000) {
        yChange = -50;
      } else if (yVal > 1000 && yVal < 1700) {
        yChange = -20;
      } else if (yVal > 2000 && yVal < 3000) {
        yChange = 20;
      } else if (yVal > 3000) { 
        yChange = 50;
      }
      
      x += xChange;
      y += yChange;
    }
    if (shape.equals("circle")) {
      ellipse(x, y, 80, 80);
    } else if (shape.equals("tri")) {
      triangle(x, y, x+40, y-40, x+80, y);
    } else if (shape.equals("square")) {
      square(x, y, 80);
    }
}

Boolean collision() {
  for (NPC npc: npcArray) {
    if (abs(npc.x - x) < 80 && abs(npc.y - y) < 80) {
      return true;
    }
  }
  return false;
}
  
void draw() {
  background(50);
  // while port is available and state is off, check if user flips switch
  if ( myPort.available() > 0 && state.equals("off")) { 
    int switchVal = int(readData()[SWITCH].trim());

    if (switchVal == 0) {
      state = "circle";
    }
  }
  if (restart == 100) {
    restart = 0;
    count = 0;
    lastSwitch = 0;
    state = "square";
    shape= "tri";
    initializeNPC();
  }
  if (state.equals("off")) {
    String s = "Flip the switch to explore! Flip again to stop.";
    String s2 = "Press the green button to wear circle shape.";
    String s3 = "Press the red button to wear square shape.";
    String s4 = "Blend in and avoid contact for as long as you can!";
    text(s, width/2-400, height/2-50); 
    text(s2, width/2-400, height/2); 
    text(s3, width/2-400, height/2+50); 
    text(s4, width/2-400, height/2+100); 
  } else if (state.equals("over")) {
    String s = "You didn't conform to the norm!";
    text(s, width/2-250, height/2);
    restart++;
  } else if (state.equals("failed")) {
    String s = "You were noticed!";
    text(s, width/2-150, height/2);
    restart++;
  } else {
    drawNPCs();
    drawCharacter();
    if (collision()) {
      state = "failed";
    }

    if (!conforming()) {
      count++;
      if (count == 200) {
        state = "over";
      }
    }
  }
}
