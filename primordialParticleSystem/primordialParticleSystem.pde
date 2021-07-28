
ArrayList<Particle> particles;

float alpha, beta, r, v;

void setup () {
  
  frameRate(60);
  size(720,720,P2D);
  
  alpha = PI;
  beta = radians(17);
  r = 50;
  v = 6.7;
  
  particles = new ArrayList<Particle>();
  
  for (int i = 0; i < width*height*0.0007; i++) {
    
    particles.add(new Particle(new PVector(random(0, width), random(0, height)), v, random(0, 2*PI)));
   
  }
  
  /*for (int i = 0; i < 690; i++) {
    
    particles.add(new Particle(new PVector(width/2, height/2), v, random(0, 2*PI)));
    
  }*/
  
}

void draw () {
  colorMode(RGB, 255,255,255);
  background(255,255,255);
  
  updateParticles();
  updateParticles();
    
  for (Particle particle : particles) {
   
    particle.render();
    
  }
  
  colorMode(RGB, 255,255,255);
  fill(0);
  text(frameRate, 100, 100);
  text("Particles: "+particles.size()+" ("+(float) particles.size()*1000/(width*height)+" mp/su)", 100, 120);
  text("alpha: "+degrees(alpha)+"  beta: "+degrees(beta), 100, 140);
  text("radius: "+r+"  velocity: "+v, 100, 160);

}


void updateParticles () {
  
  for (Particle particle : particles) {
    
    particle.resetVicinity();
    
  }
  
  for (int i = 0; i < particles.size(); i++) {
      
    for (int j = i+1; j < particles.size(); j++) {
      
      if (!particles.get(i).equals(particles.get(j))) {
        
        float sX = ToroidalDistanceX(particles.get(i).pos.x, particles.get(j).pos.x);
        
        if (abs(sX) < r) {
          
          float sY = ToroidalDistanceY(particles.get(i).pos.y, particles.get(j).pos.y);
          
          if (abs(sY) < r) {
            
            float sD = (sX * sX) + (sY * sY);
            
            if (sD < r*r) {
              
              particles.get(i).N ++; particles.get(j).N ++; 
              
              float sA = scope(atan2(sY, sX), TAU);
              
              if (scope(sA-particles.get(i).phi, TAU) < PI) particles.get(i).R ++;
              else particles.get(i).L ++;
              if (scope(sA-particles.get(j).phi, TAU) > PI) particles.get(j).R ++;
              else particles.get(j).L ++;
              
            }
          }
        }
      }
    }
    
    // delta_phi = alpha + beta * N * sign(R - L)
    particles.get(i).setDeltaPhi(alpha + (beta * particles.get(i).N * Math.signum(particles.get(i).R - particles.get(i).L)));
    
    /*
    colorMode(RGB, 255, 255, 255);
    if (15 < particles.get(i).N && particles.get(i).N <= 35) {
      particles.get(i).setColor(color(0,0,255));
    } else if (particles.get(i).N > 35) {
      particles.get(i).setColor(color(255,255,0));
    } else if (13 < particles.get(i).N && particles.get(i).N <= 15) {
      particles.get(i).setColor(#DE8416);
    } else {
      particles.get(i).setColor(color(0,255,0));
    }
    /*if (vicinity[3] > 15) {
      particle.setColor(color(255,0,255));
    } */
    
    colorMode(HSB, 360, 100, 100);
    particles.get(i).setColor(color((particles.get(i).N*8+100)%360, 100, 60));
    
  }
  
  for (Particle particle : particles) {
    
    particle.update();
    
  }
  
}


float ToroidalDistance (float x1, float y1, float x2, float y2)
{
    float dx = abs(x2 - x1);
    float dy = abs(y2 - y1);
 
    if (dx > width/2)
        dx = width - dx;
 
    if (dy > height)
        dy = height - dy;
 
    return sqrt(dx*dx + dy*dy);
}

float ToroidalDistanceX (float x1, float x2) {
  
  float dx = x2 - x1;
 
  if (abs(dx) > width/2)
      dx = width - abs(dx);
      
  return dx;
  
}

float ToroidalDistanceY (float y1, float y2) {
  
  float dy = y2 - y1;
 
  if (abs(dy) > height/2)
      dy = height - abs(dy);
      
  return dy;
  
}

PVector getClosestPos2 (PVector pos1, PVector pos2) {
   
  float[] x2options = new float[] {pos2.x, pos2.x-width, width+pos2.x} ;
  float minXDist = min(abs(x2options[0]-pos1.x), abs(x2options[1]-pos1.x), abs(x2options[1]-pos1.x));
  
  float[] y2options = new float[] {pos2.y, pos2.y-height, height+pos2.y} ;
  float minYDist = min(abs(y2options[0]-pos1.y), abs(y2options[1]-pos1.y), abs(y2options[1]-pos1.y));
  
  
  
  if (minXDist == abs(x2options[0]-pos1.x)) {
    
    if (minYDist == abs(y2options[0]-pos1.y)) {
      return pos2;
    } else if (minYDist == abs(y2options[1]-pos1.y)) {
      return new PVector(pos2.x, pos2.y-height);
    } else {
      return new PVector(pos2.x, height+pos2.y);
    }
    
  } else if (minXDist == abs(x2options[1]-pos1.x)) {
    
    if (minYDist == abs(y2options[0]-pos1.y)) {
      return new PVector(pos2.x-width, pos2.y);
    } else if (minYDist == abs(y2options[1]-pos1.y)) {
      return new PVector(pos2.x-width, pos2.y-height);
    } else {
      return new PVector(pos2.x-width, height+pos2.y);
    }
    
  } else {
    
    if (minYDist == abs(y2options[0]-pos1.y)) {
      return new PVector(width+pos2.x, pos2.y);
    } else if (minYDist == abs(y2options[1]-pos1.y)) {
      return new PVector(width+pos2.x, pos2.y-height);
    } else {
      return new PVector(width+pos2.x, height+pos2.y);
    }
    
  }
  
  
}

void keyReleased () {
  
  if (key == ' ') {
    looping = !looping;
  }
  
}

void mouseReleased () {
  
  for (int i = 0; i < 15; i++) {
    
    particles.add(new Particle(new PVector(mouseX, mouseY), v, random(0, 2*PI)));
    
  }
  
}

float scope(float val, float max) {
  // Ensure values are between 0 and max
  if (val>max) val=val%max;
  else if (val<0) val=max+(val%max);
  return val;
}
