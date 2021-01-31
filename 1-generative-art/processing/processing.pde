import processing.net.*;
Client myClient;

int numFrames = 34;  // The number of frames in the animation
int currentFrame = 0;
int positive = 0;
PImage[] images = new PImage[numFrames];
byte[] byteBuffer = new byte[10];

void setup() {
  fullScreen();
  myClient = new Client(this, "127.0.0.1", 50007);
  
  // skip first 5 frames because they're a different size
  for (int i = 5; i < numFrames+5; i++) {
   String imageName = "roaree/roaree_" + nf(i, 3) + ".png";
   images[i-5] = loadImage(imageName);
  }
}
 
void draw() {
  background(0);
  int byteCount = myClient.readBytes(byteBuffer);
  if (byteCount > 0 ) {
    // Convert the byte array to a String
    String myString = new String(byteBuffer);
   
    // No idea why I need to do this - int() returns 0
    positive = int(float(myString));
    
    // reset buffer
    byteBuffer = new byte[10];
  }

  if (positive != 0) {
    // Use % to cycle through frames
    currentFrame = (currentFrame+1) % numFrames;
    float w = 1000 / int(sqrt(positive));
    int x = 0;
    int y = 0;
    int count = 0;
    int offset = 0;
    for (x = 400; x < 1400; x += w) { 
      for (y = 40; y < 1040; y += w) {
        image(images[(currentFrame+offset) % numFrames], x, y, w, w);
        offset+=2;
        count++;
      }
    }
    
    y = 40;
    for (int left = 0; left < positive - count; left++) {
      image(images[(currentFrame+offset) % numFrames], x, y, w, w);
      y += w;
      offset+=2;
    }
  }
}
