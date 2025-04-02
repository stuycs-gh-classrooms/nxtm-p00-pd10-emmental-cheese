class Orb {

  //instance variables
  PVector center;
  PVector velocity;
  PVector acceleration;
  float bsize;
  float mass;
  color c;


  Orb() {
     bsize = random(10, MAX_SIZE);
     float x = random(bsize/2, width-bsize/2);
     float y = random(bsize/2, height-bsize/2);
     center = new PVector(x, y);
     mass = random(10, 100);
     velocity = new PVector();
     acceleration = new PVector();
     setColor();
  }

  Orb(float x, float y, float s, float m) {
     bsize = s;
     mass = m;
     center = new PVector(x, y);
     velocity = new PVector();
     acceleration = new PVector();
     setColor();
   }

  //movement behavior
  void move(boolean bounce) {
    if (bounce) {
      xBounce();
      yBounce();
    }

    velocity.add(acceleration);
    center.add(velocity);
    acceleration.mult(0);
  }//move

  void applyForce(PVector force) {
    PVector scaleForce = force.copy();
    scaleForce.div(mass);
    acceleration.add(scaleForce);
  }

  PVector getDragForce(float cd) {
    float dragMag = velocity.mag();
    dragMag = -0.5 * dragMag * dragMag * cd;
    PVector dragForce = velocity.copy();
    dragForce.normalize();
    dragForce.mult(dragMag);
    return dragForce;
  }

  PVector getGravity(Orb other, float G) {
    float strength = G * mass*other.mass;
    //dont want to divide by 0!
    float r = max(center.dist(other.center), MIN_SIZE);
    strength = strength/ pow(r, 2);
    PVector force = other.center.copy();
    force.sub(center);
    force.mult(strength);
    return force;
  }

  PVector getBounceForce(Orb other) {
    PVector v1i = this.velocity.copy();
    PVector v2i = other.velocity.copy();
    
    PVector finalForce = new PVector();
    
    float v1ix = v1i.x;
    float v1iy = v1i.y;
    float v2ix = v2i.x;
    float v2iy = v2i.y;
    
    float sumMass = this.mass + other.mass;
    //v1i + v1f = v2i + v2f 
    //v1f = v2f + (v2i - v1i)
    //thus 
    //m1iv1i + m2iv2i = m1fv1f + m2fv2f
    //=
    //m1v1i + m2v2i = m1(v2f + (v2i - v1i)) + m2v2f
    //m1v1i + m2v2i - m1v2i + m1v1i = m1v2f + m2v2f
    //a number = m1 + m2(v2f)
    //div by m1 + m2
    float v2fx = ((this.mass * v1ix) + (other.mass * v2ix) - (this.mass * v2ix) + (this.mass * v1ix)) / sumMass;
    float v2fy = ((this.mass * v1iy) + (other.mass * v2iy) - (this.mass * v2iy) + (this.mass * v1iy)) / sumMass;
    
    finalForce.x = -1 * v2fx;
    finalForce.y = -1 * v2fy;
    return finalForce;
  }
  
  //spring force between calling orb and other
  PVector getSpring(Orb other, int springLength, float springK) {
    PVector direction = PVector.sub(other.center, this.center);
    direction.normalize();

    float displacement = this.center.dist(other.center) - springLength;
    float mag = springK * displacement;
    direction.mult(mag);

    return direction;
  }//getSpring

  boolean yBounce(){
    if (center.y > height - bsize/2) {
      velocity.y *= -1;
      center.y = height - bsize/2;

      return true;
    }//bottom bounce
    else if (center.y < bsize/2) {
      velocity.y*= -1;
      center.y = bsize/2;
      return true;
    }
    return false;
  }//yBounce
  boolean xBounce() {
    if (center.x > width - bsize/2) {
      center.x = width - bsize/2;
      velocity.x *= -1;
      return true;
    }
    else if (center.x < bsize/2) {
      center.x = bsize/2;
      velocity.x *= -1;
      return true;
    }
    return false;
  }//xbounce

  boolean collisionCheck(Orb other) {
    return ( this.center.dist(other.center)
             <= (this.bsize/2 + other.bsize/2) );
  }//collisionCheck

  boolean isSelected(float x, float y) {
    float d = dist(x, y, center.x, center.y);
    return d < bsize/2;
  }//isSelected

  void setColor() {
    color c0 = color(0, 255, 255);
    color c1 = color(0);
    c = lerpColor(c0, c1, (mass-MIN_SIZE)/(MAX_MASS-MIN_SIZE));
  }//setColor

  //visual behavior
  void display() {
    noStroke();
    fill(c);
    circle(center.x, center.y, bsize);
    fill(0);
    //text(mass, center.x, center.y);
  }//display

}//Orb
