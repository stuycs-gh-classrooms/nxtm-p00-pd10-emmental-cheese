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

  void applyBounceForce(Orb other) {
    PVector touchPoint = findTouchPoint(this.center, other.center, this.bsize/2, other.bsize/2);
    PVector vectorImpact = PVector.sub(this.center, touchPoint);
    
    float magV1 = getMagV(this.velocity);
    float magV2 = getMagV(other.velocity);

    float theta1 = atan2(this.velocity.x, this.velocity.y);
    float theta2 = atan2(other.velocity.x, other.velocity.y);

    float thetaImpact = atan2(vectorImpact.x, vectorImpact.y);
    
    float v1x = magV1 * cos(theta1 - thetaImpact) * (this.mass - other.mass) + 2*other.mass*magV2*cos(theta2-thetaImpact);
    float v1fx = v1x / (this.mass + other.mass) * (cos(thetaImpact) + magV1*sin(theta1 - thetaImpact)*cos(thetaImpact + PI/2));

    float v1y = magV1 * cos(theta1 - thetaImpact) * (this.mass - other.mass) + 2*other.mass*magV2*cos(theta2-thetaImpact);
    float v1fy = v1y / (this.mass + other.mass) * (sin(thetaImpact) + magV1*sin(theta1 - thetaImpact)*sin(thetaImpact + PI/2));


    float v2x = magV2 * cos(theta2 - thetaImpact) * (other.mass - this.mass) + 2*this.mass*magV2*cos(theta1-thetaImpact);
    float v2fx = v2x / (this.mass + other.mass) * (cos(thetaImpact) + magV2*sin(theta2 - thetaImpact)*cos(thetaImpact + PI/2));

    float v2y = magV2 * cos(theta2 - thetaImpact) * (other.mass - this.mass) + 2*this.mass*magV2*cos(theta1-thetaImpact);
    float v2fy = v2y / (this.mass + other.mass) * (sin(thetaImpact) + magV2*sin(theta2 - thetaImpact)*sin(thetaImpact + PI/2));

    this.velocity.x = v1fx;
    this.velocity.y = v1fy;
    
    other.velocity.x = v2fx;
    other.velocity.y = v2fy;
}

  float getMagV(PVector v) {
    return sqrt(v.x*v.x + v.y*v.y);
  }

  PVector findTouchPoint(PVector pos1, PVector pos2, float radius1, float radius2) {
    PVector direction = PVector.sub(pos2, pos1);
    direction.normalize();
    PVector point1 = PVector.add(pos1, direction.mult(radius1));
    PVector point2 = PVector.add(pos2, direction.mult(radius2));
    PVector touchPoint = PVector.add(point1, point2);
    touchPoint.div(2); 
    return touchPoint;
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

  boolean yBounce() {
    if (center.y > height - bsize/2) {
      velocity.y *= -1;
      center.y = height - bsize/2;

      return true;
    }//bottom bounce
    else if (center.y < (bsize/2 + 50)) {
      velocity.y*= -1;
      center.y = bsize/2 + 50;
      return true;
    }
    return false;
  }//yBounce
  boolean xBounce() {
    if (center.x > width - bsize/2) {
      center.x = width - bsize/2;
      velocity.x *= -1;
      return true;
    } else if (center.x < bsize/2) {
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
    color c0 = color(0, 0, 255);
    color c1 = color(255, 0, 0);
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
