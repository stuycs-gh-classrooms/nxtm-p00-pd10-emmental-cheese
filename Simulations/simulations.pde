//planets orbit fixed orb, use array of orbs
//spring force with fixed orb, use linked lists
//drag force involves 2+ orbs moving thru 2+ areas w diff drag
//no limits on custom force


int NUM_ORBS = 10;
int MIN_SIZE = 10;
int MAX_SIZE = 60;
float MIN_MASS = 10;
float MAX_MASS = 100;
float G_CONSTANT = 1;
float D_COEF = 0.1;

int SPRING_LENGTH = 50;
float  SPRING_K = 0.005;

int MOVING = 0;
int ORBIT = 0;
int BOUNCE = 1;
int SPRING = 1;
int GRAVITY = 2;
int DRAG_FORCE = 2;
int DRAGF = 3;
int COLLISION = 3;
int COMBINATION = 4;
boolean[] toggles = new boolean[4];
String[] modes = {"Moving", "Bounce", "Gravity", "Drag"};

boolean[] simulations = new boolean[5];
String[] types = {"Orbit", "Spring", "Drag", "Collision", "Combination"};

FixedOrb earth;

Orb[] slinky;

void setup() {
  size(600, 600);
  earth = new FixedOrb(width/2, height * 200, 1, 20000);
}//setup

void draw() {
  background(255);
  displayMode();

  if (toggles[MOVING]) {

    if (toggles[GRAVITY]) {
    }
  }//moving
}//draw

void keyPressed() {
  if (key == ' ') {
    toggles[MOVING] = !toggles[MOVING]; print("MOVINGGGG"); print(toggles[MOVING]);
  }
  if (key == 'g') {
    toggles[GRAVITY] = !toggles[GRAVITY];
  }
  if (key == 'b') {
    toggles[BOUNCE] = !toggles[BOUNCE]; print("BOUNCEEEEEE"); print(toggles[BOUNCE]);
  }
  if (key == 'd') {
    toggles[DRAGF] = !toggles[DRAGF];
  }

  if (key == '1') {
    simulations[ORBIT] = !simulations[ORBIT];
    print("ORBIT");
  }
  if (key == '2') {
    simulations[SPRING] = !simulations[SPRING];
    print("SPRING");
  }
  if (key == '3') {
    simulations[DRAG_FORCE] = !simulations[DRAG_FORCE];
    print("DRAG");
  }
  if (key == '4') {
    simulations[COLLISION] = !simulations[COLLISION];
    print("COLLISIONS");
  }
  if (key == '5') {
    simulations[COMBINATION] = !simulations[COMBINATION];
    print("COMBO");
  }
}//keyPressed


void displayMode() {
  textAlign(LEFT, TOP);
  textSize(20);
  noStroke();
  int x = 0;

  for (int m=0; m<toggles.length; m++) {
    //set box color
    if (toggles[m]) {
      print(m);
      fill(0, 255, 0);
    } else {
      fill(100, 0, 0);
    }

    float w = textWidth(modes[m]);
    rect(x, 0, w+5, 20);
    fill(0);
    text(modes[m], x+2, 0);
    x+= w+5;
  }
  x = 0;

  for (int n=0; n<simulations.length; n++) {
    //set box color
    if (simulations[n]) {
      fill(0, 255, 0);
    } else {
      fill(200, 0, 0);
    }

    float w = textWidth(types[n]);
    rect(x, 20, w+5, 20);
    fill(0);
    text(types[n], x+2, 22);
    x+= w+5;
  }
}//display
