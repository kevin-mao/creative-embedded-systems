import processing.net.*;
Client myClient;

int numFrames = 39;  // The number of frames in the animation
int currentFrame = 0;
int positive = 0;
PImage[] images = new PImage[numFrames];
    
void setup() {
  fullScreen();
  myClient = new Client(this, "127.0.0.1", 50007);
  
  int byteCount = myClient.readBytes(byteBuffer); 
  if (byteCount > 0 ) {
    // Convert the byte array to a String
    String myString = new String(byteBuffer);
    
    // No idea why I need to do this - int() returns 0
    int positive = int(float(myString));
  }

  for (int i = 0; i < numFrames; i++) {
   String imageName = "roaree/roaree_" + nf(i, 3) + ".png";
   images[i] = loadImage(imageName);
  }
}
 
void draw() {
  background(0);
  currentFrame = (currentFrame+1) % numFrames;  // Use % to cycle through frames
  int offset = 0;
  for (int x = 0; x < width; x += images[0].width) { 
    image(images[(currentFrame+offset) % numFrames], x, -20);
    offset+=2;
    image(images[(currentFrame+offset) % numFrames], x, height/2);
    offset+=2;
  }
}
