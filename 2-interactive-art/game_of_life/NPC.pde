class NPC {

  float x; 
  float y;
  float xSpeed; 
  float ySpeed; 
  
  float size; 

  NPC(float xpos, float ypos, float csize) {
    x = xpos;
    y = ypos; 
    size = csize;
    
    xSpeed = random(-15, 15); 
    ySpeed = random(-15, 15); 
    
  }

  void update() {
    x += xSpeed; 
    y += ySpeed;  
  }
  
  void checkCollisions() { 
    
    float r = size/2; 
    
    if ( (x<r) || (x>width-r)){ 
      xSpeed = -xSpeed; 
    }  
    
    if( (y<r) || (y>height-r)) { 
      ySpeed = -ySpeed;  
    }
    
  }
  
  void draw(String shape) {
    fill(255); 
    if (shape.equals("circle")) {
      ellipse(x, y, size, size); 
    } else if (shape.equals("square")) {
      square(x, y, size);
    }
    
  }
  
  
}
