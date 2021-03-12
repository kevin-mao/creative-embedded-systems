/**
 * Simple Read
 * 
 * Read data from the serial port and change the color of a rectangle
 * when a switch connected to a Wiring or Arduino board is pressed and released.
 * This example works with the Wiring / Arduino program that follows below.
 */


import hypermedia.net.*;


UDP udp;  // define the UDP object    
String ip = "192.168.245.170";  // the remote IP address
int port = 4210;    // the destination port
    
int x, y;
String state;
String shape;

// xVal, yVal, zVal, buttonVal1, buttonVal2, switchVal
final int X = 0, Y = 1, Z = 2, BUTTON1 = 3, BUTTON2 = 4, SWITCH = 5;

int count;
int lastSwitch;
int restart ;
NPC[] npcArray; 
String[] vals = {"1600", "1600", "1", "1", "1", "1"};

void setup() {
  fullScreen(2);
  textSize(32);
  
  udp = new UDP( this, 4210 );
  udp.listen( true );
  // signal to arduino to begin sending over sensor readings
  udp.send( "Game starting..", ip, port );
  
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
  
void drawNPCs() {
  // randomly switch states
  if (random(100) < 10 && lastSwitch >= 150) {
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
    int xVal = int(vals[X].trim());
    int yVal = int(vals[Y].trim());
    
    // if flipped again, stop game
    Boolean flipped = int(vals[SWITCH].trim()) == 1;
    if (!state.equals("off") && flipped) {
      state = "off";
      return;
    }
    if (int(vals[BUTTON1].trim()) == 0) {
      shape = "circle";
    } else if (int(vals[BUTTON2].trim()) == 0) {
      shape = "square";
    }
    
    if (xVal < 1000) {
      xChange = -20;
    } else if (xVal > 1000 && xVal < 1500) {
      xChange = -10;
    } else if (xVal > 2000 && xVal < 3000) {
      xChange = 10;
    } else if (xVal > 3000) { 
      xChange = 20;
    }
    
    
    if (yVal < 1000) {
      yChange = -20;
    } else if (yVal > 1000 && yVal < 1500 ) {
      yChange = -10;
    } else if (yVal > 2000 && yVal < 3000) {
      yChange = 10;
    } else if (yVal > 3000) { 
      yChange = 20;
    }
    
    x += xChange;
    y += yChange;
    
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
  // while state is off, check if user flips switch
  if (state.equals("off")) { 
    String s = "Flip the switch to explore! Flip again to stop.";
    String s2 = "Press the green button to wear circle shape.";
    String s3 = "Press the red button to wear square shape.";
    String s4 = "Blend in and avoid contact for as long as you can!";
    text(s, width/2-400, height/2-50); 
    text(s2, width/2-400, height/2); 
    text(s3, width/2-400, height/2+50); 
    text(s4, width/2-400, height/2+100); 
      
    int switchVal = int(vals[SWITCH]);

    if (switchVal == 0) {
      state = "circle";
    }
  } else {
    if (restart == 100) {
      restart = 0;
      count = 0;
      lastSwitch = 0;
      state = "square";
      shape= "tri";
      x = (width / 2) - 50;
      y = height-100;
      initializeNPC();
    }
    if (state.equals("over")) {
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
        if (count == 150) {
          state = "over";
        }
      }
    }
  }
}
  
void receive(byte[] data) {
   String raw = new String(data).trim();
   println(raw);
   vals = split(raw, ",");
}
