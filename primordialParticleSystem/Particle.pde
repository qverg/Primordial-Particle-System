class Particle {
  
  PVector pos;
  float vel;
  float phi;
  float delta_phi=0;
  
  color c = color(0,255,0);
  
  float L = 0;
  float R = 0;
  float N = 0;
  
  Particle (PVector pos, float vel, float phi) {
    
    this.pos = pos;
    this.vel = vel;
    this.phi = phi;
    
  }
  
  void update () {
    
    phi += delta_phi;
    pos = vecAdd(pos, new PVector(cos(phi), sin(phi)).mult(vel));
    //pos.add(new PVector(cos(phi), sin(phi)).mult(vel));
    
  }
  
  void render () {
    
    
    //pos.add(new PVector(cos(phi), sin(phi)).mult(vel));
    
    fill(c);
    noStroke();
    ellipseMode(CENTER);
    ellipse(pos.x, pos.y, 8, 8);
    
    /*stroke(255,0,0);
    strokeWeight(1);
    noFill();
    ellipseMode(RADIUS);
    ellipse(pos.x, pos.y, 50, 50);
    line(pos.x, pos.y, pos.x+cos(phi)*50, pos.y+sin(phi)*50);*/
    
  }
  
  void setDeltaPhi (float new_delta_phi) {
    
    delta_phi = new_delta_phi;
    
  }
  
  void setColor (color newColor) {
    
    c = newColor;
    
  }
  
  PVector vecAdd (PVector v1, PVector v2) {  // for wrapped toroidal space
    
    PVector newVec = new PVector();
    
    newVec.x = (v1.x + v2.x) % width;
    newVec.y = (v1.y + v2.y) % height;
    
    if (newVec.x < 0) newVec.x = width + newVec.x;
    if (newVec.y < 0) newVec.y = height + newVec.y;
    
    return newVec;
    
  }
  
  void resetVicinity () {
    
    L = 0;
    R = 0;
    N = 0;
    
  }
    
  
}
